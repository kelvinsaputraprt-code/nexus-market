import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;
  bool orderUpdates = true;
  bool promotionalOffers = false;
  bool compactMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FC),
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Notifications'),

          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Terima notifikasi dari NEXUS MARKET',
            value: notifications,
            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },
          ),

          _buildSwitchTile(
            icon: Icons.local_shipping_outlined,
            title: 'Order Updates',
            subtitle: 'Notifikasi perubahan status pesanan',
            value: orderUpdates,
            onChanged: (value) {
              setState(() {
                orderUpdates = value;
              });
            },
          ),

          _buildSwitchTile(
            icon: Icons.campaign_outlined,
            title: 'Promotional Offers',
            subtitle: 'Dapatkan informasi promo dan penawaran',
            value: promotionalOffers,
            onChanged: (value) {
              setState(() {
                promotionalOffers = value;
              });
            },
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Appearance'),

          _buildSwitchTile(
            icon: Icons.view_compact_outlined,
            title: 'Compact Mode',
            subtitle: 'Gunakan tampilan yang lebih ringkas',
            value: compactMode,
            onChanged: (value) {
              setState(() {
                compactMode = value;
              });
            },
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Account'),

          _buildActionTile(
            icon: Icons.person_outline,
            title: 'Account Information',
            subtitle: 'Lihat informasi akun kamu',
            onTap: () {
              _showAccountInformation(context);
            },
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('About'),

          _buildActionTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy',
            subtitle: 'Informasi privasi dan keamanan',
            onTap: () {
              _showPrivacy(context);
            },
          ),

          _buildActionTile(
            icon: Icons.info_outline,
            title: 'About NEXUS MARKET',
            subtitle: 'Informasi aplikasi',
            onTap: () {
              _showAbout(context);
            },
          ),

          const SizedBox(height: 30),

          Center(
            child: Text(
              'NEXUS MARKET',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade300,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        secondary: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.deepPurple.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.deepPurple,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.deepPurple.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.deepPurple,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showAccountInformation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Account Information',
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Kelvin',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Class',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Informatika 2025 H',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Membership',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'NEXUS MARKET Member',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Privacy',
          ),
          content: const Text(
            'NEXUS MARKET menjaga informasi akun dan data pengguna '
            'agar tetap digunakan sesuai kebutuhan aplikasi.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'NEXUS MARKET',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.shopping_bag_outlined,
        size: 40,
        color: Colors.deepPurple,
      ),
      children: const [
        SizedBox(height: 12),
        Text(
          'NEXUS MARKET adalah aplikasi marketplace '
          'untuk mencari, menyimpan, dan membeli berbagai produk.',
        ),
      ],
    );
  }
}