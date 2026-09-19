import 'package:flutter/material.dart';

void main() {
  runApp(const NexusApp());
}

class NexusApp extends StatelessWidget {
  const NexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NEXUS LIFE RPG',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Georgia',
      ),
      home: const LoginPage(),
    );
  }
}

// ============================================================
// COLORS
// ============================================================

const Color nexusBlue = Color(0xFF18345F);
const Color nexusGold = Color(0xFFE2BC63);
const Color nexusWhite = Color(0xFFF5F1E8);

// ============================================================
// LOGIN
// ============================================================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
  bool rememberMe = false;

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username == 'kelvin' && password == '12345') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const NexusHomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username atau password salah.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/nexus_world.png',
            fit: BoxFit.cover,
          ),

          // Membuat area tengah sedikit lebih gelap supaya form terbaca.
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.10),
                  Colors.black.withOpacity(0.42),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'NEXUS',
                        style: TextStyle(
                          fontSize: 52,
                          letterSpacing: 11,
                          fontWeight: FontWeight.w400,
                          color: nexusWhite,
                          shadows: [
                            Shadow(
                              blurRadius: 14,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'L I F E   R P G',
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: 7,
                          color: nexusWhite,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'YOUR LIFE, A GREATER ADVENTURE',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 2.2,
                          color: nexusWhite,
                        ),
                      ),
                      const SizedBox(height: 28),

                      _loginCard(),

                      const SizedBox(height: 20),
                      const Text(
                        'EXPLORE  •  GROW  •  LEVEL UP',
                        style: TextStyle(
                          fontSize: 10,
                          letterSpacing: 2,
                          color: nexusWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
      decoration: BoxDecoration(
        color: const Color(0xE8192F50),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: nexusGold,
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Welcome, Traveler',
            style: TextStyle(
              fontSize: 27,
              color: nexusWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Log in to continue your journey',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 25),

          _field(
            controller: usernameController,
            label: 'Username',
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 14),

          _field(
            controller: passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: hidePassword,
            suffix: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              icon: Icon(
                hidePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.white70,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Checkbox(
                value: rememberMe,
                activeColor: nexusGold,
                checkColor: nexusBlue,
                onChanged: (value) {
                  setState(() {
                    rememberMe = value ?? false;
                  });
                },
              ),
              const Text(
                'Remember me',
                style: TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: nexusGold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: login,
              style: ElevatedButton.styleFrom(
                backgroundColor: nexusBlue,
                foregroundColor: nexusWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(
                    color: nexusGold,
                    width: 1.5,
                  ),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 19),
                  SizedBox(width: 10),
                  Text(
                    'BEGIN YOUR JOURNEY',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: const [
              Expanded(child: Divider(color: Colors.white24)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'OR CONTINUE WITH',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white54,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.white24)),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _social(Icons.g_mobiledata),
              const SizedBox(width: 12),
              _social(Icons.gamepad_outlined),
              const SizedBox(width: 12),
              _social(Icons.code),
            ],
          ),

          const SizedBox(height: 18),

          const Text(
            'New to NEXUS?',
            style: TextStyle(color: Colors.white60),
          ),

          TextButton(
            onPressed: () {},
            child: const Text(
              'CREATE ACCOUNT',
              style: TextStyle(
                color: nexusGold,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: nexusWhite),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(0.09),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: nexusGold),
        ),
      ),
    );
  }

  Widget _social(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: nexusWhite),
      ),
    );
  }
}


// ============================================================
// HOME - FANTASY RPG DASHBOARD
// ============================================================

class NexusHomePage extends StatefulWidget {
  const NexusHomePage({super.key});

  @override
  State<NexusHomePage> createState() => _NexusHomePageState();
}

class _NexusHomePageState extends State<NexusHomePage> {
  int selectedNav = 0;
  int xp = 1250;
  int energy = 72;
  int streak = 7;

  final List<_QuestData> quests = [
    _QuestData(
      icon: Icons.menu_book_rounded,
      title: 'Study',
      subtitle: 'Complete assignment',
      reward: 50,
      category: 'Knowledge',
    ),
    _QuestData(
      icon: Icons.fitness_center_rounded,
      title: 'Exercise',
      subtitle: '30 minutes workout',
      reward: 30,
      category: 'Strength',
    ),
    _QuestData(
      icon: Icons.auto_stories_rounded,
      title: 'Read',
      subtitle: 'Read for 20 minutes',
      reward: 20,
      category: 'Wisdom',
    ),
    _QuestData(
      icon: Icons.spa_rounded,
      title: 'Meditate',
      subtitle: 'Relax your mind',
      reward: 20,
      category: 'Focus',
    ),
    _QuestData(
      icon: Icons.code_rounded,
      title: 'Practice Coding',
      subtitle: 'Practice Flutter for 30 minutes',
      reward: 40,
      category: 'Skill',
    ),
    _QuestData(
      icon: Icons.note_alt_rounded,
      title: 'Review Notes',
      subtitle: 'Review today\'s lecture notes',
      reward: 35,
      category: 'Knowledge',
    ),
    _QuestData(
      icon: Icons.water_drop_rounded,
      title: 'Drink Water',
      subtitle: 'Drink 6-8 glasses today',
      reward: 15,
      category: 'Health',
    ),
    _QuestData(
      icon: Icons.event_note_rounded,
      title: 'Plan Tomorrow',
      subtitle: 'Prepare tomorrow\'s activities',
      reward: 25,
      category: 'Planning',
    ),
  ];

  final List<_StatData> stats = [
    _StatData('Intelligence', 82, Icons.psychology_rounded),
    _StatData('Strength', 67, Icons.fitness_center_rounded),
    _StatData('Focus', 74, Icons.center_focus_strong_rounded),
    _StatData('Discipline', 80, Icons.shield_rounded),
    _StatData('Happiness', 76, Icons.auto_awesome_rounded),
  ];

  int get level => 12;
  double get xpProgress => xp / 2000;

  void completeQuest(int index) {
    final quest = quests[index];

    if (quest.completed) {
      return;
    }

    setState(() {
      quest.completed = true;
      xp += quest.reward;
      energy = (energy - 5).clamp(0, 100);
      streak += 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${quest.title} selesai! +${quest.reward} EXP ✦',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showQuestDetails(int index) {
    final quest = quests[index];

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF102845),
        title: Row(
          children: [
            Icon(quest.icon, color: nexusGold),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                quest.title,
                style: const TextStyle(color: nexusWhite),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quest.subtitle,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 14),
            Text(
              'Category: ${quest.category}',
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              'Reward: +${quest.reward} EXP',
              style: const TextStyle(
                color: nexusGold,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CLOSE'),
          ),
          if (!quest.completed)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                completeQuest(index);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: nexusGold,
                foregroundColor: const Color(0xFF102845),
              ),
              child: const Text('COMPLETE QUEST'),
            ),
        ],
      ),
    );
  }

  void openComingSoon(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title akan tersedia di update berikutnya ✦'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07152A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/nexus_world.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.18),
                  const Color(0xD907162A),
                  const Color(0xF507162A),
                ],
                stops: const [0.0, 0.46, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 900;

                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    wide ? 42 : 18,
                    18,
                    wide ? 42 : 18,
                    36,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1250),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _topBar(wide),
                          const SizedBox(height: 34),
                          _heroHeader(wide),
                          const SizedBox(height: 22),
                          _playerPanel(wide),
                          const SizedBox(height: 28),
                          _sectionHeader(
                            icon: Icons.auto_awesome_rounded,
                            title: 'DAILY QUESTS',
                            subtitle: 'Small steps. Great adventures.',
                            action: 'VIEW ALL',
                            onTap: () => openComingSoon('Quest Board'),
                          ),
                          const SizedBox(height: 14),
                          _questGrid(wide),
                          const SizedBox(height: 28),
                          _sectionHeader(
                            icon: Icons.shield_moon_rounded,
                            title: 'CHARACTER STATS',
                            subtitle: 'Your current attributes',
                            action: 'DETAIL',
                            onTap: () => openComingSoon('Character Stats'),
                          ),
                          const SizedBox(height: 14),
                          _statsPanel(wide),
                          const SizedBox(height: 28),
                          _bottomQuote(),
                          const SizedBox(height: 18),
                          _bottomNavigation(wide),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(bool wide) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xD60A203B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.24),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: nexusGold, width: 1.4),
              color: const Color(0xFF17345D),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: nexusGold,
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NEXUS',
                style: TextStyle(
                  color: nexusWhite,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3.2,
                ),
              ),
              Text(
                'LIFE RPG',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 8,
                  letterSpacing: 2.8,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (wide) ...[
            _topAction(Icons.home_rounded, 'HOME', true),
            _topAction(Icons.explore_rounded, 'QUEST', false),
            _topAction(Icons.person_rounded, 'CHARACTER', false),
            _topAction(Icons.emoji_events_rounded, 'ACHIEVEMENT', false),
          ],
          const SizedBox(width: 6),
          _iconButton(
            Icons.notifications_none_rounded,
            () => openComingSoon('Notifications'),
          ),
          const SizedBox(width: 5),
          _iconButton(
            Icons.settings_outlined,
            () => openComingSoon('Settings'),
          ),
          const SizedBox(width: 5),
          _iconButton(
            Icons.person_outline_rounded,
            () => openComingSoon('Profile'),
          ),
          const SizedBox(width: 5),
          _iconButton(
            Icons.logout_rounded,
            logout,
          ),
        ],
      ),
    );
  }

  Widget _topAction(IconData icon, String label, bool active) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (!active) {
          openComingSoon(label);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(0.09) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: active
              ? Border.all(color: nexusGold.withOpacity(0.5))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: active ? nexusGold : Colors.white70,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                letterSpacing: 1.2,
                color: active ? nexusWhite : Colors.white60,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white70, size: 21),
      tooltip: 'NEXUS',
    );
  }

  Widget _heroHeader(bool wide) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ADVENTURER DASHBOARD',
                style: TextStyle(
                  color: nexusGold,
                  fontSize: 10,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Good Morning,',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.82),
                  fontSize: wide ? 22 : 18,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Kelvin ✦',
                style: TextStyle(
                  color: nexusWhite,
                  fontSize: wide ? 44 : 34,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  shadows: const [
                    Shadow(
                      blurRadius: 15,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Another day, another step toward a better you.',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        if (wide)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xAA0B2340),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white12),
            ),
            child: const Row(
              children: [
                Icon(Icons.wb_sunny_outlined, color: nexusGold, size: 20),
                SizedBox(width: 9),
                Text(
                  'DAY 27  •  MONDAY',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _playerPanel(bool wide) {
    return Container(
      padding: EdgeInsets.all(wide ? 22 : 17),
      decoration: BoxDecoration(
        color: const Color(0xE30A213C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: nexusGold.withOpacity(0.78),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.28),
            blurRadius: 30,
            spreadRadius: 1,
          ),
        ],
      ),
      child: wide
          ? Row(
              children: [
                _avatar(),
                const SizedBox(width: 18),
                Expanded(child: _playerInfo()),
                const SizedBox(width: 16),
                _resourceColumn(),
              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    _avatar(),
                    const SizedBox(width: 14),
                    Expanded(child: _playerInfo()),
                  ],
                ),
                const SizedBox(height: 16),
                _resourceColumn(),
              ],
            ),
    );
  }

  Widget _avatar() {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF244E83),
            Color(0xFF102B50),
          ],
        ),
        border: Border.all(color: nexusGold, width: 2),
        boxShadow: [
          BoxShadow(
            color: nexusGold.withOpacity(0.18),
            blurRadius: 18,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/profile_kelvin.jpeg',
          width: 78,
          height: 78,
          fit: BoxFit.cover,
          alignment: const Alignment(0, -0.05),
          errorBuilder: (_, __, ___) => const Icon(
            Icons.person_rounded,
            size: 48,
            color: nexusWhite,
          ),
        ),
      ),
    );
  }

  Widget _playerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'LEVEL 12',
              style: TextStyle(
                color: nexusGold,
                fontSize: 13,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 9),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: nexusGold.withOpacity(0.13),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'TRAVELER',
                style: TextStyle(
                  color: nexusGold,
                  fontSize: 7,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        const SizedBox(height: 4),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 4,
          children: [
            const Text(
              'Kelvin',
              style: TextStyle(
                color: nexusWhite,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: nexusGold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: nexusGold.withOpacity(0.55)),
              ),
              child: const Text(
                'NIM 25051204439',
                style: TextStyle(
                  color: nexusGold,
                  fontSize: 10,
                  letterSpacing: 1.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              'EXP',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 9,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$xp / 2000',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: xpProgress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Colors.white12,
            valueColor: const AlwaysStoppedAnimation<Color>(nexusGold),
          ),
        ),
      ],
    );
  }

  Widget _resourceColumn() {
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      alignment: WrapAlignment.end,
      children: [
        _resource(Icons.favorite_rounded, '$level', 'LEVEL'),
        _resource(Icons.bolt_rounded, '$energy', 'ENERGY'),
        _resource(Icons.local_fire_department_rounded, '$streak', 'STREAK'),
      ],
    );
  }

  Widget _resource(IconData icon, String value, String label) {
    return Container(
      width: 88,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.055),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(icon, color: nexusGold, size: 19),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: nexusWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 7,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required String action,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: nexusGold.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: nexusGold.withOpacity(0.35)),
          ),
          child: Icon(icon, color: nexusGold, size: 18),
        ),
        const SizedBox(width: 11),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: nexusWhite,
                fontSize: 16,
                letterSpacing: 1.7,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          child: Text(
            action,
            style: const TextStyle(
              color: nexusGold,
              fontSize: 9,
              letterSpacing: 1.3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // DAILY QUESTS menggunakan ListView agar daftar quest
  // dapat menampung item lebih banyak tanpa memenuhi halaman.
  Widget _questGrid(bool wide) {
    if (wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8, left: 4),
            child: Row(
              children: [
                Icon(Icons.swipe_rounded, size: 17, color: Color(0xFFE2BC63)),
                SizedBox(width: 6),
                Text(
                  'Geser untuk melihat quest lainnya',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 235,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: quests.length,
              padding: const EdgeInsets.only(right: 4),
              separatorBuilder: (_, __) => const SizedBox(width: 13),
              itemBuilder: (_, index) => SizedBox(
                width: 275,
                child: _questCard(quests[index], index),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: quests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 11),
      itemBuilder: (_, index) => _questCard(quests[index], index),
    );
  }

  Widget _questCard(_QuestData quest, int index) {
    return InkWell(
      onTap: () => showQuestDetails(index),
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: quest.completed
              ? const Color(0xB6133D35)
              : const Color(0xD80A2745),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: quest.completed
                ? const Color(0xFF71C9A7).withOpacity(0.65)
                : Colors.white.withOpacity(0.14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    color: nexusGold.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    quest.icon,
                    color: nexusGold,
                    size: 21,
                  ),
                ),
                const Spacer(),
                Text(
                  '+${quest.reward} EXP',
                  style: const TextStyle(
                    color: nexusGold,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Text(
              quest.title,
              style: const TextStyle(
                color: nexusWhite,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              quest.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
            const Spacer(),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 34,
              child: OutlinedButton(
                onPressed:
                    quest.completed ? null : () => completeQuest(index),
                style: OutlinedButton.styleFrom(
                  foregroundColor: quest.completed
                      ? const Color(0xFF71C9A7)
                      : nexusWhite,
                  side: BorderSide(
                    color: quest.completed
                        ? const Color(0xFF71C9A7).withOpacity(0.5)
                        : nexusGold.withOpacity(0.55),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                child: Text(
                  quest.completed ? '✓ COMPLETED' : 'COMPLETE QUEST',
                  style: const TextStyle(
                    fontSize: 8,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statsPanel(bool wide) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xD80A213C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: wide
          ? Row(
              children: stats
                  .map(
                    (stat) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: _statItem(stat),
                      ),
                    ),
                  )
                  .toList(),
            )
          : Column(
              children: stats
                  .map(
                    (stat) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: _statItem(stat),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  Widget _statItem(_StatData stat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(stat.icon, color: nexusGold, size: 16),
            const SizedBox(width: 7),
            Expanded(
              child: Text(
                stat.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ),
            Text(
              '${stat.value}',
              style: const TextStyle(
                color: nexusGold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: stat.value / 100,
            minHeight: 6,
            backgroundColor: Colors.white10,
            valueColor: const AlwaysStoppedAnimation<Color>(nexusGold),
          ),
        ),
      ],
    );
  }

  Widget _bottomQuote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xCC102D4E),
            const Color(0xAA0B2038),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: nexusGold.withOpacity(0.38)),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: nexusGold,
            size: 31,
          ),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Every journey begins with a single step.',
                  style: TextStyle(
                    color: nexusWhite,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '— NEXUS ADVENTURER GUIDE',
                  style: TextStyle(
                    color: nexusGold,
                    fontSize: 8,
                    letterSpacing: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigation(bool wide) {
    if (wide) {
      return const SizedBox.shrink();
    }

    final items = [
      (Icons.home_rounded, 'Home'),
      (Icons.explore_rounded, 'Quest'),
      (Icons.person_rounded, 'Character'),
      (Icons.emoji_events_rounded, 'Rewards'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xE60A203A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final active = selectedNav == index;

          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(13),
              onTap: () {
                setState(() => selectedNav = index);
                if (index != 0) {
                  openComingSoon(item.$2);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: active
                      ? nexusGold.withOpacity(0.10)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  children: [
                    Icon(
                      item.$1,
                      size: 20,
                      color: active ? nexusGold : Colors.white54,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.$2,
                      style: TextStyle(
                        color: active ? nexusWhite : Colors.white54,
                        fontSize: 8,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _QuestData {
  final IconData icon;
  final String title;
  final String subtitle;
  final int reward;
  final String category;
  bool completed;

  _QuestData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.reward,
    required this.category,
    this.completed = false,
  });
}

class _StatData {
  final String name;
  final int value;
  final IconData icon;

  const _StatData(this.name, this.value, this.icon);
}
