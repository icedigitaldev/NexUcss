import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_view.dart';


// Pantalla principal que contiene el campo para ingresar el PIN
class PincodeView extends StatefulWidget {
  const PincodeView({super.key});

  @override
  State<PincodeView> createState() => _PinCodeWidgetState();
}

class _PinCodeWidgetState extends State<PincodeView> {
  String enteredPin = ''; // Almacena el PIN ingresado
  final textfield = TextEditingController(); // Controlador del TextField

  // Función para manejar la acción cuando se presiona un número
  void onNumberTapped(String number) {
    setState(() {
      if (enteredPin.length < 4) {
        enteredPin += number; // Añade el número al PIN si es menor a 4 dígitos
      }

      // Verifica si ya se ingresaron los 4 dígitos
      if (enteredPin.length == 4) {
        // Llama automáticamente a la validación del PIN
        validatePin();
      }
    });
  }

  // Función para manejar la acción de retroceso (eliminar el último número del PIN)
  void onCancelText() {
    if (enteredPin.isNotEmpty) {
      setState(() {
        enteredPin = enteredPin.substring(0, enteredPin.length - 1); // Elimina el último número
      });
    }
  }

  //Función para validar PIN
  void validatePin() {
    if (enteredPin == "1234") {
      // Si el PIN es correcto, redirige a la vista HomeView
      Navigator.pushNamed(context, '/home');
      } else {
      // Si el PIN es incorrecto, muestra un mensaje Toast
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
          child:  Text(
            "PIN incorrecto",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500
            ),
          ),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );

      // Resetea el PIN ingresado para intentar nuevamente
      setState(() {
        enteredPin = ''; // Limpia el PIN ingresado
      });
    }
  }


  // Grid que contiene los números del 0 al 9, icono de huella y retroceso
  Widget gridView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50), // Añade margen horizontal
      child: GridView.count(
        crossAxisCount: 3, // Número de columnas
        shrinkWrap: true,
        mainAxisSpacing: 20.0, // Espaciado vertical entre botones
        crossAxisSpacing: 50.0, // Espaciado horizontal entre botones
        children: [
          keyField("1"), keyField("2"), keyField("3"),
          keyField("4"), keyField("5"), keyField("6"),
          keyField("7"), keyField("8"), keyField("9"),
          fingerprint(), // Botón de huella digital
          keyField("0"), backSpace(), // Botón de retroceso
        ],
      ),
    );
  }

  // Widget para cada botón numérico
  Widget keyField(String numb) {
    return ClipOval(
      child: Material(
        color: Colors.white, // Fondo blanco del botón
        child: InkWell(
          onTap: () => onNumberTapped(numb), // Acción al tocar el botón
          child: Container(
            height: 66, // Ajuste de tamaño
            width: 66, // Ajuste de tamaño
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Forma circular del botón
              border: Border.all(color: const Color(0xffcebfbf), width: 1), // Borde del botón
            ),
            child: Center( // Centra el texto dentro del botón
              child: Text(
                numb,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xee114052), // Color del texto
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget para el botón de huella digital (sin funcionalidad por ahora)
  Widget fingerprint() {
    return Container(
      height: 66,
      width: 66,
      decoration: const BoxDecoration(
        shape: BoxShape.circle, // Forma circular del botón
      ),
      child: const Icon(
        Icons.fingerprint,
        color: Colors.black, // Icono de huella digital
        size: 50,
      ),
    );
  }

  // Widget para el botón de retroceso (borra el último número)
  Widget backSpace() {
    return IconButton(
      onPressed: onCancelText, // Llama a la función de retroceso al tocar
      icon: const Icon(
        Icons.backspace,
        color: Colors.black, // Color del icono
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 50), // Espaciado superior
          physics: const BouncingScrollPhysics(), // Efecto de rebote
          children: [
            Image.asset( // Logo o imagen
              'assets/images/nexucss.png',
              width: 200,
              height: 46,
            ),
            const SizedBox(height: 15),
            // Texto de saludo
            Center(
              child: Text(
                'Hola, ingresa tu PIN',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Indicadores de los 4 dígitos del PIN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.all(6.0), // Espaciado alrededor de cada círculo
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100), // Bordes circulares
                    border: Border.all(color: Colors.grey[400]!, width: 1), // Borde gris claro
                    color: index < enteredPin.length // Si el índice es menor que la longitud del PIN, lo llena
                        ? Theme.of(context).colorScheme.primary // Usar color primario del tema Material
                        : Theme.of(context).colorScheme.background, // Usar color de fondo del tema Material
                  ),
                  child: index < enteredPin.length // Si hay un dígito en esa posición, muestra un círculo
                      ? const Center(
                    child: Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.white, // Icono de punto en el PIN ingresado
                    ),
                  )
                      : null,
                );
              }),
            ),
            const SizedBox(height: 46),
            gridView(), // Llama a la función del teclado numérico
            const SizedBox(height: 64),
            // Texto para opción de recuperación de PIN
            Center(
              child: Text(
                '¿Olvidaste tu PIN?',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
