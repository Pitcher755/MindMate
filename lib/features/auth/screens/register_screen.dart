import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/features/auth/widgets/register_email_view.dart';
import 'package:mindmate/features/auth/widgets/register_goals_view.dart';
import 'package:mindmate/features/auth/widgets/register_profile_view.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final int viewIndex;

  const RegisterScreen({super.key, this.viewIndex = 0});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late final PageController _pageController; // = PageController();
  late int _currentPage; //= 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.viewIndex;
    _pageController = PageController(initialPage: widget.viewIndex);
  }

  void nextPage() {
    if (_currentPage < 2) {
      setState(() => _currentPage++);
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Color _backgroundColor(int page) {
    switch (page) {
      case 0:
        return AppColors.accentBlue;
      case 1:
        return AppColors.accentGreen;
      case 2:
        return AppColors.accentYellow;
      default:
        return AppColors.background;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor(_currentPage),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    RegisterEmailView(onNext: nextPage),
                    RegisterProfileView(onNext: nextPage, onBack: previousPage),
                    RegisterGoalsView(onBack: previousPage),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Indicador de progreso
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
