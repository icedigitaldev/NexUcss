import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexucss/widgets/pages/academic/custom_radio_button.dart';
import 'package:nexucss/dialogs/recuperar_dialog.dart';
import 'package:nexucss/widgets/pages/academic/dropdown_ubication.dart';
import 'package:nexucss/components/pages/postpone/add_postpone.dart';

class AddAttendanceSheet extends StatefulWidget {
  final String cursoNombre;
  final String nombreProfe;
  final String nomFacultad;
  final String numAula;
  final int canAlumnos;
  final String numseccion;

  AddAttendanceSheet({
    required this.cursoNombre,
    required this.nombreProfe,
    required this.nomFacultad,
    required this.numAula,
    required this.canAlumnos,
    required this.numseccion,
  });

  @override
  _AddAttendanceSheetState createState() => _AddAttendanceSheetState();
}

class _AddAttendanceSheetState extends State<AddAttendanceSheet> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFieldFocusNode = FocusNode();
  String _selectedOption = '';
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _textFieldFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_textFieldFocusNode.hasFocus) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _textFieldFocusNode.removeListener(_onFocusChange);
    _textFieldFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onRadioButtonChanged(String value) {
    setState(() {
      _selectedOption = value;
    });
  }

  Future<void> _showRecuperarDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return RecuperarDialog();
      },
    );

    if (result == true) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddPostpone(
          cursoNombre: widget.cursoNombre,
          nombreProfe: widget.nombreProfe,
          nomFacultad: widget.nomFacultad,
          numAula: widget.numAula,
          canAlumnos: widget.canAlumnos,
          numseccion: widget.numseccion,
        ),
      ));
    } else {
      print('Recuperación cancelada');
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
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEef1F4),
                  ),
                  child: Center(
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
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
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
                items: ['Universidad', 'Virtual', 'Hospital', 'Campo'],
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
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: TextField(
                  focusNode: _textFieldFocusNode,
                  maxLines: 10,
                  expands: false,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xff6a7d94),
                    fontWeight: FontWeight.normal,
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
                        onPressed: () {
                          print('Marcado como listo');
                        },
                        child: Text(
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
      ),
    );
  }
}
