import 'package:flutter/material.dart';

class CustomRadioButtonWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String initialValue;

  const CustomRadioButtonWidget({
    Key? key,
    required this.onChanged,
    this.initialValue = '',
  }) : super(key: key);

  @override
  _CustomRadioButtonWidgetState createState() => _CustomRadioButtonWidgetState();
}

class _CustomRadioButtonWidgetState extends State<CustomRadioButtonWidget> {
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = [
      widget.initialValue == 'cancelada',
      widget.initialValue == 'recuperada'
    ];
  }

  Color getFillColor() {
    if (isSelected[0]) {
      return const Color(0xffc10c0c).withOpacity(0.5);
    } else if (isSelected[1]) {
      return Colors.green.withOpacity(0.5);
    } else {
      return Colors.blue.withOpacity(0.2);
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
            borderColor: Colors.grey,
            selectedBorderColor: Colors.grey,
            fillColor: getFillColor(),
            selectedColor: Colors.black,
            color: Colors.black,
            constraints: BoxConstraints(
              minWidth: (constraints.maxWidth / isSelected.length) - 2.0,
              minHeight: 50.0,
            ),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Cancelada'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Recuperada'),
              ),
            ],
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = i == index;
                }
                widget.onChanged(index == 0 ? 'cancelada' : 'recuperada');
              });
            },
          ),
        );
      },
    );
  }
}