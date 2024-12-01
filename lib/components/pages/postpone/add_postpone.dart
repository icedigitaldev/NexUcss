import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/curso_controller.dart';
import '../../../controllers/postpone_controller.dart';
import '../../../widgets/pages/academic/curso_card.dart';
import '../../../widgets/pages/postpone/action_buttons.dart';
import '../../../widgets/pages/postpone/app_bar_custom.dart';
import '../../../widgets/pages/postpone/calendar_add_postpone.dart';
import '../../../widgets/pages/postpone/aula_bottom_sheet.dart';
import '../../../views/home_view.dart';
import '../../../widgets/pages/postpone/classroom_selector.dart';
import '../../../widgets/pages/postpone/date_selector.dart';

class AddPostpone extends ConsumerStatefulWidget {
  final String idCurso;
  final String cursoNombre;
  final String nombreProfe;
  final String nomFacultad;
  final String numAula;
  final int canAlumnos;
  final String numseccion;

  const AddPostpone({
    super.key,
    required this.idCurso,
    required this.cursoNombre,
    required this.nombreProfe,
    required this.nomFacultad,
    required this.numAula,
    required this.canAlumnos,
    required this.numseccion,
  });

  @override
  ConsumerState<AddPostpone> createState() => _AddPostpone();
}

class _AddPostpone extends ConsumerState<AddPostpone> {
  final ScrollController _scrollController = ScrollController();
  DateTime? _selectedDate;
  String? _selectedAula;
  String? _selectedHorario;
  bool _isLoading = false;
  List<Map<String, String>> aulasHorarios = [];

  @override
  void initState() {
    super.initState();
    _selectedHorario = "20:50-22:20";
  }

  Future<void> _saveToFirestore() async {
    if (_selectedDate == null || _selectedAula == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, complete todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final postponeController = ref.read(postponeControllerProvider.notifier);
      await postponeController.createPostpone(
        idCurso: widget.idCurso,
        cursoNombre: widget.cursoNombre,
        profesorNombre: widget.nombreProfe,
        fecha: _selectedDate!,
        horario: _selectedHorario!,
        aula: _selectedAula!,
        seccion: widget.numseccion,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeView(initialIndex: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void cargarAulasLibres(DateTime fecha) async {
    final dias = ['DOMINGO', 'LUNES', 'MARTES', 'MIÉRCOLES', 'JUEVES', 'VIERNES', 'SÁBADO'];
    final dia = dias[fecha.weekday % 7];

    final aulasLibresController = ref.read(aulasLibresProvider.notifier);
    await aulasLibresController.cargarAulasLibres(dia);

    final aulasLibres = ref.read(aulasLibresProvider);
    aulasLibres.whenData((aulas) {
      setState(() {
        aulasHorarios = aulas;
      });
    });
  }

  void _openCalendarBottomSheet(BuildContext context) async {
    final DateTime? selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CalendarAddPostpone(
          onDateSelected: (DateTime date) {
            Navigator.pop(context, date);
          },
        );
      },
    );
    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
        _selectedAula = null;
      });
      cargarAulasLibres(selectedDate);
    }
  }

  void _openAulaBottomSheet(BuildContext context) async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, seleccione primero una fecha'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (aulasHorarios.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay aulas disponibles para la fecha seleccionada'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (BuildContext context) {
        return AulaBottomSheet(
          aulasHorarios: aulasHorarios,
          onAulaSelected: (Map<String, String> aulaSeleccionada) {
            setState(() {
              _selectedAula = aulaSeleccionada['aula'];
              _selectedHorario = aulaSeleccionada['horario'] ?? '20:50-22:20';
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBarCustom(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clase a Recuperar',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff545f70),
                  ),
                ),
                const SizedBox(height: 8),
                CursoCard(
                  seccion: widget.numseccion,
                  aula: widget.numAula,
                  curso: widget.cursoNombre,
                  profesor: widget.nombreProfe,
                  facultad: widget.nomFacultad,
                  alumnos: widget.canAlumnos,
                ),
                const SizedBox(height: 26),
                Text(
                  'Programación',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff545f70),
                  ),
                ),
                const SizedBox(height: 13),
                DateSelector(
                  selectedDate: _selectedDate,
                  onTap: () => _openCalendarBottomSheet(context),
                ),
                const SizedBox(height: 16),
                ClassroomSelector(
                  selectedAula: _selectedAula,
                  selectedHorario: _selectedHorario,
                  onTap: () => _openAulaBottomSheet(context),
                ),
                const SizedBox(height: 80),
                ActionButtons(
                  onCancel: _isLoading ? null : () => Navigator.of(context).pop(false),
                  onContinue: _isLoading ? null : _saveToFirestore,
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff545f70)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}