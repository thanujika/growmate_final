import 'package:flutter/material.dart';
import 'package:agri_app/localization.dart' hide Session;
import 'package:agri_app/services/session.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _priceAlerts = true;
  bool _weatherAlerts = true;
  bool _pestAlerts = false;
  bool _darkMode = false;
  bool _locationServices = true;

  String _selectedLanguage = 'en';
  String _selectedUnit = 'metric';

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        title: Text(
          l.settings,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// PROFILE CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Session.user?.name ?? 'Farmer',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        Text(Session.user?.email ?? '',
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _sectionHeader(l.notifications),
            _settingsCard([
              _switchTile(l.pushNotifications, _pushNotifications,
                  (v) => setState(() => _pushNotifications = v)),
              _switchTile(l.priceAlerts, _priceAlerts,
                  (v) => setState(() => _priceAlerts = v)),
              _switchTile(l.weatherAlerts, _weatherAlerts,
                  (v) => setState(() => _weatherAlerts = v)),
              _switchTile(l.pestWarnings, _pestAlerts,
                  (v) => setState(() => _pestAlerts = v)),
            ]),

            const SizedBox(height: 16),

            _sectionHeader(l.preferences),
            _settingsCard([
              _dropdownTile(
                l.language,
                _selectedLanguage,
                const {
                  'en': 'English',
                  'si': 'සිංහල',
                  'ta': 'தமிழ்',
                },
                (v) {
                  if (v == null) return;
                  setState(() => _selectedLanguage = v);
                  AppLocale.instance.setLocale(v);
                },
              ),
              _dropdownTile(
                l.units,
                _selectedUnit,
                {
                  'metric': l.unitMetric,
                  'imperial': l.unitImperial,
                },
                (v) => setState(() => _selectedUnit = v ?? 'metric'),
              ),
              _switchTile(l.darkMode, _darkMode,
                  (v) => setState(() => _darkMode = v)),
              _switchTile(l.locationServices, _locationServices,
                  (v) => setState(() => _locationServices = v)),
            ]),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Session.clear();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: const Icon(Icons.logout),
                label: Text(l.signOut),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// HELPERS

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: Color(0xFF1B5E20)),
        ),
      );

  Widget _settingsCard(List<Widget> children) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: children),
      );

  Widget _switchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      title: Text(title),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }

  Widget _dropdownTile(
    String title,
    String value,
    Map<String, String> items,
    ValueChanged<String?> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        items: items.entries
            .map((e) =>
                DropdownMenuItem(value: e.key, child: Text(e.value)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}