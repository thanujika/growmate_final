import 'package:flutter/material.dart';
// ════════════════════════════════════════════════════════════════════════════
// INTEGRATION NOTE
// Replace these stubs with your real imports:
//   import 'main.dart';           // AppColors, Session, AppUser, ApiService
//   import 'localization.dart';   // AppL10n, AppLocale
// ════════════════════════════════════════════════════════════════════════════

// ── Colour tokens (identical to main.dart AppColors) ────────────────────────
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
}

// ── Stub models — remove when using real main.dart ──────────────────────────
class AppUser {
  final int id;
  final String name, email, phone, cropType, region;
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.cropType,
    required this.region,
  });
  AppUser copyWith(
          {String? name, String? phone, String? cropType, String? region}) =>
      AppUser(
        id: id,
        email: email,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        cropType: cropType ?? this.cropType,
        region: region ?? this.region,
      );
}

class Session {
  static AppUser? _user = const AppUser(
    id: 1,
    name: 'Suresh Kumar',
    email: 'suresh@growmate.lk',
    phone: '077 123 4567',
    cropType: 'Paddy',
    region: 'North Central',
  );
  static AppUser? get user => _user;
  static final Map<String, String> headers = {
    'Authorization': 'Bearer demo_token'
  };
  static Future<void> save(String token, AppUser user) async => _user = user;
  static Future<void> clear() async => _user = null;
}

class ApiService {
  static Future<String?> updateProfile(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return null; // null = success
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await Session.clear();
  }
}

// ════════════════════════════════════════════════════════════════════════════
// PROFILE SCREEN - FULLY FIXED VERSION
// ════════════════════════════════════════════════════════════════════════════

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  // ── Edit / save state ──────────────────────────────────────────────────────
  bool _editMode = false;
  bool _isSaving = false;

  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  String _selectedCrop = 'Paddy';
  String _selectedRegion = 'Central';

  final _crops = ['Paddy', 'Corn', 'Both'];
  final _regions = [
    'Central',
    'North',
    'South',
    'East',
    'West',
    'North Western',
    'North Central',
    'Uva',
    'Sabaragamuwa',
  ];

  // ── Activities state ──────────────────────────────────────────────────────
  List<Map<String, dynamic>> _activities = [];
  bool _isLoadingActivities = false;

  // ── Animation ──────────────────────────────────────────────────────────────
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    final user = Session.user;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _selectedCrop = user?.cropType ?? 'Paddy';
    _selectedRegion = user?.region ?? 'Central';

    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();

    // Load activities
    _loadActivities();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Load activities from API ───────────────────────────────────────────────
  Future<void> _loadActivities() async {
    setState(() => _isLoadingActivities = true);

    // Simulate API call - Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _activities = [
        {
          'icon': '🌾',
          'title': 'Paddy harvest completed',
          'subtitle': 'Harvested 250kg from Field A',
          'time': '2 days ago',
          'color': const Color(0xFF2D7D46),
          'id': '1',
          'type': 'harvest',
        },
        {
          'icon': '🚜',
          'title': 'Hired tractor from Ranjith P.',
          'subtitle': 'Plowing service • LKR 5,500',
          'time': '5 days ago',
          'color': const Color(0xFF1D5FA8),
          'id': '2',
          'type': 'hire',
        },
        {
          'icon': '🛒',
          'title': 'Purchased NPK fertilizer',
          'subtitle': 'Quantity: 50kg • LKR 4,200',
          'time': '1 week ago',
          'color': const Color(0xFFB85C00),
          'id': '3',
          'type': 'purchase',
        },
        {
          'icon': '🤖',
          'title': 'AI diagnosis: Leaf blight detected',
          'subtitle': 'Treatment recommended',
          'time': '2 weeks ago',
          'color': const Color(0xFFB91C1C),
          'id': '4',
          'type': 'diagnosis',
        },
        {
          'icon': '💧',
          'title': 'Weather alert: Heavy rain expected',
          'subtitle': 'Take necessary precautions',
          'time': '2 weeks ago',
          'color': const Color(0xFF1D5FA8),
          'id': '5',
          'type': 'weather',
        },
      ];
      _isLoadingActivities = false;
    });
  }

  // ── Refresh activities (pull to refresh) ───────────────────────────────────
  Future<void> _refreshActivities() async {
    await _loadActivities();
  }

  // ── Handle activity tap ────────────────────────────────────────────────────
  void _handleActivityTap(Map<String, dynamic> activity) {
    switch (activity['type']) {
      case 'harvest':
        _showActivityDialog(
          'Harvest Details',
          '🌾 ${activity['title']}',
          '• Crop: Paddy\n• Quantity: 250kg\n• Date: ${activity['time']}\n• Field: Field A\n• Status: Completed',
        );
        break;
      case 'hire':
        _showActivityDialog(
          'Hiring Details',
          '🚜 ${activity['title']}',
          '• Service Provider: Ranjith P.\n• Service: Plowing\n• Cost: LKR 5,500\n• Date: ${activity['time']}\n• Status: Completed',
        );
        break;
      case 'purchase':
        _showActivityDialog(
          'Purchase Details',
          '🛒 ${activity['title']}',
          '• Item: NPK Fertilizer\n• Quantity: 50kg\n• Total: LKR 4,200\n• Date: ${activity['time']}\n• Payment: Digital Payment',
        );
        break;
      case 'diagnosis':
        _showActivityDialog(
          'AI Diagnosis Report',
          '🤖 ${activity['title']}',
          '• Disease: Leaf Blight\n• Confidence: 94%\n• Recommended Action:\n  Apply fungicide\n  Remove affected leaves\n• Follow-up: In 7 days',
        );
        break;
      case 'weather':
        _showActivityDialog(
          'Weather Alert',
          '💧 ${activity['title']}',
          '• Alert Type: Heavy Rainfall\n• Expected Rainfall: 50-70mm\n• Duration: 2-3 days\n• Recommendations:\n  - Ensure proper drainage\n  - Cover harvested crops\n  - Avoid fertilizer application',
        );
        break;
      default:
        _snack('Viewing ${activity['title']}');
    }
  }

  // ── Show activity details dialog ───────────────────────────────────────────
// ── Show activity details dialog ───────────────────────────────────────────
  void _showActivityDialog(String title, String subtitle, String details) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        subtitle.split(' ')[0],
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 15),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                details,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textMid,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Save profile ───────────────────────────────────────────────────────────
  Future<void> _saveProfile() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _snack('Name cannot be empty', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    final error = await ApiService.updateProfile({
      'name': name,
      'phone': _phoneCtrl.text.trim(),
      'crop_type': _selectedCrop,
      'region': _selectedRegion,
    });

    if (!mounted) return;

    if (error == null) {
      // Update session cache so name reflects everywhere immediately
      await Session.save(
        Session.headers['Authorization']?.replaceFirst('Bearer ', '') ?? '',
        AppUser(
          id: Session.user!.id,
          name: name,
          email: Session.user!.email,
          phone: _phoneCtrl.text.trim(),
          cropType: _selectedCrop,
          region: _selectedRegion,
        ),
      );
      _snack('Profile updated successfully ✅');
    } else {
      _snack(error, isError: true);
    }

    setState(() {
      _isSaving = false;
      _editMode = false;
    });
  }

  // ── Cancel edit (revert fields to saved values) ────────────────────────────
  void _cancelEdit() {
    final u = Session.user;
    _nameCtrl.text = u?.name ?? '';
    _phoneCtrl.text = u?.phone ?? '';
    setState(() {
      _selectedCrop = u?.cropType ?? 'Paddy';
      _selectedRegion = u?.region ?? 'Central';
      _editMode = false;
    });
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.logout_rounded, color: Colors.red, size: 22),
          SizedBox(width: 8),
          Text('Logout',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        ]),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 14, color: AppColors.textMid),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(
                    color: AppColors.textLight, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Logout',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ApiService.logout();
      if (mounted) {
        // Pop back to root (SplashScreen / login) — adjust route as needed
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }

  // ── Snackbar helper ────────────────────────────────────────────────────────
  void _snack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    ));
  }

  // ════════════════════════════════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final user = Session.user;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        // Logo + title
        title: Row(children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                color: AppColors.gold, borderRadius: BorderRadius.circular(9)),
            child: const Icon(Icons.eco_rounded, color: Colors.white, size: 17),
          ),
          const SizedBox(width: 10),
          Text(
            _editMode ? 'Edit Profile' : 'My Profile',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ]),
        actions: [
          if (!_editMode) ...[
            // Edit
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.white),
              tooltip: 'Edit profile',
              onPressed: () => setState(() => _editMode = true),
            ),
            // Logout
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              tooltip: 'Logout',
              onPressed: _logout,
            ),
          ] else ...[
            // Cancel
            TextButton(
              onPressed: _cancelEdit,
              child: const Text('Cancel',
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w600)),
            ),
            // Save
            TextButton(
              onPressed: _isSaving ? null : _saveProfile,
              child: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('Save',
                      style: TextStyle(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w800,
                          fontSize: 15)),
            ),
          ],
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: RefreshIndicator(
          onRefresh: _refreshActivities,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(children: [
              _buildHeader(user),
              _buildStatsStrip(),
              _editMode ? _buildEditForm() : _buildViewDetails(user),
              if (!_editMode) _buildActivity(),
              if (!_editMode) _buildAccountMenu(),
              if (!_editMode) _buildLogoutButton(),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // HEADER — gradient + avatar
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildHeader(AppUser? user) {
    // Build initials safely from name
    final name = user?.name.trim() ?? '';
    final initials = name.isNotEmpty
        ? name
            .split(' ')
            .map((w) => w.isNotEmpty ? w[0] : '')
            .take(2)
            .join()
            .toUpperCase()
        : 'F';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.primaryLight
          ],
        ),
      ),
      child: Column(children: [
        // Avatar
        Stack(clipBehavior: Clip.none, children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border:
                  Border.all(color: Colors.white.withOpacity(0.5), width: 3),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8))
              ],
            ),
            child: Center(
              child: Text(initials,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1)),
            ),
          ),
          // Camera button
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _snack('Photo upload coming soon'),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                    color: AppColors.gold, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt_rounded,
                    color: Colors.white, size: 16),
              ),
            ),
          ),
        ]),

        const SizedBox(height: 18),

        // Name — shows live update when editing
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            key: ValueKey(_editMode ? _nameCtrl.text : (user?.name ?? '')),
            _editMode
                ? (_nameCtrl.text.trim().isNotEmpty
                    ? _nameCtrl.text.trim()
                    : 'Farmer')
                : (user?.name ?? 'Farmer'),
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 24,
                letterSpacing: -0.5),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          user?.email ?? '',
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
        ),

        const SizedBox(height: 16),

        // Badges
        Wrap(spacing: 8, runSpacing: 6, children: [
          _badge('🌾 $_selectedCrop Farmer'),
          _badge('📍 $_selectedRegion'),
          _badge('✅ Verified'),
        ]),
      ]),
    );
  }

  Widget _badge(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600)),
      );

  // ════════════════════════════════════════════════════════════════════════════
  // STATS STRIP
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildStatsStrip() {
    final stats = [
      ('4.3 ha', 'Total Farm', AppColors.primary),
      ('12', 'Seasons', AppColors.info),
      ('LKR 18K', 'This Year', AppColors.warning),
      ('4.8 ⭐', 'Rating', AppColors.gold),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(stats.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Container(width: 1, height: 40, color: AppColors.divider);
          }
          final s = stats[i ~/ 2];
          return Column(children: [
            Text(s.$1,
                style: TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 16, color: s.$3)),
            const SizedBox(height: 4),
            Text(s.$2,
                style:
                    const TextStyle(color: AppColors.textLight, fontSize: 11)),
          ]);
        }),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // VIEW — Farm Details card
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildViewDetails(AppUser? user) {
    // FIX: safe null check on phone before calling .isNotEmpty
    final phone = (user?.phone.isNotEmpty == true) ? user!.phone : '—';

    return _card('Farm Details', [
      _infoRow(Icons.person_rounded, 'Full Name', user?.name ?? '—'),
      _infoRow(Icons.email_rounded, 'Email', user?.email ?? '—'),
      _infoRow(Icons.phone_rounded, 'Phone', phone),
      _infoRow(Icons.grass_rounded, 'Primary Crop', user?.cropType ?? '—'),
      _infoRow(Icons.location_on_rounded, 'Region', user?.region ?? '—'),
    ]);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // EDIT FORM
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildEditForm() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _cardHeader('Edit Profile'),
        const SizedBox(height: 20),

        // Info banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: const Row(children: [
            Icon(Icons.info_outline_rounded,
                color: AppColors.primary, size: 16),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Changes are saved to your account and visible across the app.',
                style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 20),

        // Full Name
        _fieldLabel('Full Name *'),
        const SizedBox(height: 6),
        _textField(
          _nameCtrl,
          'Enter your full name',
          Icons.person_rounded,
          onChanged: (_) => setState(() {}), // live update header
        ),
        const SizedBox(height: 16),

        // Phone
        _fieldLabel('Phone Number'),
        const SizedBox(height: 6),
        _textField(
          _phoneCtrl,
          'e.g. 077 123 4567',
          Icons.phone_rounded,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),

        // Email (read-only)
        _fieldLabel('Email Address (cannot change)'),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(children: [
            Icon(Icons.email_rounded, color: Colors.grey[400], size: 20),
            const SizedBox(width: 10),
            Text(
              Session.user?.email ?? '',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
            const Spacer(),
            Icon(Icons.lock_outline_rounded, color: Colors.grey[300], size: 16),
          ]),
        ),
        const SizedBox(height: 16),

        // Primary Crop
        _fieldLabel('Primary Crop'),
        const SizedBox(height: 6),
        _dropdownField(
          value: _selectedCrop,
          items: _crops,
          icon: Icons.grass_rounded,
          onChanged: (v) => setState(() => _selectedCrop = v!),
        ),
        const SizedBox(height: 16),

        // Region
        _fieldLabel('Region'),
        const SizedBox(height: 6),
        _dropdownField(
          value: _selectedRegion,
          items: _regions,
          icon: Icons.location_on_rounded,
          onChanged: (v) => setState(() => _selectedRegion = v!),
        ),
        const SizedBox(height: 28),

        // Buttons row
        Row(children: [
          // Cancel
          Expanded(
            child: OutlinedButton(
              onPressed: _cancelEdit,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textMid,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Cancel',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ),
          ),
          const SizedBox(width: 12),
          // Save
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveProfile,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.save_rounded, size: 18),
              label: Text(
                _isSaving ? 'Saving...' : 'Save Changes',
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
            ),
          ),
        ]),
      ]),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // RECENT ACTIVITY - FULLY WORKING VERSION
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildActivity() {
    if (_isLoadingActivities) {
      return _card('Recent Activity', [
        const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Loading activities...',
                  style: TextStyle(color: AppColors.textLight, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ]);
    }

    if (_activities.isEmpty) {
      return _card('Recent Activity', [
        const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.inbox_rounded, color: AppColors.textLight, size: 48),
                SizedBox(height: 12),
                Text(
                  'No recent activities',
                  style: TextStyle(color: AppColors.textLight, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Your activities will appear here',
                  style: TextStyle(color: AppColors.textLight, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ]);
    }

    return _card('Recent Activity', [
      ..._activities.map((activity) {
        return Column(
          children: [
            InkWell(
              onTap: () => _handleActivityTap(activity),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Activity Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (activity['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          activity['icon'] as String,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Activity Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['title'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity['subtitle'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMid,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 12,
                                color: AppColors.textLight,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                activity['time'] as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Chevron icon
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textLight,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            if (activity != _activities.last) _divider(),
          ],
        );
      }).toList(),

      // View All Button
      Padding(
        padding: const EdgeInsets.all(12),
        child: TextButton(
          onPressed: () {
            _snack('View all activities - Coming soon');
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('View All Activities'),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_rounded, size: 16),
            ],
          ),
        ),
      ),
    ]);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // ACCOUNT MENU
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildAccountMenu() {
    return _card('Account', [
      _menuRow(Icons.settings_outlined, 'Settings',
          () => _snack('Settings coming soon')),
      _divider(),
      _menuRow(Icons.history_rounded, 'Transaction History',
          () => _snack('Transaction History coming soon')),
      _divider(),
      _menuRow(Icons.star_outline_rounded, 'My Reviews',
          () => _snack('My Reviews coming soon')),
      _divider(),
      _menuRow(Icons.help_outline_rounded, 'Help & Support',
          () => _snack('Help coming soon')),
      _divider(),
      _menuRow(Icons.privacy_tip_outlined, 'Privacy Policy',
          () => _snack('Privacy Policy coming soon')),
    ]);
  }

  // ════════════════════════════════════════════════════════════════════════════
  // LOGOUT BUTTON
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
          label: const Text('Logout',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                  fontSize: 15)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red, width: 1.5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // SHARED CARD WRAPPER
  // ════════════════════════════════════════════════════════════════════════════

  Widget _card(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: _cardHeader(title),
        ),
        const Divider(height: 1, color: AppColors.divider),
        ...children,
      ]),
    );
  }

  Widget _cardHeader(String title) => Row(children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: AppColors.primaryDark,
                letterSpacing: -0.2)),
      ]);

  // ════════════════════════════════════════════════════════════════════════════
  // ROW WIDGETS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Text(label,
            style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
        const Spacer(),
        Flexible(
          child: Text(value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textDark)),
        ),
      ]),
    );
  }

  Widget _menuRow(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark)),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
              color: AppColors.textLight, size: 13),
        ]),
      ),
    );
  }

  Widget _divider() => const Divider(
      height: 1, indent: 16, endIndent: 16, color: AppColors.divider);

  // ════════════════════════════════════════════════════════════════════════════
  // FORM HELPERS
  // ════════════════════════════════════════════════════════════════════════════

  Widget _fieldLabel(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark));

  Widget _textField(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    TextInputType? keyboardType,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
          prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              icon: const Icon(Icons.expand_more_rounded,
                  color: AppColors.primary, size: 20),
              onChanged: onChanged,
              items: items
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
            ),
          ),
        ),
      ]),
    );
  }
}
