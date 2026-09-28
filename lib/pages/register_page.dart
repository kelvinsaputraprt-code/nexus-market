import 'package:flutter/material.dart';
import 'account_store.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void register() {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword =
        confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Semua data wajib diisi.',
          ),
        ),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Masukkan email yang valid.',
          ),
        ),
      );
      return;
    }

    if (password.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password minimal 5 karakter.',
          ),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Konfirmasi password tidak cocok.',
          ),
        ),
      );
      return;
    }

    AccountStore.createAccount(
      newUsername: username,
      newEmail: email,
      newPassword: password,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Akun berhasil dibuat. Silakan login.',
        ),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080C18),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 450,
            ),

            child: Container(
              padding: const EdgeInsets.all(30),

              decoration: BoxDecoration(
                color: const Color(0xFF12182A),

                borderRadius:
                    BorderRadius.circular(28),

                border: Border.all(
                  color: const Color(0xFF6C63FF)
                      .withValues(alpha: 0.18),
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                children: [
                  const Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 60,
                    color: Color(0xFF766BFF),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'JOIN NEXUS',
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Create your NEXUS MARKET account',
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.white60,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // USERNAME
                  TextField(
                    controller: usernameController,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle:
                          const TextStyle(
                        color: Colors.white60,
                      ),

                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF6C63FF),
                      ),

                      filled: true,

                      fillColor:
                          const Color(0xFF0B1020),

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // EMAIL
                  TextField(
                    controller: emailController,

                    keyboardType:
                        TextInputType.emailAddress,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: InputDecoration(
                      labelText: 'Email',

                      labelStyle:
                          const TextStyle(
                        color: Colors.white60,
                      ),

                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Color(0xFF6C63FF),
                      ),

                      filled: true,

                      fillColor:
                          const Color(0xFF0B1020),

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // PASSWORD
                  TextField(
                    controller: passwordController,

                    obscureText: obscurePassword,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: InputDecoration(
                      labelText: 'Password',

                      labelStyle:
                          const TextStyle(
                        color: Colors.white60,
                      ),

                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xFF6C63FF),
                      ),

                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },

                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white60,
                        ),
                      ),

                      filled: true,

                      fillColor:
                          const Color(0xFF0B1020),

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // CONFIRM PASSWORD
                  TextField(
                    controller:
                        confirmPasswordController,

                    obscureText:
                        obscureConfirmPassword,

                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: InputDecoration(
                      labelText:
                          'Confirm Password',

                      labelStyle:
                          const TextStyle(
                        color: Colors.white60,
                      ),

                      prefixIcon: const Icon(
                        Icons.lock_reset_outlined,
                        color: Color(0xFF6C63FF),
                      ),

                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword =
                                !obscureConfirmPassword;
                          });
                        },

                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white60,
                        ),
                      ),

                      filled: true,

                      fillColor:
                          const Color(0xFF0B1020),

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    height: 54,

                    child: ElevatedButton(
                      onPressed: register,

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF6C63FF),

                        foregroundColor:
                            Colors.white,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),

                      child: const Text(
                        'CREATE ACCOUNT',

                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
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
}