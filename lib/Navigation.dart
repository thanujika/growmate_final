import 'package:agri_app/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'MainHomeScreen.dart';
import 'Chatbot.dart';
import 'Market.dart';
import 'Machine.dart';
import "Profile.dart";

// ─── COLORS ───────────────────────────────────────────────────────────────────
class NavColors {
  static const primary     = Color(0xFF1B6B3A);
  static const primaryDark = Color(0xFF0D4A26);
  static const gold        = Color(0xFFD4A017);
  static const success     = Color(0xFF38A169);
}

// ─── MAIN NAVIGATION ──────────────────────────────────────────────────────────
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int  _navIndex   = 0;
  bool _drawerOpen = false;

  // All nav items across GROW MATE + GROW MARKET sections
  static const List<Map<String, dynamic>> _navItems = [
    // ── GROW MATE section ──────────────────────────────────────────────────
    {'idx': 0, 'icon': Icons.home_rounded,           'label': 'Home',          'sub': 'Dashboard & overview',     'section': 'GROW MATE'},
    {'idx': 1, 'icon': Icons.smart_toy_rounded,      'label': 'AgroBot',       'sub': 'AI farming assistant',     'section': null},
    {'idx': 3, 'icon': Icons.agriculture_rounded,    'label': 'Machine Hire',  'sub': 'Rent farm machinery',      'section': null},
    {'idx': 4, 'icon': Icons.agriculture_rounded,    'label': 'Fertilizer',    'sub': 'Browse fertilizers',       'section': null},
    {'idx': 5, 'icon': Icons.agriculture_rounded,    'label': 'Profile',       'sub': 'Manage your profile',      'section': null},
    // ── GROW MARKET section ─────────────────────────────────────────────────
    {'idx': 5, 'icon': Icons.store_rounded,          'label': 'Market',        'sub': 'Browse all products',      'section': 'GROW MARKET'},
    {'idx': 6, 'icon': Icons.receipt_long_rounded,   'label': 'My Orders',     'sub': 'Track your orders',        'section': null},
    {'idx': 7, 'icon': Icons.inventory_2_outlined,   'label': 'My Listings',   'sub': 'Edit, update, delete',     'section': null},
    {'idx': 2, 'icon': Icons.add_circle_outline,     'label': 'Post Product',  'sub': 'List your farm produce',   'section': null},
  ];

  Widget _screenFor(int idx) {
    switch (idx) {
      case 0:  return const MainHomeScreen();
      case 1:  return const ChatbotScreen();
      case 2:  return const SellScreen();
      case 3:  return const MachineHiringScreen();
      case 4:  return const DashboardScreen();
      case 5:  return const ProfileScreen();
      case 6:  return const AgriMarketApp();
      case 7:  return const OrderHistoryScreen();
      case 8:  return const MyListingsScreen();
      
      
      
      default: return const MainHomeScreen();
    }
  }

  void _select(int idx) => setState(() {
    _navIndex   = idx;
    _drawerOpen = false;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5EE),
      body: SafeArea(
        child: Stack(
          children: [
            // ── FULL-WIDTH SCREEN ─────────────────────────────────────────
            _screenFor(_navIndex),

            // ── FLOATING HAMBURGER ────────────────────────────────────────
            Positioned(
              top: 12, left: 12,
              child: GestureDetector(
                onTap: () => setState(() => _drawerOpen = !_drawerOpen),
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: _drawerOpen ? NavColors.primaryDark : NavColors.gold,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _drawerOpen
                        ? const Icon(Icons.close_rounded, key: ValueKey('c'), color: Colors.white,          size: 22)
                        : const Icon(Icons.menu_rounded,  key: ValueKey('m'), color: NavColors.primaryDark, size: 22),
                  ),
                ),
              ),
            ),

            // ── DRAWER OVERLAY ────────────────────────────────────────────
            if (_drawerOpen) ...[
              // Scrim
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => _drawerOpen = false),
                  child: Container(color: Colors.black.withOpacity(0.4)),
                ),
              ),

              // Sliding panel
              Positioned(
                top: 0, bottom: 0, left: 0,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: -1.0, end: 0.0),
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  builder: (_, val, child) => Transform.translate(offset: Offset(val * 280, 0), child: child),
                  child: Container(
                    width: 280,
                    decoration: const BoxDecoration(
                      color: NavColors.primaryDark,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(6, 0))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header ────────────────────────────────────────
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                          color: Colors.black.withOpacity(0.2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Container(
                                width: 52, height: 52,
                                decoration: BoxDecoration(color: NavColors.gold, borderRadius: BorderRadius.circular(14)),
                                child: const Icon(Icons.eco_rounded, color: NavColors.primaryDark, size: 28),
                              ),
                              const SizedBox(height: 14),
                              const Text('Grow Mate',
                                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                              Text('Smart Farming Platform',
                                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                            ],
                          ),
                        ),

                        // ── Scrollable nav list ───────────────────────────
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ..._buildNavList(),
                                const SizedBox(height: 12),
                                Divider(color: Colors.white.withOpacity(0.08), indent: 20, endIndent: 20),
                                const SizedBox(height: 12),
                                // Quick-access tiles
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8, bottom: 8),
                                        child: Text('QUICK ACCESS',
                                            style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                                      ),
                                      _quickAction(icon: Icons.smart_toy_rounded,   label: 'Ask AgroBot',    sub: 'AI crop assistant',       color: const Color(0xFF805AD5), onTap: () => _select(1)),
                                      const SizedBox(height: 8),
                                      _quickAction(icon: Icons.agriculture_rounded, label: 'Hire Machinery', sub: 'Find machines near you',   color: NavColors.gold,         onTap: () => _select(3)),
                                      const SizedBox(height: 8),
                                      _quickAction(icon: Icons.add_circle_outline,  label: 'Post Product',  sub: 'List your farm produce',   color: NavColors.success,      onTap: () => _select(2)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ── User footer ───────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08)))),
                          child: Row(
                            children: [
                              Container(
                                width: 38, height: 38,
                                decoration: const BoxDecoration(color: NavColors.gold, shape: BoxShape.circle),
                                child: const Center(child: Text('SK', style: TextStyle(color: NavColors.primaryDark, fontWeight: FontWeight.w800, fontSize: 12))),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  
                                ),
                              ),
                              const Icon(Icons.circle, color: NavColors.success, size: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Build nav list with section headers
  List<Widget> _buildNavList() {
    final widgets = <Widget>[];
    String? lastSection;

    for (final item in _navItems) {
      final section = item['section'] as String?;

      if (section != null && section != lastSection) {
        lastSection = section;
        widgets.add(Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
          child: Text(section,
              style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
        ));
      }

      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: _drawerItem(item['idx'] as int, item['icon'] as IconData, item['label'] as String, item['sub'] as String),
      ));
    }

    return widgets;
  }

  // Drawer nav item
  Widget _drawerItem(int idx, IconData icon, String label, String sub) {
    final active = _navIndex == idx;
    return GestureDetector(
      onTap: () => _select(idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: active ? Border.all(color: Colors.white.withOpacity(0.15)) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: active ? NavColors.gold.withOpacity(0.2) : Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: active ? NavColors.gold : Colors.white60, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: active ? Colors.white : Colors.white70, fontWeight: active ? FontWeight.w700 : FontWeight.w500, fontSize: 14)),
                  Text(sub,   style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 11)),
                ],
              ),
            ),
            if (active)
              Container(width: 4, height: 28, decoration: BoxDecoration(color: NavColors.gold, borderRadius: BorderRadius.circular(2))),
          ],
        ),
      ),
    );
  }

  // Quick-action tile
  Widget _quickAction({required IconData icon, required String label, required String sub, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.25))),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(9)), child: Icon(icon, color: color, size: 18)),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
              Text(sub,   style: TextStyle(color: color.withOpacity(0.7), fontSize: 11)),
            ]),
          ],
        ),
      ),
    );
  }
}
