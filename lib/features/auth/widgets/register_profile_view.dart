import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/core/constants.dart';
import 'package:mindmate/core/utils.dart';
import 'package:mindmate/features/auth/controllers/auth_controller.dart';

class RegisterProfileView extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const RegisterProfileView({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<RegisterProfileView> createState() =>
      _RegisterProfileViewState();
}

class _RegisterProfileViewState extends ConsumerState<RegisterProfileView> {
  final _nameController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  void _continue() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      showSnackBar(context, 'Por favor, introduce tu nombre.');
      return;
    }

    // Guardamos nombre e imagen temporalmente en el controlador
    ref
        .read(authControllerProvider.notifier)
        .updatePartialUserData(name: name, profileImageFile: _selectedImage);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding * 1.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tu perfil',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    backgroundColor: AppColors.accentYellow,
                    child: _selectedImage == null
                        ? const Icon(
                            Icons.add_a_photo,
                            size: 30,
                            color: Colors.black54,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(width: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onBack,
                        child: const Text('Atrás'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _continue, 
                        child: const Text('Continuar'),
                        ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
