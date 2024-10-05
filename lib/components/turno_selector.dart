import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/dropdown.dart'; // Asegúrate de importar correctamente

class TurnoSelector extends StatefulWidget {
  const TurnoSelector({Key? key}) : super(key: key);

  @override
  _TurnoSelectorState createState() => _TurnoSelectorState();
}

class _TurnoSelectorState extends State<TurnoSelector> {
  // Lista de opciones predefinidas del Dropdown
  List<String> items = [
    'Turno',
    'Mañana',
    'Tarde',
    'Noche', // He agregado "Noche" a la lista
  ];


  // Valor seleccionado por defecto (debe estar en la lista)
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = items[0]; // Inicializamos el valor seleccionado por defecto al primero en la lista
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xff9ba5b7),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lunes 20/09/24',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.36,
                ),
              ),
              // Utiliza el widget `DropdownTurno`
              Dropdown(
                selectedValue: selectedValue,
                items: items,
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue; // Actualiza el valor seleccionado
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
