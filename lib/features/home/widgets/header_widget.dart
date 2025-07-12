import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/features/auth/controllers/auth_controller.dart';

class HeaderWidget extends ConsumerWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userModelProvider);

    return userAsync.when(
      data: (user) {
        final name = user?.name ?? 'Amig@';
        final profileImage =
            user?.profileImageUrl ??
            FirebaseAuth.instance.currentUser?.photoURL;

        return Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: profileImage != null
                  ? NetworkImage(profileImage)
                  : const AssetImage('assets/icons/avatar_placeholder.png')
                        as ImageProvider,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '¡Hola, $name!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => const Text('Error al cargar usuario'),
    );
  }
}
