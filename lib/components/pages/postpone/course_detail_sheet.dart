import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/postpone_controller.dart';
import '../../../dialogs/delete_dialog.dart';
import '../../../widgets/pages/postpone/custom_radio_button.dart';
import '../../../utils/logger.dart';
import 'add_postpone.dart';

class CourseDetailSheet extends ConsumerStatefulWidget {
  final String idCurso;
  final String fecha;
  final String hora;
  final String aula;
  final String cursoNombre;
  final String profesor;
  final String facultad;
  final String numseccion;
  final int alumnos;
  final String estado;
  final String observacion;

  const CourseDetailSheet({
    Key? key,
    required this.idCurso,
    required this.fecha,
    required this.hora,
    required this.aula,
    required this.cursoNombre,
    required this.profesor,
    required this.facultad,
    required this.numseccion,
    required this.alumnos,
    required this.estado,
    required this.observacion,
  }) : super(key: key);

  @override
  ConsumerState<CourseDetailSheet> createState() => _CourseDetailSheetState();
}

class _CourseDetailSheetState extends ConsumerState<CourseDetailSheet> {
  final TextEditingController _observationController = TextEditingController();
  bool _isLoading = false;
  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.estado;
    _observationController.text = widget.observacion;
  }

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  Future<void> _handleDelete(BuildContext context) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => const DeleteDialog(),
    );

    if (result == true) {
      setState(() => _isLoading = true);
      try {
        final success = await ref.read(postponeControllerProvider.notifier)
            .deletePostpone(widget.idCurso);

        if (success) {
          // Primero actualizamos la lista
          await ref.read(postponeListProvider.notifier).refresh();

          // Luego cerramos el bottom sheet y mostramos el mensaje
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Postergación eliminada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar: $e')),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToAddPostpone(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPostpone(
          idCurso: widget.idCurso,
          cursoNombre: widget.cursoNombre,
          nombreProfe: widget.profesor,
          nomFacultad: widget.facultad,
          numAula: widget.aula,
          canAlumnos: widget.alumnos,
          numseccion: widget.numseccion,
        ),
      ),
    );
  }

  void _handleStatusChange(String newStatus) {
    setState(() {
      _selectedStatus = newStatus;
    });
  }

  Future<void> _saveChanges() async {
    if (_selectedStatus.isEmpty && _observationController.text.trim().isEmpty) {
      return;
    }

    setState(() => _isLoading = true);
    bool success = true;

    try {
      if (_selectedStatus.isNotEmpty) {
        success = await ref.read(postponeControllerProvider.notifier)
            .updateStatus(widget.idCurso, _selectedStatus);
      }

      if (success && _observationController.text.trim().isNotEmpty) {
        success = await ref.read(postponeControllerProvider.notifier)
            .updateObservation(widget.idCurso, _observationController.text.trim());
      }

      if (success) {
        // Primero actualizamos la lista
        await ref.read(postponeListProvider.notifier).refresh();

        // Luego cerramos el bottom sheet y mostramos el mensaje
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      AppLogger.log('Error al guardar cambios: $e', prefix: 'ERROR');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    const headingStyle = TextStyle(
      fontSize: 14,
      color: Color(0xff545f70),
      fontWeight: FontWeight.w600,
    );
    const buttonBackgroundColor = Color(0xFF5A6473);
    const iconBackgroundColor = Color(0xFFE5ECF6);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, iconBackgroundColor),
                const SizedBox(height: 23),
                Text('Estado', style: headingStyle),
                const SizedBox(height: 8),
                CustomRadioButtonWidget(
                  onChanged: _handleStatusChange,
                  initialValue: widget.estado,
                ),
                const SizedBox(height: 23),
                Text('Observaciones', style: headingStyle),
                const SizedBox(height: 8),
                TextField(
                  controller: _observationController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Observaciones',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 11.0,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Listo',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.check, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color iconBackgroundColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.cursoNombre,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: const Color(0xff545f70),
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _handleDelete(context),
              child: _buildIconContainer(
                iconBackgroundColor,
                'assets/images/tacho.png',
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => _navigateToAddPostpone(context),
              child: _buildIconContainer(
                iconBackgroundColor,
                'assets/images/reloj.png',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIconContainer(Color color, String asset) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Image.asset(asset, height: 40),
      ),
    );
  }
}