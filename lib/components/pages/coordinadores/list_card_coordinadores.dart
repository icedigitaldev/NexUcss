import 'package:flutter/material.dart';
import '../../../widgets/pages/coordinadores/card_coordinador.dart';

class ListCardCoordinadores extends StatelessWidget {
  final List<Map<String, String>> coordinadores = [
    {
      'facultad': 'Facultad Ingeniería',
      'nombre': 'Alan Karina, Lopez Horna',
      'telefono': '959 659 501',
      'correo': 'jlopes@ucss.edu.pe',
      'imageUrl': 'assets/images/coordinador_image.png', // Reemplaza con una URL válida
    },
    {
      'facultad': 'Facultad de Ciencias',
      'nombre': 'Juan Pablo, Gonzalez Lopez',
      'telefono': '958 123 456',
      'correo': 'jgonzalez@ucss.edu.pe',
      'imageUrl': 'assets/images/coordinador_image.png', // Reemplaza con una URL válida
    },
    {
      'facultad': 'Facultad Ingeniería',
      'nombre': 'Alan Karina, Lopez Horna',
      'telefono': '959 659 501',
      'correo': 'jlopes@ucss.edu.pe',
      'imageUrl': 'assets/images/coordinador_image.png', // Reemplaza con una URL válida
    },
    {
      'facultad': 'Facultad de Ciencias',
      'nombre': 'Juan Pablo, Gonzalez Lopez',
      'telefono': '958 123 456',
      'correo': 'jgonzalez@ucss.edu.pe',
      'imageUrl': 'assets/images/coordinador_image.png', // Reemplaza con una URL válida
    },
    {
      'facultad': 'Facultad Ingeniería',
      'nombre': 'Alan Karina, Lopez Horna',
      'telefono': '959 659 501',
      'correo': 'jlopes@ucss.edu.pe',
      'imageUrl': 'assets/images/coordinador_image.png', // Reemplaza con una URL válida
    },
    {
      'facultad': 'Facultad de Ciencias',
      'nombre': 'Juan Pablo, Gonzalez Lopez',
      'telefono': '958 123 456',
      'correo': 'jgonzalez@ucss.edu.pe',
      'imageUrl': 'assets/images/coordinador_image.png', // Reemplaza con una URL válida
    },
    {
      'facultad': 'Facultad Ingeniería',
      'nombre': 'Alan Karina, Lopez Horna',
      'telefono': '959 659 501',
      'correo': 'jlopes@ucss.edu.pe',
      'imageUrl': 'assets/images/coordinador_image.png', // Reemplaza con una URL válida
    },
    {
      'facultad': 'Facultad de Ciencias',
      'nombre': 'Juan Pablo, Gonzalez Lopez',
      'telefono': '958 123 456',
      'correo': 'jgonzalez@ucss.edu.pe',
      'imageUrl': 'assets/images/coordinador_image.png', // Reemplaza con una URL válida
    },
    {
      'facultad': 'Facultad Ingeniería',
      'nombre': 'Alan Karina, Lopez Horna',
      'telefono': '959 659 501',
      'correo': 'jlopes@ucss.edu.pe',
      'imageUrl': 'assets/images/coordinador_image.png', // Reemplaza con una URL válida
    },
    {
      'facultad': 'Facultad de Ciencias',
      'nombre': 'Juan Pablo, Gonzalez Lopez',
      'telefono': '958 123 456',
      'correo': 'jgonzalez@ucss.edu.pe',
      'imageUrl': 'assets/images/coordinador_image.png', // Reemplaza con una URL válida
    },
  ];

  ListCardCoordinadores({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(coordinadores.length, (index) {
            final coordinador = coordinadores[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () {
                  // Aquí puedes definir una acción al tocar la tarjeta, si es necesario
                },
                child: CardCoordinador(
                  facultad: coordinador['facultad']!,
                  nombre: coordinador['nombre']!,
                  telefono: coordinador['telefono']!,
                  correo: coordinador['correo']!,
                  imageUrl: coordinador['imageUrl']!,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
