import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mandubi/firebase_options.dart';
import 'package:mandubi/routes/app_routes.dart';
import 'package:mandubi/screens/dashboard/dashboard_screen.dart';
import 'package:mandubi/screens/doctors/doctors_screen.dart';
import 'package:mandubi/screens/doctors/add_doctor_screen.dart';
import 'package:mandubi/screens/visits/add_visit_screen.dart';
import 'package:mandubi/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ar_SA');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mandubi',
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('en', 'US'),
      getPages: [
        GetPage(name: Routes.dashboard, page: () => const DashboardScreen()),
        GetPage(name: Routes.doctorsDirectory, page: () => const DoctorsScreen()),
        GetPage(name: Routes.addDoctor, page: () => const AddDoctorScreen()),
        GetPage(name: Routes.addVisit, page: () => const AddVisitScreen()),
      ],
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const DoctorsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'لوحة التحكم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'الأطباء',
          ),
        ],
      ),
    );
  }
}
