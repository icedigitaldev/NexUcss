import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexucss/utils/logger.dart';
import '../../../controllers/attendance_controller.dart';
import '../../../widgets/pages/academic/custom_radio_button.dart';
import '../../../dialogs/recuperar_dialog.dart';
import '../../../widgets/pages/academic/dropdown_ubication.dart';
import '../../../components/pages/postpone/add_postpone.dart';

class AddAttendance extends ConsumerStatefulWidget {
  final String cursoNombre;
  final String nombreProfe;
  final String nomFacultad;
  final String numAula;
  final int canAlumnos;
  final String numseccion;
  final String idCurso;

  const AddAttendance({
    Key? key,
    required this.cursoNombre,
    required this.nombreProfe,
    required this.nomFacultad,
    required this.numAula,
    required this.canAlumnos,
    required this.numseccion,
    required this.idCurso,
  }) : super(key: key);

  @override
  ConsumerState<AddAttendance> createState() => _AddAttendanceState();
}

class _AddAttendanceState extends ConsumerState<AddAttendance> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final TextEditingController _observacionController = TextEditingController();
  String _selectedOption = '';
  String? _selectedLocation;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _textFieldFocusNode.addListener(_onFocusChange);
    _cargarDatosExistentes();
  }

  Future<void> _cargarDatosExistentes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final attendanceController = ref.read(attendanceControllerProvider);
      final fecha = DateTime.now();
      final fechaFormateada = "${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}";

      final asistencias = await attendanceController.obtenerAsistenciasPorFecha(fechaFormateada);

      if (asistencias != null && asistencias.containsKey(widget.idCurso)) {
        final asistencia = asistencias[widget.idCurso] as Map<String, dynamic>;

        setState(() {
          _selectedLocation = asistencia['ubicacion'] as String;
          _selectedOption = asistencia['estado'] as String;
          if (asistencia.containsKey('observacion')) {
            _observacionController.text = asistencia['observacion'] as String;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        AppLogger.log('Error al cargar datos existentes', prefix: 'ADD-ATTENDANCE:');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onFocusChange() {
    if (_textFieldFocusNode.hasFocus) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _textFieldFocusNode.removeListener(_onFocusChange);
    _textFieldFocusNode.dispose();
    _scrollController.dispose();
    _observacionController.dispose();
    super.dispose();
  }

  void _onRadioButtonChanged(String value) {
    setState(() {
      _selectedOption = value;
    });
  }

  Future<void> _registrarAsistencia() async {
    if (_selectedLocation == null || _selectedOption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final attendanceController = ref.read(attendanceControllerProvider);
      await attendanceController.registrarAsistencia(
        idCurso: widget.idCurso,
        estado: _selectedOption,
        ubicacion: _selectedLocation!,
        numseccion: widget.numseccion,
        nombreProfesor: widget.nombreProfe,
        observacion: _observacionController.text,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppLogger.log('Error al registrar asistencia', prefix: 'ADD-ATTENDANCE:');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _showRecuperarDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const RecuperarDialog();
      },
    );

    if (result == true && mounted) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddPostpone(
          idCurso: widget.idCurso,
          cursoNombre: widget.cursoNombre,
          nombreProfe: widget.nombreProfe,
          nomFacultad: widget.nomFacultad,
          numAula: widget.numAula,
          canAlumnos: widget.canAlumnos,
          numseccion: widget.numseccion,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x3f000000),
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: SafeArea(
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEef1F4),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF545F71),
                      size: 20,
                    ),
                  ),
                ),
              ),
              title: Text(
                'Control de Docente',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: const Color(0xff545f70),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cursoNombre,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.nombreProfe,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff545f70),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonSheet(
                    title: 'Seleccione Ubicación',
                    items: const ['UNIVERSIDAD', 'VIRTUAL', 'HOSPITAL', 'CAMPO'],
                    hint: _selectedLocation ?? 'Seleccionar Ubicación',
                    onChanged: (value) {
                      setState(() {
                        _selectedLocation = value;
                      });
                    },
                  ),
                  const SizedBox(height: 23),
                  CustomRadioButtonWidget(
                    onChanged: _onRadioButtonChanged,
                    initialValue: _selectedOption,
                  ),
                  const SizedBox(height: 23),
                  Text(
                    'Observaciones',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: TextField(
                      controller: _observacionController,
                      focusNode: _textFieldFocusNode,
                      maxLines: 10,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xff6a7d94),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Redacta Observaciones',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xff6a7d94),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              backgroundColor: const Color(0xFF545F71),
                            ),
                            onPressed: _isSaving ? null : _registrarAsistencia,
                            child: _isSaving
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text(
                              'Listo',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              backgroundColor: const Color(0xFF545F71),
                            ),
                            onPressed: _selectedOption == 'FA' ? _showRecuperarDialog : null,
                            child: Text(
                              'Recuperar',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}