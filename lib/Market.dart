import 'package:agri_app/localization.dart';
import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
// THEME
// ════════════════════════════════════════════════════════════════════════════

class AppColors {
  static const primary = Color(0xFF1A5C34);
  static const primaryDark = Color(0xFF0F3D22);
  static const primaryLight = Color(0xFF267A46);
  static const primarySurface = Color(0xFFE8F5ED);

  static const gold = Color(0xFFCB8C00);
  static const goldLight = Color(0xFFE8A800);

  static const success = Color(0xFF2D7D46);
  static const warning = Color(0xFFB85C00);
  static const error = Color(0xFFB91C1C);
  static const info = Color(0xFF1D5FA8);

  static const surface = Color(0xFFF5F3EE);
  static const card = Color(0xFFFFFFFF);
  static const border = Color(0xFFDDD8CF);

  static const textDark = Color(0xFF1A1A1A);
  static const textMid = Color(0xFF4B5563);
  static const textLight = Color(0xFF9CA3AF);
  static const textHint = Color(0xFFB8B0A5);
  static const divider = Color(0xFFEAE5DC);

  static const paddyGreen = Color(0xFF1A5C34);
  static const cornAmber = Color(0xFFAD6800);
  static const fertBlue = Color(0xFF1D5FA8);
  static const chemRed = Color(0xFFB91C1C);
}

// ════════════════════════════════════════════════════════════════════════════
// PRODUCT IMAGE WIDGET
// ════════════════════════════════════════════════════════════════════════════

class ProductImage extends StatelessWidget {
  final String category;
  final double size;
  final BorderRadius? borderRadius;

  const ProductImage({
    super.key,
    required this.category,
    this.size = 64,
    this.borderRadius,
  });

  String get _imageUrl {
    switch (category.toLowerCase()) {
      case 'paddy':
        return 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=200&q=80';
      case 'corn':
        return 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=200&q=80';
      case 'fertilizer':
        return 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=200&q=80';
      case 'chemical':
        return 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=200&q=80';
      default:
        return 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=200&q=80';
    }
  }

  Color get _fc {
    switch (category.toLowerCase()) {
      case 'paddy':
        return AppColors.paddyGreen;
      case 'corn':
        return AppColors.cornAmber;
      case 'fertilizer':
        return AppColors.fertBlue;
      case 'chemical':
        return AppColors.chemRed;
      default:
        return AppColors.primary;
    }
  }

  IconData get _fi {
    switch (category.toLowerCase()) {
      case 'paddy':
        return Icons.grass_rounded;
      case 'corn':
        return Icons.energy_savings_leaf_rounded;
      case 'fertilizer':
        return Icons.science_rounded;
      case 'chemical':
        return Icons.biotech_rounded;
      default:
        return Icons.eco_rounded;
    }
  }

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: Image.network(
          _imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, p) {
            if (p == null) return child;
            return Container(
              width: size,
              height: size,
              color: _fc.withOpacity(0.1),
              child: Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2,
                color: _fc,
                value: p.expectedTotalBytes != null
                    ? p.cumulativeBytesLoaded / p.expectedTotalBytes!
                    : null,
              )),
            );
          },
          errorBuilder: (_, __, ___) => Container(
            width: size,
            height: size,
            color: _fc.withOpacity(0.12),
            child: Icon(_fi, color: _fc, size: size * 0.45),
          ),
        ),
      );
}

// ════════════════════════════════════════════════════════════════════════════
// PRODUCT STORE
// ════════════════════════════════════════════════════════════════════════════

class ProductStore {
  ProductStore._();
  static final ProductStore instance = ProductStore._();

  int _nextId = 100;
  final ValueNotifier<List<Map<String, dynamic>>> products =
      ValueNotifier(_defaultProducts());

  void addProduct(Map<String, dynamic> product) {
    final p = Map<String, dynamic>.from(product)
      ..['id'] = _nextId++
      ..['isOwn'] = true;
    products.value = [p, ...products.value];
  }

  void updateProduct(int id, Map<String, dynamic> updated) {
    products.value = products.value
        .map((p) =>
            p['id'] == id ? (Map<String, dynamic>.from(p)..addAll(updated)) : p)
        .toList();
  }

  void deleteProduct(int id) {
    products.value = products.value.where((p) => p['id'] != id).toList();
  }

  static List<Map<String, dynamic>> _defaultProducts() => [
        {
          'id': 1,
          'name': 'Premium Basmati Paddy',
          'price': 4200,
          'unit': '/bag',
          'weight': '50 kg',
          'cat': 'Paddy',
          'seller': 'Green Valley Farm',
          'loc': 'Polonnaruwa',
          'rating': 4.8,
          'reviews': 124,
          'icon': Icons.grass_rounded,
          'color': AppColors.paddyGreen,
          'stock': 'In Stock',
          'badge': 'Hot Deal',
          'desc':
              'Premium quality Basmati paddy harvested in November 2024. Ideal for milling and export-grade rice production.',
          'isOwn': false
        },
        {
          'id': 2,
          'name': 'Hybrid Corn Seeds',
          'price': 850,
          'unit': '/kg',
          'weight': 'Min 10 kg',
          'cat': 'Corn',
          'seller': 'AgriSeeds Co.',
          'loc': 'Anuradhapura',
          'rating': 4.6,
          'reviews': 56,
          'icon': Icons.eco_rounded,
          'color': AppColors.cornAmber,
          'stock': 'In Stock',
          'badge': 'New',
          'desc': 'High-yield hybrid corn seeds suitable for all seasons.',
          'isOwn': false
        },
        {
          'id': 3,
          'name': 'NPK 20-20-20 Fertilizer',
          'price': 3800,
          'unit': '/bag',
          'weight': '25 kg',
          'cat': 'Fertilizer',
          'seller': 'FertWorld',
          'loc': 'Colombo',
          'rating': 4.9,
          'reviews': 210,
          'icon': Icons.science_rounded,
          'color': AppColors.fertBlue,
          'stock': 'In Stock',
          'badge': 'Top Seller',
          'desc': 'Balanced NPK fertilizer for all types of crops.',
          'isOwn': false
        },
        {
          'id': 4,
          'name': 'Samba Paddy Grade A',
          'price': 3800,
          'unit': '/bag',
          'weight': '50 kg',
          'cat': 'Paddy',
          'seller': 'Lakeside Farms',
          'loc': 'Kurunegala',
          'rating': 4.5,
          'reviews': 89,
          'icon': Icons.grass_rounded,
          'color': AppColors.paddyGreen,
          'stock': 'In Stock',
          'badge': 'Popular',
          'desc': 'Grade A Samba paddy from certified farms.',
          'isOwn': false
        },
        {
          'id': 5,
          'name': 'Yellow Corn Grain',
          'price': 650,
          'unit': '/kg',
          'weight': 'Min 20 kg',
          'cat': 'Corn',
          'seller': 'AgroCorn Ltd',
          'loc': 'Anuradhapura',
          'rating': 4.7,
          'reviews': 56,
          'icon': Icons.eco_rounded,
          'color': AppColors.cornAmber,
          'stock': 'Limited',
          'badge': 'Limited',
          'desc': 'Quality yellow corn grain for animal feed and processing.',
          'isOwn': false
        },
        {
          'id': 6,
          'name': 'Pesticide Spray Pro',
          'price': 1800,
          'unit': '/L',
          'weight': '5 L pack',
          'cat': 'Chemical',
          'seller': 'ChemAgri',
          'loc': 'Gampaha',
          'rating': 4.2,
          'reviews': 45,
          'icon': Icons.biotech_rounded,
          'color': AppColors.chemRed,
          'stock': 'In Stock',
          'badge': 'Trusted',
          'desc': 'Professional-grade pesticide for pest control.',
          'isOwn': false
        },
      ];
}

// ════════════════════════════════════════════════════════════════════════════
// APP ROOT
// ════════════════════════════════════════════════════════════════════════════

class AgriMarketApp extends StatelessWidget {
  const AgriMarketApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Grow Mate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: AppColors.surface,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      );
}

// ════════════════════════════════════════════════════════════════════════════
// SPLASH / ONBOARDING
// ════════════════════════════════════════════════════════════════════════════

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim, _slideAnim;
  int _page = 0;

  final List<Map<String, dynamic>> _onboarding = [
    {
      'icon': Icons.grass_rounded,
      'title': 'Buy & Sell\nFarm Produce',
      'subtitle':
          'Connect directly with farmers\nand buyers across the country',
      'color': AppColors.primary
    },
    {
      'icon': Icons.science_rounded,
      'title': 'Fertilizers &\nChemicals',
      'subtitle': 'Find the best agricultural\ninputs at competitive prices',
      'color': AppColors.primaryDark
    },
    {
      'icon': Icons.handshake_rounded,
      'title': 'Trusted\nMarketplace',
      'subtitle': 'Verified sellers, secure payments\nand reliable delivery',
      'color': Color(0xFF0A3D1F)
    },
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slideAnim = Tween<double>(begin: 40, end: 0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _onboarding.length - 1) {
      setState(() => _page++);
      _ctrl.reset();
      _ctrl.forward();
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = _onboarding[_page];
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [item['color'] as Color, AppColors.primaryDark],
        )),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen())),
                child: const Text('Skip',
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
              ),
            ),
            const Spacer(),
            AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) => Opacity(
                      opacity: _fadeAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnim.value),
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2)),
                          child: Icon(item['icon'] as IconData,
                              size: 80, color: Colors.white),
                        ),
                      ),
                    )),
            const SizedBox(height: 48),
            AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) => Opacity(
                      opacity: _fadeAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnim.value),
                        child: Column(children: [
                          Text(item['title'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                  letterSpacing: -0.5)),
                          const SizedBox(height: 16),
                          Text(item['subtitle'] as String,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                  height: 1.5)),
                        ]),
                      ),
                    )),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  _onboarding.length,
                  (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _page ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: i == _page
                                ? AppColors.goldLight
                                : Colors.white38,
                            borderRadius: BorderRadius.circular(4)),
                      )),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _next,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0),
                child: Text(
                    _page == _onboarding.length - 1 ? 'Get Started' : 'Next',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 16),
          ]),
        )),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// HOME SCREEN (shell with sidebar)
// ════════════════════════════════════════════════════════════════════════════

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  bool _drawerOpen = false;

  // nav index → screen mapping
  // 0=Home 1=Market 2=Sell 3=Orders 4=Listings
  static const _navItems = [
    {
      'idx': 0,
      'icon': Icons.home_rounded,
      'label': 'Home',
      'sub': 'Dashboard & Featured'
    },
    {
      'idx': 1,
      'icon': Icons.store_rounded,
      'label': 'Market',
      'sub': 'Browse all products'
    },
    {
      'idx': 3,
      'icon': Icons.receipt_long_rounded,
      'label': 'Orders',
      'sub': 'Track your orders'
    },
    {
      'idx': 4,
      'icon': Icons.inventory_2_outlined,
      'label': 'My Listings',
      'sub': 'Edit, update, delete'
    },
  ];

  void _selectNav(int idx) => setState(() {
        _navIndex = idx;
        _drawerOpen = false;
      });

  Widget _getScreen() {
    switch (_navIndex) {
      case 1:
        return const ProductListingScreen();
      case 2:
        return const SellScreen();
      case 3:
        return const OrderHistoryScreen();
      case 4:
        return const MyListingsScreen();

      default:
        return _HomeContent(onNavigate: _selectNav);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
          child: Stack(children: [
        // ── Main layout ──────────────────────────────────────────────────────
        Row(children: [
          // Collapsed sidebar rail
          Container(
            width: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(4, 0))
              ],
            ),
            child: Column(children: [
              const SizedBox(height: 12),
              // Logo
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.eco_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(height: 12),
              // Hamburger
              GestureDetector(
                onTap: () => setState(() => _drawerOpen = !_drawerOpen),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _drawerOpen
                        ? Colors.white.withOpacity(0.15)
                        : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _drawerOpen
                        ? const Icon(Icons.close_rounded,
                            key: ValueKey('c'), color: Colors.white, size: 20)
                        : const Icon(Icons.menu_rounded,
                            key: ValueKey('m'),
                            color: Colors.white70,
                            size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Quick-nav dots
              ..._navItems.map((item) {
                final active = _navIndex == item['idx'];
                return GestureDetector(
                  onTap: () => _selectNav(item['idx'] as int),
                  child: Tooltip(
                    message: item['label'] as String,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 8),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.gold.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: active
                            ? Border.all(color: AppColors.gold.withOpacity(0.5))
                            : null,
                      ),
                      child: Icon(item['icon'] as IconData,
                          color: active ? AppColors.gold : Colors.white38,
                          size: 20),
                    ),
                  ),
                );
              }),
              const Spacer(),
              // Post product FAB
              GestureDetector(
                onTap: () => _selectNav(2),
                child: Container(
                  width: 42,
                  height: 42,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.gold, AppColors.goldLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.gold.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: const Icon(Icons.add_rounded,
                      color: Colors.white, size: 22),
                ),
              ),
            ]),
          ),
          // Main content area
          Expanded(child: _getScreen()),
        ]),

        // ── Drawer overlay ───────────────────────────────────────────────────
        if (_drawerOpen) ...[
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _drawerOpen = false),
              child: Container(color: Colors.black.withOpacity(0.35)),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 64,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: -1.0, end: 0.0),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              builder: (_, val, child) => Transform.translate(
                  offset: Offset(val * 260, 0), child: child),
              child: _DrawerPanel(
                navItems: List<Map<String, dynamic>>.from(_navItems),
                navIndex: _navIndex,
                onSelect: _selectNav,
              ),
            ),
          ),
        ],
      ])),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// DRAWER PANEL
// ════════════════════════════════════════════════════════════════════════════

class _DrawerPanel extends StatelessWidget {
  final List<Map<String, dynamic>> navItems;
  final int navIndex;
  final void Function(int) onSelect;

  const _DrawerPanel(
      {required this.navItems, required this.navIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final user = Session.user;
    final initials = (user.name.isNotEmpty == true)
        ? user.name
            .trim()
            .split(' ')
            .map((w) => w[0])
            .take(2)
            .join()
            .toUpperCase()
        : 'SK';

    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(6, 0))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          color: Colors.black.withOpacity(0.2),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(14)),
              child:
                  const Icon(Icons.eco_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 14),
            const Text('Grow Mate',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5)),
            const SizedBox(height: 2),
            Text('Farm Buy & Sell Platform',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 12),

        // Nav items
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text('NAVIGATION',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5)),
            ),
            ...navItems.map((item) => _drawerItem(
                item['idx'] as int,
                item['icon'] as IconData,
                item['label'] as String,
                item['sub'] as String)),
          ]),
        ),

        const SizedBox(height: 12),
        Divider(
            color: Colors.white.withOpacity(0.08), indent: 20, endIndent: 20),
        const SizedBox(height: 12),

        // Post product action
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text('ACTIONS',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5)),
            ),
            GestureDetector(
              onTap: () => onSelect(2),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.gold, AppColors.goldLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.add_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Post Product',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14)),
                        Text('List your produce',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 11)),
                      ]),
                ]),
              ),
            ),
          ]),
        ),

        const Spacer(),
        // User footer — taps to open profile
        GestureDetector(
          onTap: () => onSelect(5),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: AppColors.gold, shape: BoxShape.circle),
                child: Center(
                    child: Text(initials,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12))),
              ),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(user.name ?? 'Farmer',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13)),
                    Text('View Profile',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 11)),
                  ])),
              const Icon(Icons.circle, color: AppColors.success, size: 10),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _drawerItem(int idx, IconData icon, String label, String sub) {
    final active = navIndex == idx;
    return GestureDetector(
      onTap: () => onSelect(idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: active ? Colors.white.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border:
              active ? Border.all(color: Colors.white.withOpacity(0.15)) : null,
        ),
        child: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: active
                    ? AppColors.gold.withOpacity(0.2)
                    : Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon,
                color: active ? AppColors.gold : Colors.white60, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(label,
                    style: TextStyle(
                        color: active ? Colors.white : Colors.white70,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 14)),
                Text(sub,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.35), fontSize: 11)),
              ])),
          if (active)
            Container(
                width: 4,
                height: 28,
                decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(2))),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// HOME CONTENT
// ════════════════════════════════════════════════════════════════════════════

class _HomeContent extends StatefulWidget {
  final void Function(int)? onNavigate;
  const _HomeContent({this.onNavigate});
  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    ProductStore.instance.products.addListener(_refresh);
    _searchCtrl.addListener(() => setState(() {
          _searchQuery = _searchCtrl.text.toLowerCase();
          _isSearching = _searchQuery.isNotEmpty;
        }));
  }

  @override
  void dispose() {
    ProductStore.instance.products.removeListener(_refresh);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  List<Map<String, dynamic>> get _searchResults {
    if (_searchQuery.isEmpty) return [];
    return ProductStore.instance.products.value.where((p) {
      return (p['name'] as String).toLowerCase().contains(_searchQuery) ||
          (p['cat'] as String).toLowerCase().contains(_searchQuery) ||
          ((p['seller'] as String?)?.toLowerCase().contains(_searchQuery) ??
              false) ||
          ((p['loc'] as String?)?.toLowerCase().contains(_searchQuery) ??
              false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = Session.user;
    final allProducts = ProductStore.instance.products.value;
    final featured = allProducts.take(6).toList();

    // greeting
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    final categories = [
      {
        'name': 'Paddy',
        'color': AppColors.paddyGreen,
        'icon': Icons.grass_rounded,
        'count': allProducts.where((p) => p['cat'] == 'Paddy').length
      },
      {
        'name': 'Corn',
        'color': AppColors.cornAmber,
        'icon': Icons.energy_savings_leaf_rounded,
        'count': allProducts.where((p) => p['cat'] == 'Corn').length
      },
      {
        'name': 'Fertilizer',
        'color': AppColors.fertBlue,
        'icon': Icons.science_rounded,
        'count': allProducts.where((p) => p['cat'] == 'Fertilizer').length
      },
      {
        'name': 'Chemicals',
        'color': AppColors.chemRed,
        'icon': Icons.biotech_rounded,
        'count': allProducts.where((p) => p['cat'] == 'Chemical').length
      },
    ];

    final initials = (user.name.isNotEmpty == true)
        ? user.name
            .trim()
            .split(' ')
            .map((w) => w[0])
            .take(2)
            .join()
            .toUpperCase()
        : 'SK';

    return CustomScrollView(slivers: [
      // ── Header ──────────────────────────────────────────────────────────────
      SliverToBoxAdapter(
          child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        )),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('$greeting 👋',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.75), fontSize: 14)),
                  Text(user.name ?? 'Farmer',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                ])),
            // Notification bell
            Stack(children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle),
                child: const Icon(Icons.notifications_outlined,
                    color: Colors.white, size: 22),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: AppColors.gold, shape: BoxShape.circle)),
              ),
            ]),
            const SizedBox(width: 12),
            // Avatar → taps to Profile
            GestureDetector(
              onTap: () => widget.onNavigate?.call(5),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 2),
                ),
                child: Center(
                    child: Text(initials,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14))),
              ),
            ),
          ]),
          const SizedBox(height: 20),

          // Search bar
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Row(children: [
              const SizedBox(width: 16),
              const Icon(Icons.search_rounded,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Expanded(
                  child: TextField(
                controller: _searchCtrl,
                style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  hintText: 'Search paddy, corn, fertilizer...',
                  hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                ),
              )),
              if (_isSearching)
                GestureDetector(
                  onTap: () {
                    _searchCtrl.clear();
                    setState(() {
                      _searchQuery = '';
                      _isSearching = false;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: AppColors.textLight.withOpacity(0.2),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.close_rounded,
                        size: 16, color: AppColors.textMid),
                  ),
                ),
            ]),
          ),
        ]),
      )),

      // ── Search Results ───────────────────────────────────────────────────────
      if (_isSearching)
        SliverToBoxAdapter(
            child: _SearchResultsPanel(
                results: _searchResults, query: _searchQuery)),

      // ── Home body (hidden while searching) ──────────────────────────────────
      if (!_isSearching) ...[
        // Stats strip
        SliverToBoxAdapter(
            child: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
            ],
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _stat('${allProducts.length}', 'Active Listings'),
            _divV(),
            _stat('380+', 'Sellers'),
            _divV(),
            _stat('25', 'Districts'),
          ]),
        )),

        // Categories heading
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Row(children: [
            const Text('Categories',
                style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const Spacer(),
            TextButton(
                onPressed: () => widget.onNavigate?.call(1),
                child: const Text('See All',
                    style: TextStyle(color: AppColors.primary))),
          ]),
        )),

        // Category chips
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
              children: categories.map((cat) {
            final color = cat['color'] as Color;
            return Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04), blurRadius: 8)
                  ],
                ),
                child: Column(children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          shape: BoxShape.circle),
                      child: Icon(cat['icon'] as IconData,
                          color: color, size: 22)),
                  const SizedBox(height: 6),
                  Text(cat['name'] as String,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  const SizedBox(height: 2),
                  Text('${cat['count']}',
                      style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.w600)),
                ]),
              ),
            ));
          }).toList()),
        )),

        // Featured heading
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Row(children: [
            const Text('Featured Products',
                style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const Spacer(),
            TextButton(
                onPressed: () => widget.onNavigate?.call(1),
                child: const Text('See All',
                    style: TextStyle(color: AppColors.primary))),
          ]),
        )),

        // Featured horizontal list
        SliverToBoxAdapter(
            child: SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: featured.length,
            itemBuilder: (ctx, i) {
              final p = featured[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                    ctx,
                    MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: p))),
                child: Container(
                  width: 180,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06), blurRadius: 12)
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20)),
                          child: SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: ProductImage(
                                category: p['cat'] as String,
                                size: 100,
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20))),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: AppColors.gold.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Text(
                                        (p['badge'] as String?) ?? 'New',
                                        style: const TextStyle(
                                            color: AppColors.gold,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(p['name'] as String,
                                      style: const TextStyle(
                                          color: AppColors.textDark,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 6),
                                  Text('Rs. ${p['price']}',
                                      style: const TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800)),
                                  Row(children: [
                                    const Icon(Icons.location_on_outlined,
                                        size: 11, color: AppColors.textLight),
                                    Expanded(
                                        child: Text(
                                            (p['loc'] as String?)
                                                    ?.split(',')[0] ??
                                                '',
                                            style: const TextStyle(
                                                color: AppColors.textLight,
                                                fontSize: 11),
                                            overflow: TextOverflow.ellipsis)),
                                  ]),
                                ])),
                      ]),
                ),
              );
            },
          ),
        )),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    ]);
  }

  Widget _stat(String val, String label) => Column(children: [
        Text(val,
            style: const TextStyle(
                color: AppColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
      ]);
  Widget _divV() => Container(width: 1, height: 40, color: AppColors.divider);
}

// ════════════════════════════════════════════════════════════════════════════
// SEARCH RESULTS PANEL
// ════════════════════════════════════════════════════════════════════════════

class _SearchResultsPanel extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final String query;
  const _SearchResultsPanel({required this.results, required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.surface,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              results.isEmpty
                  ? 'No results for "$query"'
                  : '${results.length} result${results.length != 1 ? 's' : ''} for "$query"',
              style: const TextStyle(
                  color: AppColors.textMid,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
          if (results.isEmpty)
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border)),
              child: const Column(children: [
                Icon(Icons.search_off_rounded,
                    size: 48, color: AppColors.textLight),
                SizedBox(height: 12),
                Text('No products found',
                    style: TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                SizedBox(height: 4),
                Text('Try different keywords',
                    style: TextStyle(color: AppColors.textLight, fontSize: 13)),
              ]),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: results.length,
              itemBuilder: (ctx, i) {
                final p = results[i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                      ctx,
                      MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: p))),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8)
                      ],
                    ),
                    child: Row(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ProductImage(
                              category: p['cat'] as String, size: 56)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(p['name'] as String,
                                style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 3),
                            Text(
                                '${p['seller'] ?? ''} · ${(p['loc'] as String?)?.split(',')[0] ?? ''}',
                                style: const TextStyle(
                                    color: AppColors.textLight, fontSize: 12)),
                          ])),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Rs. ${p['price']}',
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800)),
                            Text(p['unit'] as String,
                                style: const TextStyle(
                                    color: AppColors.textLight, fontSize: 11)),
                          ]),
                    ]),
                  ),
                );
              },
            ),
        ]));
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PRODUCT LISTING SCREEN
// ════════════════════════════════════════════════════════════════════════════

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});
  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  int _selectedCat = 0;
  String _sortBy = 'Newest';
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  final _cats = ['All', 'Paddy', 'Corn', 'Fertilizer', 'Chemical'];
  final _sorts = ['Newest', 'Price ↑', 'Price ↓', 'Rating'];

  @override
  void initState() {
    super.initState();
    ProductStore.instance.products.addListener(_refresh);
    _searchCtrl.addListener(
        () => setState(() => _searchQuery = _searchCtrl.text.toLowerCase()));
  }

  @override
  void dispose() {
    ProductStore.instance.products.removeListener(_refresh);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  List<Map<String, dynamic>> get _filtered {
    var list = ProductStore.instance.products.value;
    if (_selectedCat != 0) {
      list = list.where((p) => p['cat'] == _cats[_selectedCat]).toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((p) =>
              (p['name'] as String).toLowerCase().contains(_searchQuery) ||
              (p['cat'] as String).toLowerCase().contains(_searchQuery) ||
              ((p['seller'] as String?)?.toLowerCase().contains(_searchQuery) ??
                  false))
          .toList();
    }
    switch (_sortBy) {
      case 'Price ↑':
        list = [...list]
          ..sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
      case 'Price ↓':
        list = [...list]
          ..sort((a, b) => (b['price'] as int).compareTo(a['price'] as int));
      case 'Rating':
        list = [...list]..sort((a, b) =>
            ((b['rating'] ?? 0) as num).compareTo((a['rating'] ?? 0) as num));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Marketplace',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (v) => setState(() => _sortBy = v),
            itemBuilder: (_) => _sorts
                .map((s) => PopupMenuItem(value: s, child: Text(s)))
                .toList(),
          ),
        ],
      ),
      body: Column(children: [
        Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(children: [
            // Inline search
            Container(
              height: 44,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2))),
              child: Row(children: [
                const SizedBox(width: 12),
                Icon(Icons.search_rounded,
                    color: Colors.white.withOpacity(0.7), size: 18),
                const SizedBox(width: 8),
                Expanded(
                    child: TextField(
                  controller: _searchCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                      hintText: 'Search in marketplace...',
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5), fontSize: 13),
                      border: InputBorder.none,
                      isDense: true),
                )),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchCtrl.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.close_rounded,
                            color: Colors.white.withOpacity(0.7), size: 18)),
                  ),
              ]),
            ),
            // Category chips
            SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: _cats.length,
                  itemBuilder: (_, i) => GestureDetector(
                    onTap: () => setState(() => _selectedCat = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          color: _selectedCat == i
                              ? AppColors.gold
                              : Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      child: Text(_cats[i],
                          style: TextStyle(
                              color: _selectedCat == i
                                  ? Colors.white
                                  : Colors.white70,
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ),
                  ),
                )),
            const SizedBox(height: 8),
          ]),
        ),
        Container(
            height: 12,
            decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(children: [
            Text('${_filtered.length} results',
                style: const TextStyle(color: AppColors.textMid, fontSize: 13)),
            const Spacer(),
            Text('Sort: $_sortBy',
                style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ]),
        ),
        Expanded(
          child: _filtered.isEmpty
              ? const Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(Icons.search_off_rounded,
                          size: 52, color: AppColors.textLight),
                      SizedBox(height: 12),
                      Text('No products found',
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                      SizedBox(height: 4),
                      Text('Try a different search or category',
                          style: TextStyle(
                              color: AppColors.textLight, fontSize: 13)),
                    ]))
              : ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: _filtered.length,
                  itemBuilder: (ctx, i) {
                    final p = _filtered[i];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          ctx,
                          MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(product: p))),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8)
                          ],
                        ),
                        child: Row(children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: ProductImage(
                                  category: p['cat'] as String, size: 72)),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Row(children: [
                                  Expanded(
                                      child: Text(p['name'] as String,
                                          style: const TextStyle(
                                              color: AppColors.textDark,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700))),
                                  _stockBadge(p['stock']),
                                ]),
                                const SizedBox(height: 4),
                                Text((p['seller'] ?? 'You') as String,
                                    style: const TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 12)),
                                const SizedBox(height: 4),
                                Row(children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 12, color: AppColors.textLight),
                                  Expanded(
                                      child: Text((p['loc'] ?? '') as String,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: AppColors.textLight,
                                              fontSize: 12))),
                                  if (p['rating'] != null) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.star_rounded,
                                        size: 12, color: AppColors.gold),
                                    Text('${p['rating']}',
                                        style: const TextStyle(
                                            color: AppColors.textMid,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ]),
                                const SizedBox(height: 6),
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Rs. ${p['price']}',
                                          style: const TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800)),
                                      Text(p['unit'] as String,
                                          style: const TextStyle(
                                              color: AppColors.textLight,
                                              fontSize: 12)),
                                      const Spacer(),
                                      Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Icon(
                                              Icons.shopping_cart_outlined,
                                              color: Colors.white,
                                              size: 16)),
                                    ]),
                              ])),
                        ]),
                      ),
                    );
                  },
                ),
        ),
      ]),
    );
  }

  Widget _stockBadge(dynamic stock) {
    final s = (stock ?? 'In Stock') as String;
    final limited = s == 'Limited';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: (limited ? AppColors.warning : AppColors.success)
              .withOpacity(0.1),
          borderRadius: BorderRadius.circular(6)),
      child: Text(s,
          style: TextStyle(
              color: limited ? AppColors.warning : AppColors.success,
              fontSize: 10,
              fontWeight: FontWeight.w700)),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// SELL SCREEN
// ════════════════════════════════════════════════════════════════════════════

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});
  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  String _selectedCategory = 'Paddy';
  String _selectedUnit = 'per kg';
  String _selectedLocation = '';
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final _categories = ['Paddy', 'Corn', 'Fertilizer', 'Chemical'];
  final _units = ['per kg', 'per bag', 'per ton', 'per liter', 'per packet'];
  final _catInfo = <String, Map<String, dynamic>>{
    'Paddy': {'icon': Icons.grass_rounded, 'color': AppColors.paddyGreen},
    'Corn': {'icon': Icons.eco_rounded, 'color': AppColors.cornAmber},
    'Fertilizer': {'icon': Icons.science_rounded, 'color': AppColors.fertBlue},
    'Chemical': {'icon': Icons.biotech_rounded, 'color': AppColors.chemRed},
  };

  final List<Map<String, String>> _districts = [
    {'name': 'Colombo', 'province': 'Western Province'},
    {'name': 'Gampaha', 'province': 'Western Province'},
    {'name': 'Kalutara', 'province': 'Western Province'},
    {'name': 'Kandy', 'province': 'Central Province'},
    {'name': 'Matale', 'province': 'Central Province'},
    {'name': 'Nuwara Eliya', 'province': 'Central Province'},
    {'name': 'Galle', 'province': 'Southern Province'},
    {'name': 'Matara', 'province': 'Southern Province'},
    {'name': 'Hambantota', 'province': 'Southern Province'},
    {'name': 'Jaffna', 'province': 'Northern Province'},
    {'name': 'Batticaloa', 'province': 'Eastern Province'},
    {'name': 'Ampara', 'province': 'Eastern Province'},
    {'name': 'Trincomalee', 'province': 'Eastern Province'},
    {'name': 'Kurunegala', 'province': 'North Western Province'},
    {'name': 'Puttalam', 'province': 'North Western Province'},
    {'name': 'Anuradhapura', 'province': 'North Central Province'},
    {'name': 'Polonnaruwa', 'province': 'North Central Province'},
    {'name': 'Badulla', 'province': 'Uva Province'},
    {'name': 'Monaragala', 'province': 'Uva Province'},
    {'name': 'Ratnapura', 'province': 'Sabaragamuwa Province'},
    {'name': 'Kegalle', 'province': 'Sabaragamuwa Province'},
  ];

  void _showLocationPicker() {
    String s = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(builder: (ctx, sm) {
        final f = _districts
            .where((d) =>
                d['name']!.toLowerCase().contains(s.toLowerCase()) ||
                d['province']!.toLowerCase().contains(s.toLowerCase()))
            .toList();
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.75,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(children: [
            const SizedBox(height: 12),
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            const Text('Select District',
                style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border)),
                child: TextField(
                    autofocus: true,
                    onChanged: (v) => sm(() => s = v),
                    decoration: const InputDecoration(
                        hintText: 'Search district...',
                        prefixIcon: Icon(Icons.search_rounded,
                            color: AppColors.primary, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14))),
              ),
            ),
            const Divider(color: AppColors.divider),
            Expanded(
                child: ListView.builder(
                    itemCount: f.length,
                    itemBuilder: (_, i) {
                      final d = f[i];
                      final sel =
                          _selectedLocation == '${d['name']}, ${d['province']}';
                      return ListTile(
                        onTap: () {
                          setState(() => _selectedLocation =
                              '${d['name']}, ${d['province']}');
                          Navigator.pop(ctx);
                        },
                        leading: Icon(Icons.location_on_rounded,
                            color:
                                sel ? AppColors.primary : AppColors.textLight,
                            size: 20),
                        title: Text(d['name']!,
                            style: TextStyle(
                                fontWeight:
                                    sel ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 14)),
                        subtitle: Text(d['province']!,
                            style: const TextStyle(
                                color: AppColors.textLight, fontSize: 12)),
                        trailing: sel
                            ? const Icon(Icons.check_circle_rounded,
                                color: AppColors.primary, size: 20)
                            : null,
                      );
                    })),
          ]),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Post Product to Sell',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Photo upload area
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1.5)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            shape: BoxShape.circle),
                        child: const Icon(Icons.add_photo_alternate_outlined,
                            color: AppColors.primary, size: 28)),
                    const SizedBox(height: 8),
                    const Text('Add Product Photos',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                    const Text('Upload up to 5 photos',
                        style: TextStyle(
                            color: AppColors.textLight, fontSize: 12)),
                  ]),
            ),
            const SizedBox(height: 20),

            const _SectionLabel('Product Category *'),
            const SizedBox(height: 8),
            Row(
                children: _categories.map((cat) {
              final sel = _selectedCategory == cat;
              final color = _catInfo[cat]!['color'] as Color;
              return Expanded(
                  child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: sel ? color.withOpacity(0.1) : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: sel ? color : AppColors.border,
                          width: sel ? 2 : 1)),
                  child: Column(children: [
                    Icon(_catInfo[cat]!['icon'] as IconData,
                        color: sel ? color : AppColors.textLight, size: 22),
                    const SizedBox(height: 4),
                    Text(cat,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                sel ? FontWeight.w700 : FontWeight.normal,
                            color: sel ? color : AppColors.textLight),
                        textAlign: TextAlign.center),
                  ]),
                ),
              ));
            }).toList()),
            const SizedBox(height: 20),

            const _SectionLabel('Product Name *'), const SizedBox(height: 8),
            _inputField(_nameCtrl, 'e.g. Basmati Paddy Grade A',
                Icons.inventory_2_outlined),
            const SizedBox(height: 16),

            Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const _SectionLabel('Price (Rs.) *'),
                    const SizedBox(height: 8),
                    _inputField(_priceCtrl, '0.00', Icons.attach_money,
                        keyboardType: TextInputType.number),
                  ])),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const _SectionLabel('Unit *'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border)),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                        value: _selectedUnit,
                        isExpanded: true,
                        style: const TextStyle(
                            color: AppColors.textDark, fontSize: 14),
                        onChanged: (v) => setState(() => _selectedUnit = v!),
                        items: _units
                            .map((u) =>
                                DropdownMenuItem(value: u, child: Text(u)))
                            .toList(),
                      )),
                    ),
                  ])),
            ]),
            const SizedBox(height: 16),

            const _SectionLabel('Quantity Available'),
            const SizedBox(height: 8),
            _inputField(
                _qtyCtrl, 'e.g. 500 kg or 20 bags', Icons.scale_outlined,
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),

            const _SectionLabel('Description'), const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border)),
              child: TextField(
                controller: _descCtrl,
                maxLines: 4,
                style: const TextStyle(color: AppColors.textDark, fontSize: 14),
                decoration: const InputDecoration(
                    hintText: 'Describe quality, variety, harvest date...',
                    hintStyle: TextStyle(color: AppColors.textLight),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16)),
              ),
            ),
            const SizedBox(height: 16),

            const _SectionLabel('Location *'), const SizedBox(height: 8),
            GestureDetector(
              onTap: _showLocationPicker,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _selectedLocation.isEmpty
                      ? AppColors.card
                      : AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: _selectedLocation.isEmpty
                          ? AppColors.border
                          : AppColors.primary,
                      width: _selectedLocation.isEmpty ? 1 : 1.5),
                ),
                child: Row(children: [
                  Icon(Icons.location_on_rounded,
                      color: _selectedLocation.isEmpty
                          ? AppColors.textLight
                          : AppColors.primary,
                      size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _selectedLocation.isEmpty
                          ? const Text('Select your district',
                              style: TextStyle(
                                  color: AppColors.textLight, fontSize: 14))
                          : Text(_selectedLocation,
                              style: const TextStyle(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14))),
                  Icon(
                      _selectedLocation.isEmpty
                          ? Icons.chevron_right_rounded
                          : Icons.edit_location_alt_outlined,
                      color: _selectedLocation.isEmpty
                          ? AppColors.textLight
                          : AppColors.primary,
                      size: 20),
                ]),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_nameCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please enter a product name'),
                        backgroundColor: AppColors.warning));
                    return;
                  }
                  if (_priceCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please enter a price'),
                        backgroundColor: AppColors.warning));
                    return;
                  }
                  if (_selectedLocation.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please select your location'),
                        backgroundColor: AppColors.warning));
                    return;
                  }
                  ProductStore.instance.addProduct({
                    'name': _nameCtrl.text.trim(),
                    'price': int.tryParse(_priceCtrl.text
                            .replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0,
                    'unit': _selectedUnit,
                    'weight': _qtyCtrl.text.trim(),
                    'qty': _qtyCtrl.text.trim(),
                    'cat': _selectedCategory,
                    'seller': Session.user.name ?? 'You',
                    'loc': _selectedLocation,
                    'stock': 'In Stock',
                    'badge': 'New',
                    'desc': _descCtrl.text.trim().isNotEmpty
                        ? _descCtrl.text.trim()
                        : 'Posted by seller.',
                    'icon': _catInfo[_selectedCategory]!['icon'],
                    'color': _catInfo[_selectedCategory]!['color'],
                  });
                  _nameCtrl.clear();
                  _priceCtrl.clear();
                  _qtyCtrl.clear();
                  _descCtrl.clear();
                  setState(() => _selectedLocation = '');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('✅ Product posted! Visible on Home & Market.'),
                      backgroundColor: AppColors.success,
                      duration: Duration(seconds: 3)));
                },
                icon: const Icon(Icons.upload_rounded),
                label: const Text('Post Product',
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0),
              ),
            ),
            const SizedBox(height: 24),
          ])),
    );
  }

  Widget _inputField(TextEditingController ctrl, String hint, IconData icon,
          {TextInputType? keyboardType}) =>
      Container(
        decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border)),
        child: TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.textDark, fontSize: 14),
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.textLight),
              prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 14,
          fontWeight: FontWeight.w700));
}

// ════════════════════════════════════════════════════════════════════════════
// PRODUCT DETAIL SCREEN
// ════════════════════════════════════════════════════════════════════════════

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailScreen({super.key, required this.product});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  int _qty = 1;
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Color _catColor(String cat) {
    switch (cat) {
      case 'Paddy':
        return AppColors.paddyGreen;
      case 'Corn':
        return AppColors.cornAmber;
      case 'Fertilizer':
        return AppColors.fertBlue;
      case 'Chemical':
        return AppColors.chemRed;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final cat = (p['cat'] ?? 'Paddy') as String;
    final seller = (p['seller'] ?? 'You') as String;
    final loc = (p['loc'] ?? '') as String;
    final rating = p['rating'] as double?;
    final reviews = p['reviews'] as int?;
    final price = p['price'] as int;
    final unit = (p['unit'] ?? '') as String;
    final weight = (p['weight'] ?? '') as String;
    final desc = (p['desc'] ?? 'No description.') as String;
    final qty = (p['qty'] ?? '') as String;
    final isOwn = p['isOwn'] == true;
    final catColor = _catColor(cat);
    final initials =
        seller.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(children: [
        CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
                background: Stack(fit: StackFit.expand, children: [
              ProductImage(
                  category: cat, size: 300, borderRadius: BorderRadius.zero),
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                    Colors.transparent,
                    catColor.withOpacity(0.7),
                    AppColors.primaryDark.withOpacity(0.9)
                  ],
                          stops: const [
                    0.3,
                    0.7,
                    1.0
                  ]))),
              Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text('🌾 $cat',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13)),
                  )),
              if (isOwn)
                Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.3))),
                      child:
                          const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.person_rounded,
                            size: 12, color: Colors.white70),
                        SizedBox(width: 4),
                        Text('Your Listing',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.w600))
                      ]),
                    )),
            ])),
            actions: [
              if (!isOwn) ...[
                IconButton(
                    icon: Icon(
                        _isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: _isFav ? Colors.red : Colors.white),
                    onPressed: () => setState(() => _isFav = !_isFav)),
                IconButton(
                    icon: const Icon(Icons.share_outlined), onPressed: () {}),
              ],
              if (isOwn)
                PopupMenuButton<String>(
                  icon:
                      const Icon(Icons.more_vert_rounded, color: Colors.white),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  onSelected: (val) {
                    if (val == 'edit') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditProductScreen(product: p)));
                    }
                    if (val == 'delete') _confirmDelete(context, p);
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                        value: 'edit',
                        child: Row(children: [
                          Icon(Icons.edit_outlined,
                              color: AppColors.primary, size: 18),
                          SizedBox(width: 10),
                          Text('Edit Product')
                        ])),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                        value: 'delete',
                        child: Row(children: [
                          Icon(Icons.delete_outline_rounded,
                              color: Colors.red, size: 18),
                          SizedBox(width: 10),
                          Text('Delete', style: TextStyle(color: Colors.red))
                        ])),
                  ],
                ),
            ],
          ),
          SliverToBoxAdapter(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(p['name'] as String,
                                        style: const TextStyle(
                                            color: AppColors.textDark,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 4),
                                    Text(weight.isNotEmpty ? weight : cat,
                                        style: const TextStyle(
                                            color: AppColors.textLight,
                                            fontSize: 14)),
                                  ])),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Rs. $price',
                                        style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w800)),
                                    Text(unit,
                                        style: const TextStyle(
                                            color: AppColors.textLight,
                                            fontSize: 12)),
                                  ]),
                            ]),
                        const SizedBox(height: 16),
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          if (rating != null)
                            _badge(Icons.star_rounded,
                                '$rating ($reviews reviews)', AppColors.gold),
                          if (qty.isNotEmpty)
                            _badge(Icons.inventory_2_outlined, 'Qty: $qty',
                                AppColors.success),
                          _badge(
                              Icons.verified_outlined,
                              isOwn ? 'Your Listing' : 'Verified',
                              AppColors.primary),
                        ]),
                        const SizedBox(height: 20),
                        // Seller card
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.border)),
                          child: Row(children: [
                            Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                    color: AppColors.primarySurface,
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Text(initials,
                                        style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16)))),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(seller,
                                      style: const TextStyle(
                                          color: AppColors.textDark,
                                          fontWeight: FontWeight.w700)),
                                  Row(children: [
                                    const Icon(Icons.location_on_outlined,
                                        size: 12, color: AppColors.textLight),
                                    Expanded(
                                        child: Text(' $loc',
                                            style: const TextStyle(
                                                color: AppColors.textLight,
                                                fontSize: 12),
                                            overflow: TextOverflow.ellipsis))
                                  ]),
                                ])),
                            if (!isOwn)
                              OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: const BorderSide(
                                          color: AppColors.primary),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  child: const Text('Chat')),
                          ]),
                        ),
                        const SizedBox(height: 20),
                        TabBar(
                            controller: _tabCtrl,
                            labelColor: AppColors.primary,
                            unselectedLabelColor: AppColors.textLight,
                            indicatorColor: AppColors.primary,
                            labelStyle:
                                const TextStyle(fontWeight: FontWeight.w700),
                            tabs: const [
                              Tab(text: 'Details'),
                              Tab(text: 'Specs'),
                              Tab(text: 'Reviews')
                            ]),
                        SizedBox(
                            height: 160,
                            child: TabBarView(controller: _tabCtrl, children: [
                              Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(desc,
                                      style: const TextStyle(
                                          color: AppColors.textMid,
                                          fontSize: 14,
                                          height: 1.6))),
                              Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Column(children: [
                                    if (weight.isNotEmpty)
                                      _specRow('Weight/Unit', weight),
                                    _specRow('Category', cat),
                                    if (qty.isNotEmpty)
                                      _specRow('Qty Available', qty),
                                    _specRow('Location',
                                        loc.isNotEmpty ? loc : 'Not specified'),
                                  ])),
                              Center(
                                  child: rating != null
                                      ? Text(
                                          '${List.filled(rating.round(), '⭐').join()}\n$rating · $reviews verified reviews',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: AppColors.textMid,
                                              height: 1.8))
                                      : const Text('No reviews yet.',
                                          style: TextStyle(
                                              color: AppColors.textLight))),
                            ])),
                      ]))),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ]),

        // Bottom bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4))
            ]),
            child: isOwn
                ? Row(children: [
                    Expanded(
                        child: SizedBox(
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          EditProductScreen(product: p))),
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: const Text('Edit',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 0),
                            ))),
                    const SizedBox(width: 8),
                    SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => _confirmDelete(context, p),
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16)),
                          child: const Icon(Icons.delete_outline_rounded,
                              size: 20),
                        )),
                  ])
                : Row(children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(children: [
                        IconButton(
                            icon: const Icon(Icons.remove_rounded, size: 18),
                            onPressed: () => setState(() {
                                  if (_qty > 1) _qty--;
                                }),
                            color: AppColors.textDark),
                        Text('$_qty',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark)),
                        IconButton(
                            icon: const Icon(Icons.add_rounded, size: 18),
                            onPressed: () => setState(() => _qty++),
                            color: AppColors.textDark),
                      ]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const CartScreen())),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  elevation: 0),
                              child: Text('Add to Cart · Rs. ${price * _qty}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                            ))),
                  ]),
          ),
        ),
      ]),
    );
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> p) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Row(children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
                SizedBox(width: 8),
                Text('Delete Product',
                    style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w800))
              ]),
              content: Text('Delete "${p['name']}"? This cannot be undone.',
                  style:
                      const TextStyle(color: AppColors.textMid, fontSize: 14)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    ProductStore.instance.deleteProduct(p['id'] as int);
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Product deleted'),
                        backgroundColor: Colors.red));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0),
                  child: const Text('Delete',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ));
  }

  Widget _badge(IconData icon, String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600))
        ]),
      );

  Widget _specRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Text(label,
              style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600))
        ]),
      );
}

// ════════════════════════════════════════════════════════════════════════════
// CART SCREEN
// ════════════════════════════════════════════════════════════════════════════

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _items = [
    {
      'name': 'Premium Basmati Paddy',
      'price': 4200,
      'qty': 2,
      'unit': 'bags',
      'cat': 'Paddy'
    },
    {
      'name': 'NPK 20-20-20 Fertilizer',
      'price': 3800,
      'qty': 1,
      'unit': 'bags',
      'cat': 'Fertilizer'
    },
    {
      'name': 'Pesticide Spray Pro',
      'price': 1800,
      'qty': 3,
      'unit': 'liters',
      'cat': 'Chemical'
    },
  ];

  int get _subtotal =>
      _items.fold(0, (s, i) => s + (i['price'] as int) * (i['qty'] as int));
  int get _delivery => 350;
  int get _total => _subtotal + _delivery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text('Cart (${_items.length} items)',
              style: const TextStyle(fontWeight: FontWeight.w800))),
      body: Column(children: [
        Expanded(
            child: ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: _items.length + 1,
          itemBuilder: (_, i) {
            if (i == _items.length) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border)),
                child: Row(children: [
                  const Icon(Icons.discount_outlined,
                      color: AppColors.gold, size: 22),
                  const SizedBox(width: 12),
                  const Expanded(
                      child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Enter promo code',
                              hintStyle: TextStyle(
                                  color: AppColors.textLight, fontSize: 14),
                              border: InputBorder.none,
                              isDense: true))),
                  TextButton(
                      onPressed: () {},
                      child: const Text('Apply',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700))),
                ]),
              );
            }
            final item = _items[i];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04), blurRadius: 8)
                  ]),
              child: Row(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ProductImage(
                        category: item['cat'] as String, size: 60)),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(item['name'] as String,
                          style: const TextStyle(
                              color: AppColors.textDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Rs. ${item['price']} / ${item['unit']}',
                          style: const TextStyle(
                              color: AppColors.textLight, fontSize: 12)),
                      const SizedBox(height: 8),
                      Row(children: [
                        Text('Rs. ${item['price'] * item['qty']}',
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w800)),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(children: [
                            InkWell(
                                onTap: () => setState(() {
                                      if (item['qty'] > 1) item['qty']--;
                                    }),
                                child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    child: Icon(Icons.remove_rounded,
                                        size: 14, color: AppColors.textDark))),
                            Text('${item['qty']}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark)),
                            InkWell(
                                onTap: () => setState(() => item['qty']++),
                                child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    child: Icon(Icons.add_rounded,
                                        size: 14, color: AppColors.textDark))),
                          ]),
                        ),
                      ]),
                    ])),
                IconButton(
                    icon: const Icon(Icons.close_rounded,
                        size: 18, color: AppColors.textLight),
                    onPressed: () => setState(() => _items.removeAt(i))),
              ]),
            );
          },
        )),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, -4))
          ]),
          child: Column(children: [
            _sumRow('Subtotal', 'Rs. $_subtotal'),
            const SizedBox(height: 8),
            _sumRow('Delivery', 'Rs. $_delivery'),
            const SizedBox(height: 8),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 8),
            _sumRow('Total', 'Rs. $_total',
                bold: true, color: AppColors.primary),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PaymentScreen(total: _total))),
                icon: const Icon(Icons.lock_outline_rounded),
                label: Text('Proceed to Payment · Rs. $_total',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _sumRow(String label, String value,
          {bool bold = false, Color? color}) =>
      Row(children: [
        Text(label,
            style: TextStyle(
                color: bold ? AppColors.textDark : AppColors.textMid,
                fontWeight: bold ? FontWeight.w800 : FontWeight.normal,
                fontSize: bold ? 16 : 14)),
        const Spacer(),
        Text(value,
            style: TextStyle(
                color: color ?? (bold ? AppColors.textDark : AppColors.textMid),
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                fontSize: bold ? 18 : 14)),
      ]);
}

// ════════════════════════════════════════════════════════════════════════════
// PAYMENT SCREEN  (full card form + all 4 methods)
// ════════════════════════════════════════════════════════════════════════════

class PaymentScreen extends StatefulWidget {
  final int total;
  const PaymentScreen({super.key, required this.total});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  int _method = 0; // 0=Card 1=Bank 2=Mobile 3=COD
  bool _processing = false;
  bool _success = false;
  late AnimationController _ac;
  late Animation<double> _scale;

  // Card fields
  final _cardNumCtrl = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  bool _saveCard = false;
  bool _showCvv = false;

  // Bank fields
  final _bankCtrl = TextEditingController();
  final _accCtrl = TextEditingController();
  final _branchCtrl = TextEditingController();

  // Mobile
  final _mobileCtrl = TextEditingController();
  int _mobileProvider = 0;

  final _methods = <Map<String, dynamic>>[
    {
      'label': 'Credit / Debit Card',
      'icon': Icons.credit_card_rounded,
      'color': Color(0xFF1D5FA8),
      'sub': 'Visa, Mastercard, AMEX'
    },
    {
      'label': 'Bank Transfer',
      'icon': Icons.account_balance_rounded,
      'color': AppColors.primary,
      'sub': 'Direct bank payment'
    },
    {
      'label': 'Mobile Pay',
      'icon': Icons.phone_android_rounded,
      'color': Color(0xFF805AD5),
      'sub': 'Dialog, Mobitel, Hutch'
    },
    {
      'label': 'Cash on Delivery',
      'icon': Icons.money_rounded,
      'color': AppColors.warning,
      'sub': 'Pay when you receive'
    },
  ];

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(parent: _ac, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _ac.dispose();
    _cardNumCtrl.dispose();
    _cardNameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _bankCtrl.dispose();
    _accCtrl.dispose();
    _branchCtrl.dispose();
    _mobileCtrl.dispose();
    super.dispose();
  }

  String _fmtCard(String s) {
    final d = s.replaceAll(' ', '');
    final buf = StringBuffer();
    for (int i = 0; i < d.length && i < 16; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(d[i]);
    }
    return buf.toString();
  }

  Future<void> _pay() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _processing = false;
      _success = true;
    });
    _ac.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_success) return _buildSuccess();
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text('Payment',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20))),
      body: Column(children: [
        // Amount banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          child: Column(children: [
            const Text('Total Amount',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 4),
            Text('Rs. ${widget.total}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.lock_rounded, color: Colors.white70, size: 11),
                  SizedBox(width: 4),
                  Text('Secured Payment',
                      style: TextStyle(color: Colors.white70, fontSize: 11))
                ])),
          ]),
        ),

        Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select Payment Method',
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),

                      // Method selector
                      ...List.generate(_methods.length, (i) {
                        final m = _methods[i];
                        final sel = _method == i;
                        final mc = m['color'] as Color;
                        return GestureDetector(
                          onTap: () => setState(() => _method = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                                color:
                                    sel ? mc.withOpacity(0.07) : AppColors.card,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: sel ? mc : AppColors.border,
                                    width: sel ? 2 : 1)),
                            child: Row(children: [
                              Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                      color: mc.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Icon(m['icon'] as IconData,
                                      color: mc, size: 22)),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(m['label'] as String,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: sel
                                                ? AppColors.textDark
                                                : AppColors.textMid)),
                                    Text(m['sub'] as String,
                                        style: const TextStyle(
                                            color: AppColors.textLight,
                                            fontSize: 12)),
                                  ])),
                              AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: sel ? mc : Colors.transparent,
                                      border: Border.all(
                                          color: sel ? mc : AppColors.border,
                                          width: 2)),
                                  child: sel
                                      ? const Icon(Icons.check_rounded,
                                          size: 14, color: Colors.white)
                                      : null),
                            ]),
                          ),
                        );
                      }),

                      const SizedBox(height: 8),

                      // Dynamic form
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anim) => FadeTransition(
                            opacity: anim,
                            child: SlideTransition(
                                position: Tween<Offset>(
                                        begin: const Offset(0, 0.05),
                                        end: Offset.zero)
                                    .animate(anim),
                                child: child)),
                        child: KeyedSubtree(
                            key: ValueKey(_method), child: _buildForm()),
                      ),
                      const SizedBox(height: 24),
                    ]))),

        // Pay button
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, -4))
          ]),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _processing ? null : _pay,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.gold.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0),
              child: _processing
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5)),
                          SizedBox(width: 12),
                          Text('Processing...',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16))
                        ])
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(_methods[_method]['icon'] as IconData, size: 20),
                      const SizedBox(width: 8),
                      Text('Pay Rs. ${widget.total}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 17))
                    ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildForm() {
    switch (_method) {
      case 0:
        return _cardForm();
      case 1:
        return _bankForm();
      case 2:
        return _mobileForm();
      default:
        return _codForm();
    }
  }

  // ── CARD FORM ────────────────────────────────────────────────────────────────
  Widget _cardForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Visual card preview ──────────────────────────────────────────────
        Container(
          height: 170,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                  Color(0xFF0F3460)
                ]),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8))
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.credit_card_rounded,
                  color: Colors.white70, size: 28),
              const Spacer(),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text('VISA',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 2))),
            ]),
            const Spacer(),
            ValueListenableBuilder(
                valueListenable: _cardNumCtrl,
                builder: (_, v, __) => Text(
                    v.text.isEmpty
                        ? '•••• •••• •••• ••••'
                        : v.text.padRight(19, '•').substring(0, 19),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600))),
            const SizedBox(height: 12),
            Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('CARD HOLDER',
                    style: TextStyle(
                        color: Colors.white38, fontSize: 9, letterSpacing: 1)),
                ValueListenableBuilder(
                    valueListenable: _cardNameCtrl,
                    builder: (_, v, __) => Text(
                        v.text.isEmpty ? 'YOUR NAME' : v.text.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(width: 24),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('EXPIRES',
                    style: TextStyle(
                        color: Colors.white38, fontSize: 9, letterSpacing: 1)),
                ValueListenableBuilder(
                    valueListenable: _expiryCtrl,
                    builder: (_, v, __) => Text(
                        v.text.isEmpty ? 'MM/YY' : v.text,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600))),
              ]),
            ]),
          ]),
        ),
        const SizedBox(height: 20),

        // Card number
        _fLabel('Card Number'),
        const SizedBox(height: 8),
        _pField(_cardNumCtrl, '1234 5678 9012 3456', Icons.credit_card_rounded,
            keyboardType: TextInputType.number, onChanged: (v) {
          final f = _fmtCard(v);
          if (f != v) {
            _cardNumCtrl.value = TextEditingValue(
                text: f, selection: TextSelection.collapsed(offset: f.length));
          }
        }),
        const SizedBox(height: 14),

        _fLabel('Card Holder Name'),
        const SizedBox(height: 8),
        _pField(_cardNameCtrl, 'Full name as on card',
            Icons.person_outline_rounded),
        const SizedBox(height: 14),

        Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                _fLabel('Expiry Date'),
                const SizedBox(height: 8),
                _pField(_expiryCtrl, 'MM/YY', Icons.calendar_today_outlined,
                    keyboardType: TextInputType.number, onChanged: (v) {
                  if (v.length == 2 && !v.contains('/')) {
                    _expiryCtrl.value = TextEditingValue(
                        text: '$v/',
                        selection: const TextSelection.collapsed(offset: 3));
                  }
                }),
              ])),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                _fLabel('CVV'),
                const SizedBox(height: 8),
                _pField(_cvvCtrl, '•••', Icons.lock_outline_rounded,
                    obscure: !_showCvv,
                    keyboardType: TextInputType.number,
                    suffix: IconButton(
                        icon: Icon(
                            _showCvv
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 18,
                            color: AppColors.textLight),
                        onPressed: () => setState(() => _showCvv = !_showCvv))),
              ])),
        ]),
        const SizedBox(height: 16),

        Row(children: [
          Transform.scale(
              scale: 0.85,
              child: Switch(
                  value: _saveCard,
                  onChanged: (v) => setState(() => _saveCard = v),
                  activeThumbColor: AppColors.primary)),
          const SizedBox(width: 4),
          const Text('Save card for future payments',
              style: TextStyle(color: AppColors.textMid, fontSize: 13)),
        ]),
        const SizedBox(height: 12),
        const Divider(color: AppColors.divider),
        const SizedBox(height: 12),

        // Accepted cards
        Row(children: [
          const Text('Accepted:',
              style: TextStyle(color: AppColors.textLight, fontSize: 12)),
          const SizedBox(width: 8),
          _cardBadge('VISA', const Color(0xFF1A1F71)),
          const SizedBox(width: 6),
          _cardBadge('MC', const Color(0xFFEB001B)),
          const SizedBox(width: 6),
          _cardBadge('AMEX', const Color(0xFF007CC3)),
        ]),
      ]),
    );
  }

  Widget _cardBadge(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.3))),
        child: Text(label,
            style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5)),
      );

  // ── BANK TRANSFER FORM ───────────────────────────────────────────────────────
  Widget _bankForm() {
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withOpacity(0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.info_outline_rounded,
                color: AppColors.primary, size: 18),
            SizedBox(width: 8),
            Text('Transfer to this account',
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13))
          ]),
          const SizedBox(height: 14),
          _bRow('Bank', 'Bank of Ceylon'),
          _bRow('Account Name', 'AgriMarket (Pvt) Ltd'),
          _bRow('Account No.', '0123456789', copyable: true),
          _bRow('Branch', 'Colombo 07'),
          _bRow('Reference', '#AGR-2402', copyable: true),
        ]),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Your Bank Details',
              style: TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
          const SizedBox(height: 4),
          const Text('Enter details to confirm your transfer',
              style: TextStyle(color: AppColors.textLight, fontSize: 12)),
          const SizedBox(height: 16),
          _fLabel('Your Bank Name'),
          const SizedBox(height: 8),
          _pField(_bankCtrl, 'e.g. Commercial Bank',
              Icons.account_balance_outlined),
          const SizedBox(height: 14),
          _fLabel('Account Number'),
          const SizedBox(height: 8),
          _pField(_accCtrl, 'Enter account number', Icons.numbers_rounded,
              keyboardType: TextInputType.number),
          const SizedBox(height: 14),
          _fLabel('Branch'),
          const SizedBox(height: 8),
          _pField(_branchCtrl, 'e.g. Kandy Branch', Icons.location_on_outlined),
          const SizedBox(height: 16),
          Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.gold.withOpacity(0.3))),
              child: const Row(children: [
                Icon(Icons.schedule_rounded, color: AppColors.gold, size: 16),
                SizedBox(width: 8),
                Expanded(
                    child: Text('Bank transfers may take 1–2 business days.',
                        style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)))
              ])),
        ]),
      ),
    ]);
  }

  Widget _bRow(String label, String value, {bool copyable = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          SizedBox(
              width: 110,
              child: Text(label,
                  style: const TextStyle(
                      color: AppColors.textLight, fontSize: 13))),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13))),
          if (copyable)
            const Icon(Icons.copy_rounded, size: 15, color: AppColors.primary),
        ]),
      );

  // ── MOBILE PAY FORM ──────────────────────────────────────────────────────────
  Widget _mobileForm() {
    final providers = [
      {'name': 'Dialog Pay', 'color': const Color(0xFFE53E3E)},
      {'name': 'Mobitel', 'color': const Color(0xFF2B6CB0)},
      {'name': 'Hutch', 'color': const Color(0xFFD69E2E)},
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Select Provider',
            style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 14)),
        const SizedBox(height: 12),
        Row(
            children: providers.asMap().entries.map((e) {
          final i = e.key;
          final p = e.value;
          final sel = _mobileProvider == i;
          final c = p['color'] as Color;
          return Expanded(
              child: GestureDetector(
            onTap: () => setState(() => _mobileProvider = i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                  color: sel ? c.withOpacity(0.1) : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: sel ? c : AppColors.border, width: sel ? 2 : 1)),
              child: Column(children: [
                Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                        color: c.withOpacity(0.15), shape: BoxShape.circle),
                    child:
                        Icon(Icons.phone_android_rounded, color: c, size: 16)),
                const SizedBox(height: 6),
                Text(p['name'] as String,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.normal,
                        color: sel ? c : AppColors.textMid),
                    textAlign: TextAlign.center),
              ]),
            ),
          ));
        }).toList()),
        const SizedBox(height: 20),
        _fLabel('Mobile Number'),
        const SizedBox(height: 8),
        _pField(_mobileCtrl, '07X XXX XXXX', Icons.phone_outlined,
            keyboardType: TextInputType.phone),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: const Color(0xFF805AD5).withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color(0xFF805AD5).withOpacity(0.2))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.info_outline_rounded,
                  color: Color(0xFF805AD5), size: 16),
              SizedBox(width: 6),
              Text('How it works',
                  style: TextStyle(
                      color: Color(0xFF805AD5),
                      fontWeight: FontWeight.w700,
                      fontSize: 13))
            ]),
            const SizedBox(height: 10),
            _step('1', 'Enter your mobile number'),
            _step('2', 'You\'ll receive an OTP to confirm'),
            _step('3', 'Approve payment in your mobile wallet'),
          ]),
        ),
      ]),
    );
  }

  Widget _step(String n, String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                  color: Color(0xFF805AD5), shape: BoxShape.circle),
              child: Center(
                  child: Text(n,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800)))),
          const SizedBox(width: 10),
          Text(text,
              style: const TextStyle(color: AppColors.textMid, fontSize: 13)),
        ]),
      );

  // ── CASH ON DELIVERY FORM ────────────────────────────────────────────────────
  Widget _codForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]),
      child: Column(children: [
        Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                shape: BoxShape.circle),
            child: const Icon(Icons.money_rounded,
                color: AppColors.warning, size: 40)),
        const SizedBox(height: 16),
        const Text('Cash on Delivery',
            style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        const Text(
            'Pay in cash when your order is delivered.\nPlease keep the exact amount ready.',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: AppColors.textMid, fontSize: 14, height: 1.5)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border)),
          child: Column(children: [
            _cRow(Icons.receipt_long_rounded, 'Amount to Pay',
                'Rs. ${widget.total}',
                bold: true),
            const Divider(height: 20, color: AppColors.divider),
            _cRow(Icons.schedule_rounded, 'Est. Delivery', '3–5 business days'),
            const SizedBox(height: 8),
            _cRow(Icons.location_on_outlined, 'Delivery to',
                'Colombo, Western Province'),
          ]),
        ),
        const SizedBox(height: 16),
        Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.gold.withOpacity(0.3))),
            child: const Row(children: [
              Icon(Icons.warning_amber_rounded,
                  color: AppColors.gold, size: 16),
              SizedBox(width: 8),
              Expanded(
                  child: Text('A small COD handling fee of Rs. 50 applies.',
                      style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)))
            ])),
      ]),
    );
  }

  Widget _cRow(IconData icon, String label, String value,
          {bool bold = false}) =>
      Row(children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(label,
            style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
        const Spacer(),
        Text(value,
            style: TextStyle(
                color: bold ? AppColors.primary : AppColors.textDark,
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                fontSize: bold ? 16 : 13)),
      ]);

  // ── SUCCESS SCREEN ───────────────────────────────────────────────────────────
  Widget _buildSuccess() {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
          child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScaleTransition(
                            scale: _scale,
                            child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                        colors: [
                                          AppColors.success,
                                          Color(0xFF1A5C34)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.success
                                              .withOpacity(0.4),
                                          blurRadius: 24,
                                          offset: const Offset(0, 8))
                                    ]),
                                child: const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 60))),
                        const SizedBox(height: 32),
                        const Text('Payment Successful!',
                            style: TextStyle(
                                color: AppColors.textDark,
                                fontSize: 28,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 12),
                        Text('Rs. ${widget.total}',
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 36,
                                fontWeight: FontWeight.w900)),
                        const SizedBox(height: 8),
                        const Text(
                            'Your order has been placed.\nA confirmation will be sent shortly.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.textMid,
                                fontSize: 15,
                                height: 1.5)),
                        const SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border)),
                          child: Column(children: [
                            _sRow('Order ID', '#AGR-2402'),
                            const Divider(height: 20, color: AppColors.divider),
                            _sRow('Payment Method',
                                _methods[_method]['label'] as String),
                            const Divider(height: 20, color: AppColors.divider),
                            _sRow('Status', '✅ Confirmed'),
                          ]),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context)
                                .popUntil((r) => r.isFirst),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                elevation: 0),
                            child: const Text('Back to Home',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16)),
                          ),
                        ),
                      ])))),
    );
  }

  Widget _sRow(String label, String value) => Row(children: [
        Text(label,
            style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
      ]);

  // ── Field helpers ────────────────────────────────────────────────────────────
  Widget _fLabel(String t) => Text(t,
      style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 13,
          fontWeight: FontWeight.w700));

  Widget _pField(TextEditingController ctrl, String hint, IconData icon,
          {bool obscure = false,
          TextInputType? keyboardType,
          Widget? suffix,
          ValueChanged<String>? onChanged}) =>
      Container(
        decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border)),
        child: TextField(
          controller: ctrl,
          obscureText: obscure,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: const TextStyle(color: AppColors.textDark, fontSize: 15),
          decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(color: AppColors.textLight, fontSize: 14),
              prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
        ),
      );
}

// ════════════════════════════════════════════════════════════════════════════
// ORDER HISTORY SCREEN
// ════════════════════════════════════════════════════════════════════════════

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {
        'id': '#AGR-2401',
        'product': 'Basmati Paddy x2 bags',
        'date': 'Feb 20, 2025',
        'status': 'Delivered',
        'amount': 8400,
        'color': AppColors.success,
        'cat': 'Paddy'
      },
      {
        'id': '#AGR-2398',
        'product': 'NPK Fertilizer x1 bag',
        'date': 'Feb 14, 2025',
        'status': 'In Transit',
        'amount': 3800,
        'color': AppColors.warning,
        'cat': 'Fertilizer'
      },
      {
        'id': '#AGR-2391',
        'product': 'Pesticide Spray x5L',
        'date': 'Feb 5, 2025',
        'status': 'Processing',
        'amount': 9000,
        'color': AppColors.info,
        'cat': 'Chemical'
      },
      {
        'id': '#AGR-2380',
        'product': 'Yellow Corn x20 kg',
        'date': 'Jan 28, 2025',
        'status': 'Delivered',
        'amount': 13000,
        'color': AppColors.success,
        'cat': 'Corn'
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text('My Orders',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20))),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: orders.length,
        itemBuilder: (_, i) {
          final o = orders[i];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04), blurRadius: 8)
                ]),
            child: Row(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ProductImage(category: o['cat'] as String, size: 56)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(children: [
                      Text(o['id'] as String,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 14)),
                      const Spacer(),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              color: (o['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(o['status'] as String,
                              style: TextStyle(
                                  color: o['color'] as Color,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11))),
                    ]),
                    const SizedBox(height: 4),
                    Text(o['product'] as String,
                        style: const TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 13)),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 12, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(o['date'] as String,
                          style: const TextStyle(
                              color: AppColors.textLight, fontSize: 12)),
                      const Spacer(),
                      Text('Rs. ${o['amount']}',
                          style: const TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w800,
                              fontSize: 15)),
                    ]),
                  ])),
            ]),
          );
        },
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// MY LISTINGS SCREEN
// ════════════════════════════════════════════════════════════════════════════

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});
  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  @override
  void initState() {
    super.initState();
    ProductStore.instance.products.addListener(_refresh);
  }

  @override
  void dispose() {
    ProductStore.instance.products.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  List<Map<String, dynamic>> get _mine => ProductStore.instance.products.value
      .where((p) => p['isOwn'] == true)
      .toList();

  void _confirmDelete(Map<String, dynamic> p) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Row(children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
                SizedBox(width: 8),
                Text('Delete Product',
                    style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w800))
              ]),
              content: Text('Delete "${p['name']}"? Cannot be undone.',
                  style:
                      const TextStyle(color: AppColors.textMid, fontSize: 14)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    ProductStore.instance.deleteProduct(p['id'] as int);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Product deleted'),
                        backgroundColor: Colors.red));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0),
                  child: const Text('Delete',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final mine = _mine;
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('My Listings',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12)),
              child: Text('${mine.length} items',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)))
        ],
      ),
      body: mine.isEmpty
          ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          shape: BoxShape.circle),
                      child: const Icon(Icons.inventory_2_outlined,
                          size: 56, color: AppColors.primary)),
                  const SizedBox(height: 20),
                  const Text('No listings yet',
                      style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  const Text('Products you post will appear here.',
                      style:
                          TextStyle(color: AppColors.textLight, fontSize: 14)),
                ]))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: mine.length,
              itemBuilder: (ctx, i) {
                final p = mine[i];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8)
                      ]),
                  child: Column(children: [
                    Row(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: ProductImage(
                              category: p['cat'] as String, size: 58)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(p['name'] as String,
                                style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(
                                '${p['cat']} · ${(p['loc'] as String?)?.split(',')[0] ?? ''}',
                                style: const TextStyle(
                                    color: AppColors.textLight, fontSize: 12)),
                            Text('Rs. ${p['price']} ${p['unit']}',
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800)),
                          ])),
                    ]),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.divider, height: 1),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(
                          child: OutlinedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                              ctx,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      EditProductScreen(product: p)));
                          setState(() {});
                        },
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Edit',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 10)),
                      )),
                      const SizedBox(width: 8),
                      Expanded(
                          child: OutlinedButton.icon(
                        onPressed: () {
                          final ns =
                              p['stock'] == 'In Stock' ? 'Limited' : 'In Stock';
                          ProductStore.instance
                              .updateProduct(p['id'] as int, {'stock': ns});
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Stock updated to "$ns"'),
                              backgroundColor: AppColors.success));
                        },
                        icon: Icon(
                            p['stock'] == 'In Stock'
                                ? Icons.check_circle_outline
                                : Icons.warning_amber_outlined,
                            size: 16),
                        label: Text(
                            p['stock'] == 'In Stock' ? 'In Stock' : 'Limited',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13)),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: p['stock'] == 'In Stock'
                                ? AppColors.success
                                : AppColors.warning,
                            side: BorderSide(
                                color: p['stock'] == 'In Stock'
                                    ? AppColors.success
                                    : AppColors.warning),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(vertical: 10)),
                      )),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _confirmDelete(p),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10)),
                        child:
                            const Icon(Icons.delete_outline_rounded, size: 18),
                      ),
                    ]),
                  ]),
                );
              },
            ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// EDIT PRODUCT SCREEN
// ════════════════════════════════════════════════════════════════════════════

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const EditProductScreen({super.key, required this.product});
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late String _selectedCategory, _selectedUnit, _selectedLocation;
  late TextEditingController _nameCtrl, _priceCtrl, _qtyCtrl, _descCtrl;

  final _categories = ['Paddy', 'Corn', 'Fertilizer', 'Chemical'];
  final _units = ['per kg', 'per bag', 'per ton', 'per liter', 'per packet'];
  final _catInfo = <String, Map<String, dynamic>>{
    'Paddy': {'icon': Icons.grass_rounded, 'color': AppColors.paddyGreen},
    'Corn': {'icon': Icons.eco_rounded, 'color': AppColors.cornAmber},
    'Fertilizer': {'icon': Icons.science_rounded, 'color': AppColors.fertBlue},
    'Chemical': {'icon': Icons.biotech_rounded, 'color': AppColors.chemRed},
  };
  final List<Map<String, String>> _districts = [
    {'name': 'Colombo', 'province': 'Western Province'},
    {'name': 'Gampaha', 'province': 'Western Province'},
    {'name': 'Kandy', 'province': 'Central Province'},
    {'name': 'Galle', 'province': 'Southern Province'},
    {'name': 'Jaffna', 'province': 'Northern Province'},
    {'name': 'Batticaloa', 'province': 'Eastern Province'},
    {'name': 'Kurunegala', 'province': 'North Western Province'},
    {'name': 'Anuradhapura', 'province': 'North Central Province'},
    {'name': 'Polonnaruwa', 'province': 'North Central Province'},
    {'name': 'Badulla', 'province': 'Uva Province'},
    {'name': 'Ratnapura', 'province': 'Sabaragamuwa Province'},
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _selectedCategory = (p['cat'] ?? 'Paddy') as String;
    _selectedUnit = (p['unit'] ?? 'per kg') as String;
    _selectedLocation = (p['loc'] ?? '') as String;
    _nameCtrl = TextEditingController(text: p['name'] as String? ?? '');
    _priceCtrl = TextEditingController(text: '${p['price'] ?? ''}');
    _qtyCtrl =
        TextEditingController(text: (p['qty'] ?? p['weight'] ?? '') as String);
    _descCtrl = TextEditingController(text: (p['desc'] ?? '') as String);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _qtyCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _showLocationPicker() {
    String s = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(builder: (ctx, sm) {
        final f = _districts
            .where((d) =>
                d['name']!.toLowerCase().contains(s.toLowerCase()) ||
                d['province']!.toLowerCase().contains(s.toLowerCase()))
            .toList();
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.75,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(children: [
            const SizedBox(height: 12),
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            const Text('Select District',
                style: TextStyle(
                    color: AppColors.textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border)),
                child: TextField(
                    autofocus: true,
                    onChanged: (v) => sm(() => s = v),
                    decoration: const InputDecoration(
                        hintText: 'Search district...',
                        prefixIcon: Icon(Icons.search_rounded,
                            color: AppColors.primary, size: 20),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14))),
              ),
            ),
            const Divider(color: AppColors.divider),
            Expanded(
                child: ListView.builder(
                    itemCount: f.length,
                    itemBuilder: (_, i) {
                      final d = f[i];
                      final sel =
                          _selectedLocation == '${d['name']}, ${d['province']}';
                      return ListTile(
                        onTap: () {
                          setState(() => _selectedLocation =
                              '${d['name']}, ${d['province']}');
                          Navigator.pop(ctx);
                        },
                        leading: Icon(Icons.location_on_rounded,
                            color:
                                sel ? AppColors.primary : AppColors.textLight,
                            size: 20),
                        title: Text(d['name']!,
                            style: TextStyle(
                                fontWeight:
                                    sel ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 14)),
                        subtitle: Text(d['province']!,
                            style: const TextStyle(
                                color: AppColors.textLight, fontSize: 12)),
                        trailing: sel
                            ? const Icon(Icons.check_circle_rounded,
                                color: AppColors.primary, size: 20)
                            : null,
                      );
                    })),
          ]),
        );
      }),
    );
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Name cannot be empty'),
          backgroundColor: AppColors.warning));
      return;
    }
    ProductStore.instance.updateProduct(widget.product['id'] as int, {
      'name': _nameCtrl.text.trim(),
      'price':
          int.tryParse(_priceCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
              widget.product['price'],
      'unit': _selectedUnit,
      'qty': _qtyCtrl.text.trim(),
      'weight': _qtyCtrl.text.trim(),
      'cat': _selectedCategory,
      'loc': _selectedLocation,
      'desc': _descCtrl.text.trim(),
      'icon': _catInfo[_selectedCategory]!['icon'],
      'color': _catInfo[_selectedCategory]!['color'],
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('✅ Product updated!'),
        backgroundColor: AppColors.success));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text('Edit Product',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
          actions: [
            TextButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_rounded,
                    color: AppColors.gold, size: 20),
                label: const Text('Save',
                    style: TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w800,
                        fontSize: 15)))
          ]),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.2))),
                child: const Row(children: [
                  Icon(Icons.info_outline_rounded,
                      color: AppColors.primary, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                      child: Text(
                          'Changes reflect immediately on Home & Market.',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)))
                ])),
            const SizedBox(height: 20),
            const _SectionLabel('Product Category *'),
            const SizedBox(height: 8),
            Row(
                children: _categories.map((cat) {
              final sel = _selectedCategory == cat;
              final c = _catInfo[cat]!['color'] as Color;
              return Expanded(
                  child: GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: sel ? c.withOpacity(0.1) : AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: sel ? c : AppColors.border,
                          width: sel ? 2 : 1)),
                  child: Column(children: [
                    Icon(_catInfo[cat]!['icon'] as IconData,
                        color: sel ? c : AppColors.textLight, size: 22),
                    const SizedBox(height: 4),
                    Text(cat,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight:
                                sel ? FontWeight.w700 : FontWeight.normal,
                            color: sel ? c : AppColors.textLight)),
                  ]),
                ),
              ));
            }).toList()),
            const SizedBox(height: 20),
            const _SectionLabel('Product Name *'),
            const SizedBox(height: 8),
            _ef(_nameCtrl, 'Product name', Icons.inventory_2_outlined),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const _SectionLabel('Price (Rs.) *'),
                    const SizedBox(height: 8),
                    _ef(_priceCtrl, '0', Icons.attach_money,
                        keyboardType: TextInputType.number)
                  ])),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const _SectionLabel('Unit *'),
                    const SizedBox(height: 8),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border)),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                value: _selectedUnit,
                                isExpanded: true,
                                style: const TextStyle(
                                    color: AppColors.textDark, fontSize: 14),
                                onChanged: (v) =>
                                    setState(() => _selectedUnit = v!),
                                items: _units
                                    .map((u) => DropdownMenuItem(
                                        value: u, child: Text(u)))
                                    .toList()))),
                  ])),
            ]),
            const SizedBox(height: 16),
            const _SectionLabel('Quantity'),
            const SizedBox(height: 8),
            _ef(_qtyCtrl, 'e.g. 500 kg', Icons.scale_outlined),
            const SizedBox(height: 16),
            const _SectionLabel('Description'),
            const SizedBox(height: 8),
            Container(
                decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border)),
                child: TextField(
                    controller: _descCtrl,
                    maxLines: 4,
                    style: const TextStyle(
                        color: AppColors.textDark, fontSize: 14),
                    decoration: const InputDecoration(
                        hintText: 'Describe your product...',
                        hintStyle: TextStyle(color: AppColors.textLight),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16)))),
            const SizedBox(height: 16),
            const _SectionLabel('Location *'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showLocationPicker,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: _selectedLocation.isEmpty
                        ? AppColors.card
                        : AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: _selectedLocation.isEmpty
                            ? AppColors.border
                            : AppColors.primary,
                        width: _selectedLocation.isEmpty ? 1 : 1.5)),
                child: Row(children: [
                  Icon(Icons.location_on_rounded,
                      color: _selectedLocation.isEmpty
                          ? AppColors.textLight
                          : AppColors.primary,
                      size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _selectedLocation.isEmpty
                          ? const Text('Select district',
                              style: TextStyle(
                                  color: AppColors.textLight, fontSize: 14))
                          : Text(_selectedLocation,
                              style: const TextStyle(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14))),
                  Icon(
                      _selectedLocation.isEmpty
                          ? Icons.chevron_right_rounded
                          : Icons.edit_location_alt_outlined,
                      color: _selectedLocation.isEmpty
                          ? AppColors.textLight
                          : AppColors.primary,
                      size: 20),
                ]),
              ),
            ),
            const SizedBox(height: 32),
            Row(children: [
              Expanded(
                  child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textMid,
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Cancel',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)))),
              const SizedBox(width: 12),
              Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save_rounded, size: 18),
                      label: const Text('Save Changes',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0))),
            ]),
            const SizedBox(height: 24),
          ])),
    );
  }

  Widget _ef(TextEditingController ctrl, String hint, IconData icon,
          {TextInputType? keyboardType}) =>
      Container(
        decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border)),
        child: TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            style: const TextStyle(color: AppColors.textDark, fontSize: 14),
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.textLight),
                prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14))),
      );
}

// ════════════════════════════════════════════════════════════════════════════
// PROFILE SCREEN  (integrated — uses Session / ApiService defined above)
// ════════════════════════════════════════════════════════════════════════════
