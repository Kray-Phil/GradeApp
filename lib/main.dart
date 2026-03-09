import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:banzon_gradeapp/core/theme/app_theme.dart';
import 'package:banzon_gradeapp/providers/auth_provider.dart';
import 'package:banzon_gradeapp/providers/grade_provider.dart';
import 'package:banzon_gradeapp/providers/todo_provider.dart';
import 'package:banzon_gradeapp/screens/login_screen.dart';
import 'package:banzon_gradeapp/screens/dashboard_screen.dart';
import 'package:banzon_gradeapp/screens/grade_screen.dart';
import 'package:banzon_gradeapp/screens/todo_screen.dart';
import 'package:banzon_gradeapp/screens/profile_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:banzon_gradeapp/core/constants/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set default flutter_animate properties
  Animate.defaultDuration = 400.ms;
  Animate.defaultCurve = Curves.easeOutCubic;

  runApp(const StudentCompanionApp());
}

class StudentCompanionApp extends StatelessWidget {
  const StudentCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GradeProvider()),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: MaterialApp(
        title: 'Student Companion',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isAuthenticated) {
          return const MainShell();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    GradeScreen(),
    TodoScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.textDisabled.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: AppColors.primary.withOpacity(0.15),
            labelTextStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const TextStyle(
                  color: AppColors.primary, 
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
              }
              return const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              );
            }),
            iconTheme: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const IconThemeData(color: AppColors.primary);
              }
              return const IconThemeData(color: AppColors.textSecondary);
            }),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: AppColors.surface,
            elevation: 0,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.analytics_outlined),
                selectedIcon: Icon(Icons.analytics_rounded),
                label: 'Grades',
              ),
              NavigationDestination(
                icon: Icon(Icons.check_circle_outline),
                selectedIcon: Icon(Icons.check_circle),
                label: 'Tasks',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
