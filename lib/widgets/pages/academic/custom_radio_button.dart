import 'package:flutter/material.dart';

class CustomRadioButtonWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? initialValue;

  const CustomRadioButtonWidget({
    Key? key,
    required this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  _CustomRadioButtonWidgetState createState() => _CustomRadioButtonWidgetState();
}

class _CustomRadioButtonWidgetState extends State<CustomRadioButtonWidget> {
  late List<bool> isSelected;
  Color selectedColor = Colors.blue.withOpacity(0.2);

  @override
  void initState() {
    super.initState();
    _initializeSelection();
  }

  @override
  void didUpdateWidget(CustomRadioButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _initializeSelection();
    }
  }

  void _initializeSelection() {
    isSelected = [false, false, false];
    if (widget.initialValue != null) {
      switch (widget.initialValue) {
        case 'TA':
          isSelected[0] = true;
          selectedColor = Colors.orange.withOpacity(0.2);
          break;
        case 'AS':
          isSelected[1] = true;
          selectedColor = Colors.green.withOpacity(0.2);
          break;
        case 'FA':
          isSelected[2] = true;
          selectedColor = Colors.red.withOpacity(0.2);
          break;
      }
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
            fillColor: selectedColor,
            selectedColor: Colors.black,
            color: Colors.black,
            constraints: BoxConstraints(
              minWidth: (constraints.maxWidth / isSelected.length) - 2.0,
              minHeight: 50.0,
            ),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('TA'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('AS'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('FA'),
              ),
            ],
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = i == index;
                }
                if (index == 0) {
                  selectedColor = Colors.orange.withOpacity(0.2);
                  widget.onChanged('TA');
                } else if (index == 1) {
                  selectedColor = Colors.green.withOpacity(0.2);
                  widget.onChanged('AS');
                } else if (index == 2) {
                  selectedColor = Colors.red.withOpacity(0.2);
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