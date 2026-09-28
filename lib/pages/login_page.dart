import 'package:flutter/material.dart';
import 'loading_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'account_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool obscurePassword = true;
  bool rememberMe = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username/email dan password wajib diisi.',
          ),
        ),
      );
      return;
    }

    final success = AccountStore.login(
      input: username,
      inputPassword: password,
    );

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username/email atau password salah.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoadingPage(),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070A16),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth >= 900;

          return Stack(
            children: [
              // ==================================================
              // BACKGROUND DECORATION
              // ==================================================

              Positioned(
                top: -170,
                left: -170,
                child: Container(
                  width: 440,
                  height: 440,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6C63FF)
                        .withValues(alpha: 0.10),
                  ),
                ),
              ),

              Positioned(
                bottom: -190,
                right: -150,
                child: Container(
                  width: 440,
                  height: 440,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF8B5CF6)
                        .withValues(alpha: 0.08),
                  ),
                ),
              ),

              // ==================================================
              // CONTENT
              // ==================================================

              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 40 : 20,
                      vertical: 30,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 1250,
                      ),
                      child: isDesktop
                          ? Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 11,
                                  child: _buildHeroSection(),
                                ),
                                const SizedBox(width: 32),
                                Expanded(
                                  flex: 8,
                                  child: _buildLoginCard(),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _buildMobileHero(),
                                const SizedBox(height: 24),
                                _buildLoginCard(),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // HERO SECTION DESKTOP
  // ============================================================

  Widget _buildHeroSection() {
    return Container(
      height: 650,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF6C63FF)
              .withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF)
                .withValues(alpha: 0.10),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Image.asset(
        'assets/login/nexus_market_login_hero.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFF111729),
            alignment: Alignment.center,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.white54,
                  size: 60,
                ),
                SizedBox(height: 12),
                Text(
                  'NEXUS MARKET',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Hero image tidak ditemukan.',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // HERO SECTION MOBILE
  // ============================================================

  Widget _buildMobileHero() {
    return Container(
      width: double.infinity,
      height: 230,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF6C63FF)
              .withValues(alpha: 0.28),
        ),
      ),
      child: Image.asset(
        'assets/login/nexus_market_login_hero.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFF111729),
            alignment: Alignment.center,
            child: const Icon(
              Icons.image_not_supported_outlined,
              color: Colors.white54,
              size: 50,
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // LOGIN CARD
  // ============================================================

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF111729),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF6C63FF)
              .withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF)
                .withValues(alpha: 0.12),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ======================================================
          // LOGIN LOGO
          // ======================================================

          Container(
            height: 85,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF242653),
                  Color(0xFF1A1D40),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF6C63FF)
                    .withValues(alpha: 0.35),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.shopping_bag_rounded,
                color: Color(0xFF766BFF),
                size: 43,
              ),
            ),
          ),

          const SizedBox(height: 25),

          // ======================================================
          // TITLE
          // ======================================================

          const Text(
            'NEXUS MARKET',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.4,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Everything You Need, One Place.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 32),

          // ======================================================
          // USERNAME / EMAIL
          // ======================================================

          TextField(
            controller: usernameController,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              labelText: 'Username / Email',
              labelStyle: const TextStyle(
                color: Colors.white60,
              ),
              prefixIcon: const Icon(
                Icons.person_outline,
                color: Color(0xFF6C63FF),
              ),
              filled: true,
              fillColor: const Color(0xFF080D1D),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // PASSWORD
          // ======================================================

          TextField(
            controller: passwordController,
            obscureText: obscurePassword,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: const TextStyle(
                color: Colors.white60,
              ),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Color(0xFF6C63FF),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
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
              fillColor: const Color(0xFF080D1D),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ======================================================
          // REMEMBER ME + FORGOT PASSWORD
          // ======================================================

          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: (value) {
                  setState(() {
                    rememberMe = value ?? false;
                  });
                },
                activeColor: const Color(0xFF6C63FF),
              ),

              const Text(
                'Remember me',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),

              const Spacer(),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ForgotPasswordPage(),
                    ),
                  );
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Color(0xFF8C82FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ======================================================
          // LOGIN BUTTON
          // ======================================================

          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: const Color(0xFF6C63FF)
                    .withValues(alpha: 0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'LOGIN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ======================================================
          // OR DIVIDER
          // ======================================================

          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.white
                      .withValues(alpha: 0.12),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.white
                      .withValues(alpha: 0.12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ======================================================
          // REGISTER
          // ======================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account? ",
                style: TextStyle(
                  color: Colors.white60,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const RegisterPage(),
                    ),
                  );
                },
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Color(0xFF8C82FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            'NEXUS MARKET • DIGITAL MARKETPLACE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white24,
              fontSize: 10,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}