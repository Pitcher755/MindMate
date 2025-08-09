import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/features/auth/controllers/auth_controller.dart';
import 'package:mindmate/features/home/widgets/header_widget.dart';
import 'package:mindmate/features/home/widgets/mood_card.dart';
import 'package:mindmate/features/home/widgets/show_daily_mood_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Muestra el diálogo de estado de ánimo al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDailyMoodDialog(context, ref);
    });
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    // Posible cambio de vista si añado más pantallas
    // De momento sólo está implementada Home
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userDataProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: userAsync.when(
          data: (user) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),
                const SizedBox(height: 20),
                // Pasar mood y userName a MoodCard, este consulta el provider
                MoodCard(mood: user.mood ?? '', userName: user.name),
                const SizedBox(height: 24),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        backgroundColor: AppColors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
