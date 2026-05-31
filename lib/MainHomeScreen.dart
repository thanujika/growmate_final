import 'package:flutter/material.dart';
import 'services/api_service.dart';


// ════════════════════════════════════════════════════════════════════════════
// If you have the merged main.dart, replace this stub with:
//   import 'main.dart';   (or wherever Session / AppUser live)
// ════════════════════════════════════════════════════════════════════════════

class AppUser {
  final String name, email, phone, cropType, region;
  const AppUser({
    required this.name, required this.email,
    required this.phone, required this.cropType, required this.region,
  });
}


// ════════════════════════════════════════════════════════════════════════════
// COLOUR TOKENS  (matches main.dart AppColors)
// ════════════════════════════════════════════════════════════════════════════

class _C {
  static const bg          = Color(0xFFF2F0EB);
  static const dark        = Color(0xFF0F3D22);
  static const mid         = Color(0xFF1A5C34);
  static const light       = Color(0xFF267A46);
  static const gold        = Color(0xFFCB8C00);
  static const goldLight   = Color(0xFFE8A800);
  static const card        = Color(0xFFFFFFFF);
  static const border      = Color(0xFFDDD8CF);
  static const textDark    = Color(0xFF111827);
  static const textLight   = Color(0xFF9CA3AF);

  static const paddyGreen  = Color(0xFF1A5C34);
  static const cornAmber   = Color(0xFFAD6800);
  static const waterBlue   = Color(0xFF0277BD);
  static const alertRed    = Color(0xFFB91C1C);
}

// ════════════════════════════════════════════════════════════════════════════
// MAIN HOME SCREEN
// ════════════════════════════════════════════════════════════════════════════

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});
  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroCtrl, _contentCtrl;
  late Animation<double>   _heroFade, _contentFade;
  late Animation<Offset>   _contentSlide;

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String get _greetingEmoji {
    final h = DateTime.now().hour;
    if (h < 12) return '🌅';
    if (h < 17) return '☀️';
    return '🌙';
  }

  @override
  void initState() {
    super.initState();
    _heroCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _contentCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _heroFade    = CurvedAnimation(parent: _heroCtrl,    curve: Curves.easeOut);
    _contentFade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut);
    _contentSlide = Tween<Offset>(
            begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOutCubic));

    _heroCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _contentCtrl.forward();
    });
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg),
    backgroundColor: _C.mid,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    duration: const Duration(seconds: 2),
  ));

  @override
  Widget build(BuildContext context) {
    final user   = Session.user;
    final region = user?.region ?? 'Central';
    final initials = (user?.name.isNotEmpty == true)
        ? user!.name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : 'FK';

    return Scaffold(
      backgroundColor: _C.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          // ══════════════════════════════════════════════════════════════════
          // HERO SLIVER APP BAR — full-bleed farm photo + overlaid content
          // ══════════════════════════════════════════════════════════════════
          SliverAppBar(
            expandedHeight: 310,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: _C.dark,
            automaticallyImplyLeading: false,
            // Collapsed title bar
            title: Row(children: [
              Container(width: 32, height: 32,
                decoration: BoxDecoration(color: _C.gold, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.eco_rounded, color: Colors.white, size: 18)),
              const SizedBox(width: 10),
              const Text('Grow Mate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17, letterSpacing: -0.3)),
            ]),
            actions: [
              // Notification
              Stack(children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                  onPressed: () => _snack('No new notifications'),
                ),
                Positioned(top: 10, right: 10,
                  child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: _C.gold, shape: BoxShape.circle))),
              ]),
              // Avatar
              GestureDetector(
                onTap: () => _snack('Profile tapped'),
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: _C.gold, shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                  ),
                  child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13))),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: FadeTransition(
                opacity: _heroFade,
                child: Stack(fit: StackFit.expand, children: [

                  // ── Background farm photo ──────────────────────────────
                  Image.network(
                    'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=800&q=85',
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, p) {
                      if (p == null) return child;
                      return Container(
                        decoration: const BoxDecoration(gradient: LinearGradient(
                          colors: [_C.dark, _C.mid, _C.light],
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                        )),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(gradient: LinearGradient(
                        colors: [_C.dark, _C.mid, _C.light],
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                      )),
                    ),
                  ),

                  // ── Gradient overlay — dark top for readability, fade to transparent ──
                  Container(decoration: const BoxDecoration(gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Color(0xCC0F3D22), Color(0x880F3D22), Color(0xDD0F3D22)],
                    stops: [0.0, 0.45, 1.0],
                  ))),

                  // ── Content overlay ────────────────────────────────────
                  SafeArea(child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Top row — location + date
                      Row(children: [
                        _heroPill(Icons.location_on_rounded, '$region Region'),
                        const Spacer(),
                        _heroPill(Icons.calendar_today_outlined, _todayLabel()),
                      ]),
                      const Spacer(),
                      // Greeting
                      Text('$_greeting $_greetingEmoji',
                          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 14, letterSpacing: 0.2)),
                      const SizedBox(height: 4),
                      Text(user?.name ?? 'Farmer',
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.0, height: 1.1)),
                      const SizedBox(height: 16),
                      // Weather strip
                      Row(children: [
                        _weatherChip(Icons.wb_sunny_rounded,    '28°C',     'Partly Cloudy'),
                        const SizedBox(width: 8),
                        _weatherChip(Icons.water_drop_rounded,  '72%',      'Humidity'),
                        const SizedBox(width: 8),
                        _weatherChip(Icons.air_rounded,         '12 km/h',  'Wind'),
                      ]),
                    ]),
                  )),
                ]),
              ),
            ),
          ),

          // ══════════════════════════════════════════════════════════════════
          // BODY  — all sections
          // ══════════════════════════════════════════════════════════════════
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _contentFade,
              child: SlideTransition(
                position: _contentSlide,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const SizedBox(height: 20),

                    // ── Summary stats ──────────────────────────────────────
                    _summaryStrip(),
                    const SizedBox(height: 28),

                    // ── My Crops ───────────────────────────────────────────
                    _sectionHeader('My Crops', 'See All', () {}),
                    const SizedBox(height: 14),
                    _cropCardsRow(),
                    const SizedBox(height: 28),

                    // ── Quick Actions ──────────────────────────────────────
                    _sectionHeader('Quick Actions', '', () {}),
                    const SizedBox(height: 14),
                    _quickActionsGrid(),
                    const SizedBox(height: 28),

                    // ── Market Spotlight ───────────────────────────────────
                    _sectionHeader("Market Spotlight", 'View More', () {}),
                    const SizedBox(height: 14),
                    _marketSpotlight(),
                    const SizedBox(height: 28),

                    // ── Today's Prices ─────────────────────────────────────
                    _sectionHeader("Today's Prices", 'Full List', () {}),
                    const SizedBox(height: 14),
                    _priceCard('Paddy (MR1)',       'LKR 95/kg',       '+2.4%', true,  Icons.grass_rounded,   _C.paddyGreen,
                      'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=120&q=70'),
                    const SizedBox(height: 10),
                    _priceCard('Corn',               'LKR 82/kg',       '-1.2%', false, Icons.eco_rounded,     _C.cornAmber,
                      'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=120&q=70'),
                    const SizedBox(height: 10),
                    _priceCard('NPK Fertilizer',     'LKR 3,800/bag',   '+0.8%', true,  Icons.science_rounded, _C.waterBlue,
                      'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=120&q=70'),
                    const SizedBox(height: 28),

                    // ── Alerts & Tips ──────────────────────────────────────
                    _sectionHeader('Alerts & Tips', '', () {}),
                    const SizedBox(height: 14),
                    _alertCard('💧 Irrigation Alert',
                      'Paddy fields need watering in the next 2 days based on weather forecast.',
                      const Color(0xFFE3F2FD), _C.waterBlue, Icons.water_drop_rounded),
                    const SizedBox(height: 10),
                    _alertCard('🐛 Pest Warning',
                      'Brown planthopper detected in nearby farms. Apply pesticide early.',
                      const Color(0xFFFFF3E0), _C.alertRed, Icons.bug_report_rounded),
                    const SizedBox(height: 10),
                    _alertCard('🌦️ Weather Update',
                      'Rain expected on Tuesday. Good time to delay fertilizer application.',
                      const Color(0xFFE8F5E9), _C.mid, Icons.cloud_rounded),
                    const SizedBox(height: 36),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hero pill ──────────────────────────────────────────────────────────────
  Widget _heroPill(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.35),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: Colors.white70, size: 12),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w600)),
    ]),
  );

  // ── Weather chip ──────────────────────────────────────────────────────────
  Widget _weatherChip(IconData icon, String value, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: Colors.white, size: 14),
      const SizedBox(width: 5),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800, height: 1.1)),
        Text(label,  style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 9, fontWeight: FontWeight.w500)),
      ]),
    ]),
  );

  // ══════════════════════════════════════════════════════════════════════════
  // SUMMARY STRIP
  // ══════════════════════════════════════════════════════════════════════════

  Widget _summaryStrip() {
    final items = [
      {'val': '2', 'label': 'Active\nCrops',    'icon': Icons.grass_rounded,       'color': _C.paddyGreen},
      {'val': '3', 'label': 'Today\'s\nTasks',  'icon': Icons.alarm_rounded,       'color': _C.gold},
      {'val': '5', 'label': 'Market\nListings', 'icon': Icons.store_rounded,       'color': Color(0xFF6A1B9A)},
      {'val': '2', 'label': 'Machines\nNearby', 'icon': Icons.agriculture_rounded, 'color': Color(0xFFBF360C)},
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length * 2 - 1, (i) {
          if (i.isOdd) return Container(width: 1, height: 44, color: const Color(0xFFEEEBE4));
          final item = items[i ~/ 2];
          final color = item['color'] as Color;
          return Column(children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(item['icon'] as IconData, color: color, size: 22)),
            const SizedBox(height: 7),
            Text(item['val'] as String, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: color, height: 1)),
            const SizedBox(height: 3),
            Text(item['label'] as String, style: const TextStyle(fontSize: 10, color: _C.textLight, height: 1.3), textAlign: TextAlign.center),
          ]);
        }),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CROP CARDS — full-bleed photo backgrounds
  // ══════════════════════════════════════════════════════════════════════════

  Widget _cropCardsRow() {
    return Row(children: [
      Expanded(child: _cropCard(
        name: 'Paddy',
        area: '2.5 Acres',
        status: 'Growing',
        progress: 0.65,
        color: _C.paddyGreen,
        imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80',
      )),
      const SizedBox(width: 14),
      Expanded(child: _cropCard(
        name: 'Corn',
        area: '1.8 Acres',
        status: 'Harvesting',
        progress: 0.90,
        color: _C.cornAmber,
        imageUrl: 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=400&q=80',
      )),
    ]);
  }

  Widget _cropCard({
    required String name, required String area, required String status,
    required double progress, required Color color, required String imageUrl,
  }) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: color.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(fit: StackFit.expand, children: [
          // Photo
          Image.network(imageUrl, fit: BoxFit.cover,
            loadingBuilder: (_, child, p) {
              if (p == null) return child;
              return Container(color: color.withOpacity(0.12));
            },
            errorBuilder: (_, __, ___) => Container(
              decoration: BoxDecoration(gradient: LinearGradient(
                colors: [color.withOpacity(0.6), color],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              )),
            ),
          ),
          // Gradient overlay
          Container(decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.78)],
            stops: const [0.35, 1.0],
          ))),
          // Content
          Padding(padding: const EdgeInsets.all(16), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status badge top-right
              Align(alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: color.withOpacity(0.9), borderRadius: BorderRadius.circular(10)),
                  child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
                ),
              ),
              const Spacer(),
              // Name + area
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.3)),
              Text(area,  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
              const SizedBox(height: 10),
              // Progress bar
              Stack(children: [
                Container(height: 5, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(3))),
                FractionallySizedBox(widthFactor: progress,
                  child: Container(height: 5, decoration: BoxDecoration(
                    color: color == _C.cornAmber ? _C.goldLight : Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 4)],
                  ))),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                Text('${(progress * 100).toInt()}% complete', style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 10)),
                const Spacer(),
                Text('Growth stage', style: TextStyle(color: color == _C.cornAmber ? _C.goldLight : Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
              ]),
            ],
          )),
        ]),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // QUICK ACTIONS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _quickActionsGrid() {
    final actions = [
      {'icon': Icons.smart_toy_rounded,    'label': 'AI Chat',    'color': const Color(0xFF1565C0)},
      {'icon': Icons.store_rounded,        'label': 'Market',     'color': const Color(0xFF6A1B9A)},
      {'icon': Icons.agriculture_rounded,  'label': 'Machine',    'color': const Color(0xFFBF360C)},
      {'icon': Icons.cloud_rounded,        'label': 'Weather',    'color': const Color(0xFF00838F)},
      {'icon': Icons.science_rounded,      'label': 'Soil Test',  'color': _C.mid},
      {'icon': Icons.water_drop_rounded,   'label': 'Irrigation', 'color': _C.waterBlue},
      {'icon': Icons.bug_report_rounded,   'label': 'Pest Alert', 'color': _C.alertRed},
      {'icon': Icons.bar_chart_rounded,    'label': 'Reports',    'color': const Color(0xFF4527A0)},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 12,
      childAspectRatio: 0.82,
      children: actions.map((a) {
        final color = a['color'] as Color;
        return GestureDetector(
          onTap: () => _snack('${a['label']} coming soon'),
          child: Column(children: [
            Container(
              width: 58, height: 58,
              decoration: BoxDecoration(
                color: _C.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: color.withOpacity(0.15), width: 1.5),
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
                  BoxShadow(color: Colors.white, blurRadius: 0, offset: const Offset(0, 0), spreadRadius: 1),
                ],
              ),
              child: Icon(a['icon'] as IconData, color: color, size: 26),
            ),
            const SizedBox(height: 6),
            Text(a['label'] as String,
              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: _C.textDark, height: 1.2),
              textAlign: TextAlign.center, maxLines: 2),
          ]),
        );
      }).toList(),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // MARKET SPOTLIGHT  — horizontal photo cards
  // ══════════════════════════════════════════════════════════════════════════

  Widget _marketSpotlight() {
    final items = [
      {
        'title': 'Premium Basmati',
        'sub': 'Rs. 4,200 / bag',
        'tag': 'Hot Deal',
        'image': 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&q=80',
        'color': _C.paddyGreen,
      },
      {
        'title': 'Hybrid Corn Seeds',
        'sub': 'Rs. 850 / kg',
        'tag': 'New',
        'image': 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=300&q=80',
        'color': _C.cornAmber,
      },
      {
        'title': 'NPK 20-20-20',
        'sub': 'Rs. 3,800 / bag',
        'tag': 'Top Seller',
        'image': 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=300&q=80',
        'color': _C.waterBlue,
      },
    ];

    return SizedBox(height: 168,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item  = items[i];
          final color = item['color'] as Color;
          return GestureDetector(
            onTap: () => _snack('Opening ${item['title']}...'),
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 5))],
              ),
              child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Stack(fit: StackFit.expand, children: [
                Image.network(item['image'] as String, fit: BoxFit.cover,
                  loadingBuilder: (_, child, p) => p == null ? child : Container(color: color.withOpacity(0.1)),
                  errorBuilder: (_, __, ___) => Container(color: color.withOpacity(0.15)),
                ),
                Container(decoration: BoxDecoration(gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.80)],
                  stops: const [0.3, 1.0],
                ))),
                Padding(padding: const EdgeInsets.all(14), child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: _C.gold, borderRadius: BorderRadius.circular(8)),
                      child: Text(item['tag'] as String, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.3)),
                    ),
                    const Spacer(),
                    Text(item['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800, height: 1.2)),
                    const SizedBox(height: 3),
                    Text(item['sub'] as String,   style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11)),
                  ],
                )),
              ])),
            ),
          );
        },
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // PRICE CARD — with small thumbnail
  // ══════════════════════════════════════════════════════════════════════════

  Widget _priceCard(String crop, String price, String change, bool up,
      IconData icon, Color color, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _C.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(children: [
        // Thumbnail
        ClipRRect(borderRadius: BorderRadius.circular(12),
          child: Image.network(imageUrl, width: 52, height: 52, fit: BoxFit.cover,
            loadingBuilder: (_, child, p) => p == null ? child : Container(width: 52, height: 52, color: color.withOpacity(0.1), child: Icon(icon, color: color, size: 22)),
            errorBuilder: (_, __, ___) => Container(width: 52, height: 52, color: color.withOpacity(0.1), child: Icon(icon, color: color, size: 22)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(crop, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _C.textDark)),
          const SizedBox(height: 2),
          Text('Colombo Wholesale Market', style: TextStyle(color: _C.textLight, fontSize: 11)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(price, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: color)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: up ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(up ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  color: up ? const Color(0xFF059669) : _C.alertRed, size: 12),
              const SizedBox(width: 3),
              Text(change, style: TextStyle(color: up ? const Color(0xFF059669) : _C.alertRed, fontSize: 10, fontWeight: FontWeight.w800)),
            ]),
          ),
        ]),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ALERT CARD
  // ══════════════════════════════════════════════════════════════════════════

  Widget _alertCard(String title, String body, Color bgColor, Color accent, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(0.15)),
        boxShadow: [BoxShadow(color: accent.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: accent.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: accent, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w800, color: accent, fontSize: 13, letterSpacing: -0.1)),
          const SizedBox(height: 5),
          Text(body,  style: TextStyle(color: accent.withOpacity(0.72), fontSize: 12.5, height: 1.45)),
        ])),
        const SizedBox(width: 8),
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(color: accent.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(Icons.arrow_forward_ios_rounded, color: accent, size: 12),
        ),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SHARED HELPERS
  // ══════════════════════════════════════════════════════════════════════════

  Widget _sectionHeader(String title, String action, VoidCallback onAction) {
    return Row(children: [
      Container(width: 4, height: 22, decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_C.mid, _C.light], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        borderRadius: BorderRadius.circular(2),
      )),
      const SizedBox(width: 10),
      Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: _C.textDark, letterSpacing: -0.3)),
      const Spacer(),
      if (action.isNotEmpty)
        GestureDetector(
          onTap: onAction,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(12)),
            child: Text(action, style: const TextStyle(color: _C.mid, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
        ),
    ]);
  }

  String _todayLabel() {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final now = DateTime.now();
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}