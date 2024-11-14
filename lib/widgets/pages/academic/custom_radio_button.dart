import 'package:flutter/material.dart';

class CustomRadioButtonWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;

  CustomRadioButtonWidget({required this.onChanged});

  @override
  _CustomRadioButtonWidgetState createState() => _CustomRadioButtonWidgetState();
}

class _CustomRadioButtonWidgetState extends State<CustomRadioButtonWidget> {
  List<bool> isSelected = [false, false, false];
  Color selectedColor = Colors.blue.withOpacity(0.2); // Color inicial de fondo seleccionado

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ToggleButtons(
            borderRadius: BorderRadius.circular(30.0),
            borderColor: Colors.grey, // Color de borde constante
            selectedBorderColor: Colors.grey, // Misma configuración para borde seleccionado
            fillColor: selectedColor, // Color de fondo dinámico cuando está seleccionado
            selectedColor: Colors.black,
            color: Colors.black,
            constraints: BoxConstraints(
              minWidth: (constraints.maxWidth / isSelected.length) - 2.0,
              minHeight: 50.0,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('TA'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('AS'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('FA'),
              ),
            ],
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = i == index;
                }
                // Cambia el color de fondo únicamente según el botón seleccionado
                if (index == 0) {
                  selectedColor = Colors.orange.withOpacity(0.2); // Fondo naranja para TA
                  widget.onChanged('TA');
                } else if (index == 1) {
                  selectedColor = Colors.green.withOpacity(0.2); // Fondo verde para AS
                  widget.onChanged('AS');
                } else if (index == 2) {
                  selectedColor = Colors.red.withOpacity(0.2); // Fondo rojo para FA
                  widget.onChanged('FA');
                }
              });
            },
          ),
        );
      },
    );
  }
}
