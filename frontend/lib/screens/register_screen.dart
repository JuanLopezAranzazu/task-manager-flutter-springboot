import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import '../providers/providers.dart';
import '../widgets/app_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    await ref.read(authProvider.notifier).register(
          _name.text.trim(),
          _email.text.trim(),
          _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/login')),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(16),
                Text(
                  'Crear cuenta',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Gap(4),
                Text(
                  'Completa el formulario para registrarte',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                ),
                const Gap(28),

                if (auth.error != null) ...[
                  ErrorBanner(
                    auth.error!,
                    onDismiss: () =>
                        ref.read(authProvider.notifier).clearError(),
                  ),
                  const Gap(16),
                ],

                AppTextField(
                  controller: _name,
                  label: 'Nombre completo',
                  hint: 'Juan Pérez',
                  prefixIcon: Icons.person_outline,
                  capitalization: TextCapitalization.words,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Campo requerido';
                    if (v.length < 2) return 'Mínimo 2 caracteres';
                    return null;
                  },
                ),
                const Gap(14),
                AppTextField(
                  controller: _email,
                  label: 'Correo electrónico',
                  hint: 'tu@correo.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Campo requerido';
                    if (!v.contains('@')) return 'Correo inválido';
                    return null;
                  },
                ),
                const Gap(14),
                AppTextField(
                  controller: _password,
                  label: 'Contraseña',
                  hint: 'Mínimo 8 caracteres',
                  obscure: !_showPassword,
                  prefixIcon: Icons.lock_outline,
                  suffix: GestureDetector(
                    onTap: () =>
                        setState(() => _showPassword = !_showPassword),
                    child: Icon(
                      _showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Campo requerido';
                    if (v.length < 8) return 'Mínimo 8 caracteres';
                    return null;
                  },
                ),
                const Gap(14),
                AppTextField(
                  controller: _confirm,
                  label: 'Confirmar contraseña',
                  obscure: !_showPassword,
                  prefixIcon: Icons.lock_outline,
                  validator: (v) {
                    if (v != _password.text) return 'Las contraseñas no coinciden';
                    return null;
                  },
                ),
                const Gap(24),

                AppButton(
                  label: 'Crear cuenta',
                  onPressed: _submit,
                  loading: auth.isLoading,
                  icon: Icons.check,
                ),
                const Gap(16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿Ya tienes cuenta? '),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Inicia sesión'),
                    ),
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
