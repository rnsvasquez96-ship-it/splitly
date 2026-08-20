import 'package:flutter/material.dart';

import '../../auth/services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      await AuthService.instance.signOut();
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text("Unable to sign out: $error")),
      );
    }
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "Splitly",
      applicationVersion: "1.0.0",
      applicationIcon: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.account_balance_wallet_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
      children: const [
        Text(
          "Splitly is a smart group expense manager "
          "designed to make splitting expenses, tracking "
          "budgets, and settling balances simple.",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;

    final email = user?.email ?? "Guest";

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF6F7FB),
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            _ProfileCard(email: email),

            const SizedBox(height: 28),

            const _SectionTitle(title: "Preferences"),

            const SizedBox(height: 12),

            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: "Notifications",
                  subtitle: "Budget and expense reminders",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Notification preferences coming soon."),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 68),
                _SettingsTile(
                  icon: Icons.currency_exchange_rounded,
                  title: "Currency",
                  subtitle: "Philippine Peso (PHP)",
                  trailing: const Text(
                    "₱",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Splitly currently uses Philippine Peso.",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 28),

            const _SectionTitle(title: "App"),

            const SizedBox(height: 12),

            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: "About Splitly",
                  subtitle: "Version 1.0.0",
                  onTap: () {
                    _showAbout(context);
                  },
                ),
                const Divider(height: 1, indent: 68),
                _SettingsTile(
                  icon: Icons.shield_outlined,
                  title: "Privacy",
                  subtitle: "Your account and expense data",
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text("Privacy"),
                          content: const Text(
                            "Splitly stores the information required "
                            "to manage your account, groups, expenses, "
                            "budgets, and settlements.",
                          ),
                          actions: [
                            FilledButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text("Got it"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 28),

            SizedBox(
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () {
                  _signOut(context);
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text("Sign Out"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red.withValues(alpha: .35)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Splitly • Smart Expense Manager",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String email;

  const _ProfileCard({required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Splitly Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
