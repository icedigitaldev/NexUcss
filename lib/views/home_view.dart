import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/pages/academic_schedule_page.dart';
import '../components/pages/postpone_schedules_page.dart';
import '../components/pages/reports_schedule_page.dart';
import '../widgets/pages/postpone/calendar_filter.dart';
import '../controllers/curso_controller.dart';
import 'profile_view.dart';

class HomeView extends StatefulWidget {
  final int initialIndex;
  const HomeView({super.key, this.initialIndex = 0});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  static const List<Widget> _views = [
    AcademicSchedulePage(),
    PostponeSchedulesPage(),
    ReportsSchedulePage(),
  ];

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

  void navigateToPostponeSchedulesPage() {
    setState(() {
      _selectedIndex = 1;
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

class CustomAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          title: isSearching && widget.title == 'Hola, Angie'
              ? TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Buscar curso, docente, facultad...',
              border: InputBorder.none,
              hintStyle: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xff545f70),
            ),
            onChanged: (value) {
              ref.read(searchControllerProvider.notifier).setSearchQuery(value);
            },
          )
              : Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                if (widget.title == 'Hola, Bienvenido' ||
                    widget.title == 'Aplazados' ||
                    widget.title == 'Reportes')
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileView()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/icon_user.png',
                      height: 35,
                      width: 35,
                    ),
                  ),
                if (widget.title == 'Hola, Bienvenido' ||
                    widget.title == 'Aplazados' ||
                    widget.title == 'Reportes')
                  const SizedBox(width: 7),
                Text(
                  widget.title,
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
            if (widget.title == 'Hola, Bienvenido')
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: isSearching
                      ? const Icon(
                    Icons.close,
                    color: Color(0xff545f70),
                    size: 30,
                  )
                      : Image.asset(
                    'assets/images/icon_lupa.png',
                    width: 35,
                    height: 35,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isSearching) {
                        isSearching = false;
                        _searchController.clear();
                        ref.read(searchControllerProvider.notifier).clearSearch();
                      } else {
                        isSearching = true;
                      }
                    });
                  },
                ),
              ),
            if (widget.title == 'Aplazados')
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
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40)),
                      ),
                      builder: (BuildContext context) {
                        return const CalendarWidget();
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
    const Color navyBlue = Color(0xFF002366);
    const Color greyColor = Colors.grey;

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: Colors.transparent,
        labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(color: navyBlue);
          }
          return const TextStyle(color: greyColor);
        }),
        iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: navyBlue);
          }
          return const IconThemeData(color: greyColor);
        }),
      ),
      child: NavigationBar(
        backgroundColor: Colors.white,
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