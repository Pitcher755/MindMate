import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/features/auth/controllers/auth_controller.dart';

class HeaderWidget extends ConsumerWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);

    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : const AssetImage('assets/icons/avatar_placeholder.png')
                    as ImageProvider,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '¡Hola, ${user?.displayName ?? 'Amig@'}!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
