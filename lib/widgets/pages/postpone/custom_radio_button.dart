import 'package:flutter/material.dart';

class CustomRadioButtonWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;

  CustomRadioButtonWidget({required this.onChanged});

  @override
  _CustomRadioButtonWidgetState createState() => _CustomRadioButtonWidgetState();
}

class _CustomRadioButtonWidgetState extends State<CustomRadioButtonWidget> {
  List<bool> isSelected = [false, false];

  Color getFillColor() {
    if (isSelected[0]) {
      return Color(0xffc10c0c).withOpacity(0.5); // Color para "Cancelada"
    } else if (isSelected[1]) {
      return Colors.green.withOpacity(0.5); // Color para "Recuperada"
    } else {
      return Colors.blue.withOpacity(0.2); // Color predeterminado
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ToggleButtons(
            borderRadius: BorderRadius.circular(30.0),
            borderColor: Colors.grey, // Borde constante en color gris
            selectedBorderColor: Colors.grey, // Mismo color de borde cuando está seleccionado
            fillColor: getFillColor(), // Color de fondo dinámico
            selectedColor: Colors.black,
            color: Colors.black,
            constraints: BoxConstraints(
              minWidth: (constraints.maxWidth / isSelected.length) - 2.0,
              minHeight: 50.0,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Cancelada'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Recuperada'),
              ),
            ],
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = i == index;
                }
                // Notificar al widget padre sobre la opción seleccionada
                if (index == 0) {
                  widget.onChanged('Cancelada');
                } else if (index == 1) {
                  widget.onChanged('Recuperada');
                }
              });
            },
          ),
        );
      },
    );
  }
}
