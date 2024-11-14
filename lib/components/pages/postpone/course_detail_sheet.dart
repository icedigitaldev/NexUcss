import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexucss/components/pages/postpone/add_postpone.dart';
import 'package:nexucss/dialogs/delete_dialog.dart';
import 'package:nexucss/widgets/pages/postpone/custom_radio_button.dart';

class CourseDetailSheet extends StatelessWidget {
  final String fecha;
  final String hora;
  final String aula;
  final String cursoNombre;
  final String profesor;
  final String facultad;
  final int alumnos;
  final String estado;

  const CourseDetailSheet({
    Key? key,
    required this.fecha,
    required this.hora,
    required this.aula,
    required this.cursoNombre,
    required this.profesor,
    required this.facultad,
    required this.alumnos,
    required this.estado,
  }) : super(key: key);

  void onChanged(String value) {
    print('Opción seleccionada: $value');
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    const headingStyle = TextStyle(fontSize: 14, color: Color(0xff545f70), fontWeight: FontWeight.w600);
    const buttonBackgroundColor = Color(0xFF5A6473);
    const iconBackgroundColor = Color(0xFFE5ECF6);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40),
                topLeft: Radius.circular(40),
              )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cursoNombre,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: Color(0xff545f70),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final bool? result = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) => const DeleteDialog(),
                            );
                            if (result == true) {
                              print("Recuperación eliminada");
                            } else {
                              print("Eliminación cancelada");
                            }
                          },
                          child: _buildIconContainer(iconBackgroundColor, 'assets/images/tacho.png'),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddPostpone(
                                  cursoNombre: cursoNombre,
                                  nombreProfe: profesor,
                                  nomFacultad: facultad,
                                  numAula: aula,
                                  canAlumnos: alumnos,
                                  numseccion: '120', // Ajusta según sea necesario
                                ),
                              ),
                            );
                          },
                          child: _buildIconContainer(iconBackgroundColor, 'assets/images/reloj.png'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 23),
                Text('Estado', style: headingStyle),
                const SizedBox(height: 8),
                CustomRadioButtonWidget(onChanged: onChanged),
                const SizedBox(height: 23),
                Text('Observaciones', style: headingStyle),
                const SizedBox(height: 8),
                _buildObservationTextField(),
                const SizedBox(height: 20),
                _buildActionButton(context, buttonBackgroundColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(Color color, String asset) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Image.asset(asset, height: 40),
      ),
    );
  }

  Widget _buildObservationTextField() {
    return TextField(
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Observaciones',
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 11.0),
      ),
      style: TextStyle(fontSize: 14),
    );
  }

  Widget _buildActionButton(BuildContext context, Color color) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Listo', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
              SizedBox(width: 8),
              Icon(Icons.check, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
