import 'package:flutter/material.dart';
import 'account_store.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {
  final accountController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController =
      TextEditingController();

  bool accountVerified = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    accountController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void verifyAccount() {
    final input = accountController.text.trim();

    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Masukkan username atau email.',
          ),
        ),
      );
      return;
    }

    if (!AccountStore.checkAccount(input)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Akun tidak ditemukan.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      accountVerified = true;
    });
  }

  void resetPassword() {
    final password = newPasswordController.text;
    final confirmPassword =
        confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password baru wajib diisi.',
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

    AccountStore.changePassword(password);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Password berhasil diubah.',
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
          'Forgot Password',
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
                    Icons.lock_reset_rounded,
                    size: 62,
                    color: Color(0xFF766BFF),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'RESET PASSWORD',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    accountVerified
                        ? 'Buat password baru untuk akunmu.'
                        : 'Masukkan username atau email akunmu.',

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      color: Colors.white60,
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (!accountVerified) ...[
                    TextField(
                      controller: accountController,

                      style: const TextStyle(
                        color: Colors.white,
                      ),

                      decoration: InputDecoration(
                        labelText:
                            'Username / Email',

                        labelStyle:
                            const TextStyle(
                          color: Colors.white60,
                        ),

                        prefixIcon: const Icon(
                          Icons.person_search_outlined,
                          color: Color(0xFF6C63FF),
                        ),

                        filled: true,

                        fillColor:
                            const Color(0xFF0B1020),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 54,

                      child: ElevatedButton(
                        onPressed: verifyAccount,

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
                          'VERIFY ACCOUNT',

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],

                  if (accountVerified) ...[
                    TextField(
                      controller:
                          newPasswordController,

                      obscureText:
                          obscurePassword,

                      style: const TextStyle(
                        color: Colors.white,
                      ),

                      decoration: InputDecoration(
                        labelText:
                            'New Password',

                        labelStyle:
                            const TextStyle(
                          color: Colors.white60,
                        ),

                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF6C63FF),
                        ),

                        suffixIcon:
                            IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword =
                                  !obscurePassword;
                            });
                          },

                          icon: Icon(
                            obscurePassword
                                ? Icons
                                    .visibility_outlined
                                : Icons
                                    .visibility_off_outlined,

                            color: Colors.white60,
                          ),
                        ),

                        filled: true,

                        fillColor:
                            const Color(0xFF0B1020),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

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
                            'Confirm New Password',

                        labelStyle:
                            const TextStyle(
                          color: Colors.white60,
                        ),

                        prefixIcon: const Icon(
                          Icons.lock_reset_outlined,
                          color: Color(0xFF6C63FF),
                        ),

                        suffixIcon:
                            IconButton(
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword =
                                  !obscureConfirmPassword;
                            });
                          },

                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons
                                    .visibility_outlined
                                : Icons
                                    .visibility_off_outlined,

                            color: Colors.white60,
                          ),
                        ),

                        filled: true,

                        fillColor:
                            const Color(0xFF0B1020),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      height: 54,

                      child: ElevatedButton(
                        onPressed: resetPassword,

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
                          'RESET PASSWORD',

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}