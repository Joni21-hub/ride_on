import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'main_shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  bool _obscurePassword = true;
  final TextEditingController _identifierController =
      TextEditingController(text: '0812-3456-7890');
  final TextEditingController _passwordController =
      TextEditingController(text: '••••••••');
  final TextEditingController _nameController =
      TextEditingController(text: 'Peter Parker');

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8667FD), Color(0xFFC7BCFF), Color(0xFFF3F0FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Main Card Container (from Figma Login frame)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCD5FE).withOpacity(0.85),
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // White Logo
                        Image.asset(
                          'assets/images/logo.png',
                          width: 120,
                          color: Colors.white,
                          errorBuilder: (context, error, stackTrace) => Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.electric_moped,
                              color: AppColors.primaryPurple,
                              size: 38,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        if (!_isLogin) ...[
                          _buildInputContainer(
                            icon: Icons.badge_outlined,
                            hint: 'Nama Lengkap',
                            controller: _nameController,
                          ),
                          const SizedBox(height: 14),
                        ],

                        // WhatsApp / Email Field
                        _buildInputContainer(
                          icon: Icons.person,
                          hint: 'No. WhatsApp / Email',
                          controller: _identifierController,
                        ),
                        const SizedBox(height: 14),

                        // Password Field
                        _buildInputContainer(
                          icon: Icons.lock,
                          hint: 'Kata Sandi',
                          controller: _passwordController,
                          isPassword: true,
                          obscureText: _obscurePassword,
                          onToggleVisibility: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                        const SizedBox(height: 10),

                        // Lupa kata sandi link
                        if (_isLogin)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Kode OTP verifikasi dikirim ke nomor WhatsApp Anda'),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Lupa kata sandi?',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        // MASUK / DAFTAR Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryDark,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              _isLogin ? 'MASUK' : 'DAFTAR SEKARANG',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // ATAU Divider
                        Row(
                          children: [
                            Expanded(child: Container(height: 1, color: AppColors.textDark.withOpacity(0.2))),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'ATAU',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                            Expanded(child: Container(height: 1, color: AppColors.textDark.withOpacity(0.2))),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Lanjutkan Dengan Google Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _submit,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Multi-color G
                                const Icon(Icons.g_mobiledata, color: Colors.blue, size: 28),
                                const SizedBox(width: 8),
                                const Text(
                                  'Lanjutkan Dengan Google',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Switch between Login & Register
                        GestureDetector(
                          onTap: () {
                            setState(() => _isLogin = !_isLogin);
                          },
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                              children: [
                                TextSpan(
                                  text: _isLogin ? 'Belum punya akun? ' : 'Sudah punya akun? ',
                                ),
                                TextSpan(
                                  text: _isLogin ? 'Daftar Sekarang' : 'Masuk',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Guest mode fast-pass
                  TextButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.arrow_forward, color: AppColors.primaryDark, size: 16),
                    label: const Text(
                      'Masuk Langsung sebagai Tamu',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputContainer({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFC6BCFF).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.7)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 14, color: AppColors.textDark, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          icon: Icon(icon, color: AppColors.textDark, size: 20),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 13,
            color: AppColors.textDark.withOpacity(0.6),
          ),
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.textDark,
                    size: 18,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
        ),
      ),
    );
  }
}
