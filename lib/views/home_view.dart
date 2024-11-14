import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/pages/academic_schedule_page.dart';
import '../components/pages/postpone_schedules_page.dart';
import '../components/pages/reports_schedule_page.dart';
import '../theme/custom_colors.dart';
import '../widgets/pages/postpone/calendar_filter.dart';
import 'package:nexucss/components/pages/perfil_page.dart';


class HomeView extends StatefulWidget {
  final int initialIndex;
  const HomeView({super.key, this.initialIndex = 0});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late int _selectedIndex;

  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Usa el índice inicial proporcionado
  }

  static const List<Widget> _views = [
    AcademicSchedulePage(),
    PostponeSchedulesPage(),
    ReportsSchedulePage(),
  ];

  // Definir los títulos correspondientes para cada vista
  static const List<String> _titles = [
    'Hola, Angie',
    'Aplazados',
    'Reportes',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Función para navegar directamente a PostponeSchedulesPage
  void navigateToPostponeSchedulesPage() {
    setState(() {
      _selectedIndex = 1; // Cambia el índice al de PostponeSchedulesPage
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _titles[_selectedIndex]),
      body: _views[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x3f000000),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                if (title == 'Hola, Angie' || title == 'Aplazados' || title == 'Reportes')
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/icon_user.png',
                      height: 35,
                      width: 35,
                    ),
                  ),
                if (title == 'Hola, Angie' || title == 'Aplazados' || title == 'Reportes')
                  const SizedBox(width: 7),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    color: const Color(0xff545f70),
                  ),
                ),
              ],
            ),
          ),
          elevation: 0,
          actions: [
            if (title == 'Hola, Angie')
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Image.asset(
                    'assets/images/icon_lupa.png',
                    width: 35,
                    height: 35,
                  ),
                  onPressed: () {
                    print("Buscar presionado");
                  },
                ),
              ),
            if (title == 'Aplazados')
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: const Icon(
                    Icons.calendar_today,
                    color: Color(0xff545f70),
                    size: 30,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,

                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                      ),
                      builder: (BuildContext context) {
                        return CalendarWidget();
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Definir los colores para los diferentes estados
    const Color navyBlue = Color(0xFF002366); // Azul marino para seleccionados
    const Color greyColor = Colors.grey; // Gris para no seleccionados

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: Colors.transparent, // Quitar el indicador
        labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(color: navyBlue); // Texto azul marino si está seleccionado
          }
          return const TextStyle(color: greyColor); // Texto gris si no está seleccionado
        }),
        iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: navyBlue); // Ícono azul marino si está seleccionado
          }
          return const IconThemeData(color: greyColor); // Ícono gris si no está seleccionado
        }),
      ),
      child: NavigationBar(
        backgroundColor: Colors.white, // Fondo blanco
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_late),
            label: 'Aplazados',
          ),
          NavigationDestination(
            icon: Icon(Icons.insert_chart),
            label: 'Reportes',
          ),
        ],
      ),
    );
  }
}
