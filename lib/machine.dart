import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── APP COLORS ───────────────────────────────────────────────────────────────
class AppColors {
  static const Color primary = Color(0xFF1B5E20);
  static const Color primaryMid = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF43A047);
  static const Color gold = Color(0xFFF9A825);
  static const Color goldDark = Color(0xFFF57F17);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFE65100);
  static const Color surface = Color(0xFFF0EDE6);
  static const Color card = Colors.white;
  static const Color divider = Color(0xFFEEEBE4);
  static const Color textDark = Color(0xFF1A202C);
  static const Color textMid = Color(0xFF4A5568);
  static const Color textLight = Color(0xFF718096);
  static const Color textHint = Color(0xFFA0AEC0);
}

// ─── BOOKING MODEL ────────────────────────────────────────────────────────────
class Booking {
  final String id;
  final int machineId;
  final String machineName;
  final String machineImage;
  final DateTime bookingDate;
  final DateTime startDate;
  final DateTime? endDate;
  final int? days;
  final int? hours;
  final int totalCost;
  final String status; // 'active', 'completed', 'cancelled'

  Booking({
    required this.id,
    required this.machineId,
    required this.machineName,
    required this.machineImage,
    required this.bookingDate,
    required this.startDate,
    this.endDate,
    this.days,
    this.hours,
    required this.totalCost,
    this.status = 'active',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'machineId': machineId,
        'machineName': machineName,
        'machineImage': machineImage,
        'bookingDate': bookingDate.toIso8601String(),
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
        'days': days,
        'hours': hours,
        'totalCost': totalCost,
        'status': status,
      };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        machineId: json['machineId'],
        machineName: json['machineName'],
        machineImage: json['machineImage'],
        bookingDate: DateTime.parse(json['bookingDate']),
        startDate: DateTime.parse(json['startDate']),
        endDate:
            json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
        days: json['days'],
        hours: json['hours'],
        totalCost: json['totalCost'],
        status: json['status'],
      );
}

// ─── BOOKING STORE (SINGLETON) ────────────────────────────────────────────────
class BookingStore {
  BookingStore._();
  static final BookingStore instance = BookingStore._();

  final ValueNotifier<List<Booking>> bookings =
      ValueNotifier<List<Booking>>([]);

  void addBooking(Booking booking) {
    bookings.value = [...bookings.value, booking];
  }

  Future<bool> cancelBooking(String bookingId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final booking = bookings.value.firstWhere((b) => b.id == bookingId);
    if (booking.status == 'active') {
      bookings.value = bookings.value.map((b) {
        if (b.id == bookingId) {
          return Booking(
            id: b.id,
            machineId: b.machineId,
            machineName: b.machineName,
            machineImage: b.machineImage,
            bookingDate: b.bookingDate,
            startDate: b.startDate,
            endDate: b.endDate,
            days: b.days,
            hours: b.hours,
            totalCost: b.totalCost,
            status: 'cancelled',
          );
        }
        return b;
      }).toList();
      return true;
    }
    return false;
  }

  List<Booking> getActiveBookings() {
    return bookings.value.where((b) => b.status == 'active').toList();
  }

  void clearAll() {
    bookings.value = [];
  }
}

// ─── MACHINE STORE ────────────────────────────────────────────────────────────
class MachineStore {
  MachineStore._();
  static final MachineStore instance = MachineStore._();
  int _nextId = 200;

  final ValueNotifier<List<Map<String, dynamic>>> machines =
      ValueNotifier(_defaultMachines());

  void addMachine(Map<String, dynamic> m) {
    final machine = Map<String, dynamic>.from(m);
    machine['id'] = _nextId++;
    machine['isOwn'] = true;
    machines.value = [machine, ...machines.value];
  }

  void deleteMachine(int id) {
    machines.value = machines.value.where((m) => m['id'] != id).toList();
  }

  void updateMachineAvailability(int id, String availability) {
    machines.value = machines.value.map((m) {
      if (m['id'] == id) {
        m['availability'] = availability;
      }
      return m;
    }).toList();
  }

  static List<Map<String, dynamic>> _defaultMachines() => [
        {
          'id': 101,
          'name': 'John Deere Tractor 5075E',
          'type': 'Tractor',
          'icon': Icons.agriculture_rounded,
          'color': Color(0xFF1B6B3A),
          'owner': 'Ranjith Perera',
          'ownerPhoto': 'https://i.pravatar.cc/96?img=11',
          'loc': 'Polonnaruwa',
          'rateDay': 8500,
          'rateHour': 1200,
          'availability': 'Available',
          'rating': 4.8,
          'reviews': 34,
          'hp': '75 HP',
          'year': '2021',
          'desc':
              'Well-maintained tractor suitable for ploughing, tilling and transport. Comes with experienced operator. Fuel included for day hire.',
          'images': [
            'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?w=800&q=80',
            'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?w=800&q=80',
          ],
          'isOwn': false,
        },
        {
          'id': 102,
          'name': 'Kubota DC-70 Harvester',
          'type': 'Harvester',
          'icon': Icons.agriculture_rounded,
          'color': Color(0xFFB7791F),
          'owner': 'Kamal Silva',
          'ownerPhoto': 'https://i.pravatar.cc/96?img=33',
          'loc': 'Kurunegala',
          'rateDay': 15000,
          'rateHour': 2000,
          'availability': 'Booked',
          'rating': 4.6,
          'reviews': 21,
          'hp': '70 HP',
          'year': '2020',
          'desc':
              'Paddy harvester with 1.5m cutting width. Ideal for large paddy fields. Operator included.',
          'images': [
            'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=800&q=80',
          ],
          'isOwn': false,
        },
        {
          'id': 103,
          'name': 'Power Tiller (2-wheel)',
          'type': 'Tiller',
          'icon': Icons.agriculture_rounded,
          'color': Color(0xFF2B6CB0),
          'owner': 'Nimal Fernando',
          'ownerPhoto': 'https://i.pravatar.cc/96?img=52',
          'loc': 'Anuradhapura',
          'rateDay': 3500,
          'rateHour': 500,
          'availability': 'Available',
          'rating': 4.4,
          'reviews': 58,
          'hp': '12 HP',
          'year': '2022',
          'desc':
              'Compact 2-wheel tractor ideal for small to medium paddy and vegetable fields.',
          'images': [
            'https://images.unsplash.com/photo-1592982537447-7440770cbfc9?w=800&q=80',
          ],
          'isOwn': false,
        },
        {
          'id': 104,
          'name': 'Boom Sprayer (500L)',
          'type': 'Sprayer',
          'icon': Icons.water_drop_rounded,
          'color': Color(0xFFC53030),
          'owner': 'Sunil Bandara',
          'ownerPhoto': 'https://i.pravatar.cc/96?img=7',
          'loc': 'Kandy',
          'rateDay': 4500,
          'rateHour': 700,
          'availability': 'Booked',
          'rating': 4.2,
          'reviews': 15,
          'hp': '—',
          'year': '2023',
          'desc':
              'Tractor-mounted boom sprayer for large-scale pesticide and fertilizer application.',
          'images': [
            'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=800&q=80',
          ],
          'isOwn': false,
        },
        {
          'id': 105,
          'name': 'Seed Drill Machine',
          'type': 'Seeder',
          'icon': Icons.grass_rounded,
          'color': Color(0xFF6B46C1),
          'owner': 'Priya Kumari',
          'ownerPhoto': 'https://i.pravatar.cc/96?img=47',
          'loc': 'Badulla',
          'rateDay': 5000,
          'rateHour': 750,
          'availability': 'Available',
          'rating': 4.7,
          'reviews': 9,
          'hp': '—',
          'year': '2022',
          'desc':
              'Precision seed drill for corn, paddy and vegetables. Reduces seed waste by up to 40%.',
          'images': [
            'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=800&q=80',
          ],
          'isOwn': false,
        },
        {
          'id': 106,
          'name': 'Mini Excavator (1.5T)',
          'type': 'Excavator',
          'icon': Icons.construction_rounded,
          'color': Color(0xFFC05621),
          'owner': 'Chaminda Jayawardena',
          'ownerPhoto': 'https://i.pravatar.cc/96?img=68',
          'loc': 'Gampaha',
          'rateDay': 20000,
          'rateHour': 3000,
          'availability': 'Available',
          'rating': 4.9,
          'reviews': 7,
          'hp': '25 HP',
          'year': '2021',
          'desc':
              'Mini excavator ideal for irrigation channel digging, land clearing and pond construction.',
          'images': [
            'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&q=80',
          ],
          'isOwn': false,
        },
      ];
}

// ─── MY BOOKINGS SCREEN (NEW) ─────────────────────────────────────────────────
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    BookingStore.instance.bookings.addListener(_refresh);
  }

  @override
  void dispose() {
    BookingStore.instance.bookings.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  Future<void> _returnMachine(Booking booking) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Return Machine?'),
        content: Text(
          'Are you sure you want to return "${booking.machineName}"?\n\n'
          'This will cancel your booking and the machine will become available for others.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No, Keep It'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Return'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Show loading
    setState(() {});

    try {
      final success = await BookingStore.instance.cancelBooking(booking.id);

      if (success) {
        // Update machine availability
        MachineStore.instance
            .updateMachineAvailability(booking.machineId, 'Available');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Booking cancelled successfully! Machine returned.'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _fmtCost(int val) => val
      .toString()
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final activeBookings = BookingStore.instance.getActiveBookings();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Bookings',
            style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: activeBookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.agriculture_rounded,
                      size: 80, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  const Text(
                    'No Active Bookings',
                    style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You haven\'t booked any machines yet',
                    style: TextStyle(color: AppColors.textLight),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryMid,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Browse Machines'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activeBookings.length,
              itemBuilder: (context, index) {
                final booking = activeBookings[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      // Machine image and name
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          image: booking.machineImage.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(booking.machineImage),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: AppColors.primaryLight.withOpacity(0.1),
                        ),
                        child: booking.machineImage.isEmpty
                            ? Center(
                                child: Icon(Icons.agriculture_rounded,
                                    size: 48, color: AppColors.primaryLight),
                              )
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    booking.machineName,
                                    style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: booking.status == 'active'
                                        ? AppColors.success.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    booking.status.toUpperCase(),
                                    style: TextStyle(
                                      color: booking.status == 'active'
                                          ? AppColors.success
                                          : Colors.red,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _infoRow(
                                Icons.calendar_today_rounded,
                                'Booking Date',
                                _formatDate(booking.bookingDate)),
                            const SizedBox(height: 8),
                            _infoRow(Icons.event_rounded, 'Start Date',
                                _formatDate(booking.startDate)),
                            if (booking.endDate != null) ...[
                              const SizedBox(height: 8),
                              _infoRow(Icons.event_busy_rounded, 'End Date',
                                  _formatDate(booking.endDate!)),
                            ],
                            const SizedBox(height: 8),
                            _infoRow(
                              Icons.access_time_rounded,
                              'Duration',
                              booking.hours != null
                                  ? '${booking.hours} hours'
                                  : '${booking.days} days',
                            ),
                            const SizedBox(height: 8),
                            _infoRow(
                              Icons.currency_rupee_rounded,
                              'Total Paid',
                              'Rs. ${_fmtCost(booking.totalCost)}',
                              isHighlight: true,
                            ),
                            const SizedBox(height: 20),

                            // ✅ RETURN BUTTON
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => _returnMachine(booking),
                                icon: const Icon(Icons.undo_rounded, size: 18),
                                label: const Text(
                                    'RETURN MACHINE / CANCEL BOOKING'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value,
      {bool isHighlight = false}) {
    return Row(
      children: [
        Icon(icon,
            size: 16,
            color: isHighlight ? AppColors.primaryMid : AppColors.textLight),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isHighlight ? AppColors.textDark : AppColors.textLight,
            fontSize: 13,
            fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? AppColors.primaryMid : AppColors.textDark,
            fontSize: 13,
            fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ─── MACHINE HIRING SCREEN ────────────────────────────────────────────────────
class MachineHiringScreen extends StatefulWidget {
  const MachineHiringScreen({super.key});

  @override
  State<MachineHiringScreen> createState() => _MachineHiringScreenState();
}

class _MachineHiringScreenState extends State<MachineHiringScreen> {
  int _selectedType = 0;
  final List<String> _types = [
    'All',
    'Tractor',
    'Harvester',
    'Tiller',
    'Sprayer',
    'Seeder',
    'Excavator'
  ];

  @override
  void initState() {
    super.initState();
    MachineStore.instance.machines.addListener(_refresh);
  }

  @override
  void dispose() {
    MachineStore.instance.machines.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  List<Map<String, dynamic>> get _filtered {
    final all = MachineStore.instance.machines.value;
    if (_selectedType == 0) return all;
    return all.where((m) => m['type'] == _types[_selectedType]).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final total = MachineStore.instance.machines.value.length;
    final available = MachineStore.instance.machines.value
        .where((m) => m['availability'] == 'Available')
        .length;
    final activeBookingsCount =
        BookingStore.instance.getActiveBookings().length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────
          Container(
            color: AppColors.primary,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Machine Hiring',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.3)),
                              const SizedBox(height: 2),
                              Text('Rent farm machinery near you',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 13)),
                            ]),
                        const Spacer(),
                        // My Bookings Button
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MyBookingsScreen()),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.bookmark_rounded,
                                    color: Colors.white, size: 22),
                              ),
                            ),
                            if (activeBookingsCount > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.gold,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '$activeBookingsCount',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const AddMachineSheet(),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(children: [
                              Icon(Icons.add_rounded,
                                  color: AppColors.primary, size: 17),
                              SizedBox(width: 5),
                              Text('List Machine',
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13)),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      _headerStat('$total', 'Listed'),
                      _headerDivider(),
                      _headerStat('$available', 'Available'),
                      _headerDivider(),
                      _headerStat('25', 'Districts'),
                    ]),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemCount: _types.length,
                      itemBuilder: (_, i) {
                        final sel = _selectedType == i;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedType = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.gold
                                  : Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: sel
                                    ? AppColors.gold
                                    : Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Text(_types[i],
                                style: TextStyle(
                                  color: sel ? AppColors.primary : Colors.white,
                                  fontWeight:
                                      sel ? FontWeight.w800 : FontWeight.w500,
                                  fontSize: 13,
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── List ────────────────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.agriculture_rounded,
                              size: 64, color: AppColors.textHint),
                          const SizedBox(height: 12),
                          const Text('No machines found',
                              style: TextStyle(
                                  color: AppColors.textLight,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          const Text('Try a different category',
                              style: TextStyle(
                                  color: AppColors.textHint, fontSize: 13)),
                        ]),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final m = filtered[i];
                      return MachineCard(
                        machine: m,
                        onTap: () => Navigator.push(
                          ctx,
                          MaterialPageRoute(
                              builder: (_) => MachineDetailScreen(machine: m)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String val, String label) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(val,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900)),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.55), fontSize: 11)),
        ],
      );

  Widget _headerDivider() => Container(
        width: 1,
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.white.withOpacity(0.2),
      );
}

// ─── MACHINE CARD ─────────────────────────────────────────────────────────────
class MachineCard extends StatelessWidget {
  final Map<String, dynamic> machine;
  final VoidCallback onTap;
  const MachineCard({super.key, required this.machine, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final m = machine;
    final color = m['color'] as Color;
    final avail = (m['availability'] ?? 'Available') as String;
    final isAvail = avail == 'Available';
    final images = (m['images'] as List?)?.cast<String>() ?? [];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero image ──────────────────────────────────────
            Stack(
              children: [
                SizedBox(
                  height: 168,
                  width: double.infinity,
                  child: images.isNotEmpty
                      ? Image.network(images.first,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) =>
                              progress == null ? child : _placeholder(color, m),
                          errorBuilder: (_, __, ___) => _placeholder(color, m))
                      : _placeholder(color, m),
                ),
                // Gradient scrim at bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.45),
                          Colors.transparent
                        ],
                      ),
                    ),
                  ),
                ),
                // Type badge top-left
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(m['type'] as String,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                // Availability badge top-right
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isAvail
                          ? AppColors.success.withOpacity(0.9)
                          : AppColors.warning.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                      Text(avail,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),
                // Rating bottom-left on image
                Positioned(
                  bottom: 10,
                  left: 12,
                  child: m['rating'] != null
                      ? Row(children: [
                          const Icon(Icons.star_rounded,
                              size: 13, color: AppColors.gold),
                          const SizedBox(width: 3),
                          Text('${m['rating']} (${m['reviews']})',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ])
                      : const SizedBox(),
                ),
              ],
            ),

            // ── Card body ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Owner row
                  Row(children: [
                    _ownerAvatar(m, color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text((m['owner'] ?? '') as String,
                                style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis),
                            Row(children: [
                              const Icon(Icons.location_on_rounded,
                                  size: 11, color: AppColors.textLight),
                              const SizedBox(width: 2),
                              Text((m['loc'] ?? '') as String,
                                  style: const TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 11)),
                            ]),
                          ]),
                    ),
                    if ((m['hp'] ?? '—') != '—')
                      _specChip(Icons.bolt_rounded, m['hp'] as String, color),
                  ]),
                  const SizedBox(height: 10),
                  Text(m['name'] as String,
                      style: const TextStyle(
                          color: AppColors.textDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(
                      (m['desc'] as String).length > 75
                          ? '${(m['desc'] as String).substring(0, 75)}…'
                          : m['desc'] as String,
                      style: const TextStyle(
                          color: AppColors.textLight,
                          fontSize: 12,
                          height: 1.5)),
                  const SizedBox(height: 12),
                  Container(height: 0.5, color: AppColors.divider),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Rs. ${_fmt(m['rateDay'] as int)}',
                                style: const TextStyle(
                                    color: AppColors.primaryMid,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5)),
                            Text(
                                'per day  ·  Rs. ${_fmt(m['rateHour'] as int)}/hr',
                                style: const TextStyle(
                                    color: AppColors.textHint, fontSize: 11)),
                          ]),
                      const Spacer(),
                      GestureDetector(
                        onTap: isAvail ? onTap : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 11),
                          decoration: BoxDecoration(
                            color: isAvail
                                ? AppColors.primaryMid
                                : AppColors.divider,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isAvail ? 'Book Now' : 'Booked',
                            style: TextStyle(
                              color:
                                  isAvail ? Colors.white : AppColors.textLight,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(Color color, Map<String, dynamic> m) => Container(
        color: color.withOpacity(0.1),
        child: Center(
            child: Icon(m['icon'] as IconData,
                color: color.withOpacity(0.4), size: 64)),
      );

  Widget _ownerAvatar(Map<String, dynamic> m, Color color) {
    final photo = m['ownerPhoto'] as String?;
    final initials = ((m['owner'] ?? 'O') as String)
        .split(' ')
        .map((w) => w[0])
        .take(2)
        .join()
        .toUpperCase();
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: photo != null
          ? Image.network(photo,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _initialsAvatar(initials, color))
          : _initialsAvatar(initials, color),
    );
  }

  Widget _initialsAvatar(String initials, Color color) => Container(
        color: color.withOpacity(0.12),
        child: Center(
            child: Text(initials,
                style: TextStyle(
                    color: color, fontSize: 11, fontWeight: FontWeight.w800))),
      );

  Widget _specChip(IconData icon, String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        ]),
      );

  String _fmt(int val) {
    if (val >= 1000) {
      return val
          .toString()
          .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    }
    return val.toString();
  }
}

// ─── MACHINE DETAIL SCREEN ────────────────────────────────────────────────────
class MachineDetailScreen extends StatefulWidget {
  final Map<String, dynamic> machine;
  const MachineDetailScreen({super.key, required this.machine});

  @override
  State<MachineDetailScreen> createState() => _MachineDetailScreenState();
}

class _MachineDetailScreenState extends State<MachineDetailScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;
  int _days = 1;
  bool _byHour = false;
  int _hours = 4;
  int _photoIndex = 0;
  late final PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  int get _totalCost => _byHour
      ? (widget.machine['rateHour'] as int) * _hours
      : (widget.machine['rateDay'] as int) * _days;

  Future<void> _pickDate(bool isFrom) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          isFrom ? now : (_fromDate ?? now).add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
              primary: AppColors.primaryMid, onPrimary: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          _toDate = null;
        } else {
          _toDate = picked;
          if (_fromDate != null) {
            _days = _toDate!.difference(_fromDate!).inDays.clamp(1, 365);
          }
        }
      });
    }
  }

  String _fmt(DateTime? d) =>
      d == null ? 'Select date' : '${d.day}/${d.month}/${d.year}';

  String _fmtCost(int val) => val
      .toString()
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');

  @override
  Widget build(BuildContext context) {
    final m = widget.machine;
    final color = m['color'] as Color;
    final icon = m['icon'] as IconData;
    final avail = (m['availability'] ?? 'Available') as String;
    final isAvail = avail == 'Available';
    final images = (m['images'] as List?)?.cast<String>() ?? [];

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Photo gallery app bar ──────────────────────────
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      images.isNotEmpty
                          ? PageView.builder(
                              controller: _pageCtrl,
                              itemCount: images.length,
                              onPageChanged: (i) =>
                                  setState(() => _photoIndex = i),
                              itemBuilder: (_, i) => Image.network(
                                images[i],
                                fit: BoxFit.cover,
                                loadingBuilder: (_, child, progress) =>
                                    progress == null
                                        ? child
                                        : Container(
                                            color: color.withOpacity(0.2),
                                            child: Center(
                                                child: Icon(icon,
                                                    size: 64,
                                                    color: color
                                                        .withOpacity(0.3)))),
                                errorBuilder: (_, __, ___) => Container(
                                  color: color.withOpacity(0.15),
                                  child: Center(
                                      child: Icon(icon,
                                          size: 64,
                                          color: color.withOpacity(0.4))),
                                ),
                              ),
                            )
                          : Container(
                              color: color.withOpacity(0.15),
                              child: Center(
                                  child: Icon(icon,
                                      size: 80, color: color.withOpacity(0.4))),
                            ),
                      // Bottom scrim
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.55),
                                Colors.transparent
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Dot indicators
                      if (images.length > 1)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                images.length,
                                (i) => AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 220),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      width: _photoIndex == i ? 20 : 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: _photoIndex == i
                                            ? Colors.white
                                            : Colors.white.withOpacity(0.45),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    )),
                          ),
                        ),
                      // Availability chip
                      Positioned(
                        bottom: 28,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isAvail
                                ? AppColors.success.withOpacity(0.9)
                                : AppColors.warning.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle)),
                            Text(avail,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  if (m['isOwn'] == true)
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: () {
                        MachineStore.instance.deleteMachine(m['id'] as int);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Listing removed'),
                              backgroundColor: Colors.red),
                        );
                      },
                    ),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + type
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(m['name'] as String,
                                  style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.4)),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: color.withOpacity(0.25)),
                              ),
                              child: Text(m['type'] as String,
                                  style: TextStyle(
                                      color: color,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800)),
                            ),
                          ]),
                      const SizedBox(height: 6),
                      if (m['rating'] != null)
                        Row(children: [
                          ...List.generate(
                              5,
                              (i) => Icon(
                                    i < (m['rating'] as double).floor()
                                        ? Icons.star_rounded
                                        : (i < (m['rating'] as double)
                                            ? Icons.star_half_rounded
                                            : Icons.star_outline_rounded),
                                    size: 16,
                                    color: AppColors.gold,
                                  )),
                          const SizedBox(width: 6),
                          Text('${m['rating']} · ${m['reviews']} reviews',
                              style: const TextStyle(
                                  color: AppColors.textMid, fontSize: 13)),
                        ]),

                      const SizedBox(height: 20),

                      // Spec row
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            _specItem(Icons.bolt_rounded,
                                (m['hp'] ?? '—') as String, 'Power', color),
                            _vDivider(),
                            _specItem(Icons.calendar_today_rounded,
                                (m['year'] ?? '—') as String, 'Year', color),
                            _vDivider(),
                            _specItem(Icons.location_on_rounded,
                                (m['loc'] ?? '') as String, 'Location', color),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Owner card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(children: [
                          _buildOwnerAvatar(m, color),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text((m['owner'] ?? '') as String,
                                    style: const TextStyle(
                                        color: AppColors.textDark,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14)),
                                Row(children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 12, color: AppColors.textLight),
                                  const SizedBox(width: 3),
                                  Text('${m['loc']}',
                                      style: const TextStyle(
                                          color: AppColors.textLight,
                                          fontSize: 12)),
                                ]),
                              ])),
                          _actionChip(Icons.phone_outlined, 'Call', color),
                          const SizedBox(width: 8),
                          _actionChip(
                              Icons.chat_bubble_outline_rounded, 'Chat', color),
                        ]),
                      ),

                      const SizedBox(height: 20),

                      // Description
                      const Text('About this machine',
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text((m['desc'] ?? '') as String,
                          style: const TextStyle(
                              color: AppColors.textMid,
                              fontSize: 14,
                              height: 1.65)),

                      const SizedBox(height: 24),

                      // Booking section
                      const Text('Booking',
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 14),

                      // Day / Hour toggle
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(children: [
                          Expanded(
                              child: _rateTab('By Day', !_byHour,
                                  () => setState(() => _byHour = false))),
                          Expanded(
                              child: _rateTab('By Hour', _byHour,
                                  () => setState(() => _byHour = true))),
                        ]),
                      ),
                      const SizedBox(height: 16),

                      if (!_byHour) ...[
                        Row(children: [
                          Expanded(
                              child: _datePicker(
                                  'From', _fromDate, () => _pickDate(true))),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _datePicker(
                                  'To', _toDate, () => _pickDate(false))),
                        ]),
                        const SizedBox(height: 12),
                        _stepperRow(
                          label: 'Days',
                          value: _days,
                          onDec: () => setState(() {
                            if (_days > 1) _days--;
                          }),
                          onInc: () => setState(() => _days++),
                        ),
                      ] else ...[
                        _stepperRow(
                          label: 'Hours',
                          value: _hours,
                          onDec: () => setState(() {
                            if (_hours > 1) _hours--;
                          }),
                          onInc: () => setState(() => _hours++),
                        ),
                      ],

                      const SizedBox(height: 14),

                      // Cost summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryMid.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: AppColors.primaryMid.withOpacity(0.18)),
                        ),
                        child: Column(children: [
                          _costRow(
                              _byHour ? 'Rate' : 'Daily rate',
                              'Rs. ${_fmtCost(_byHour ? m['rateHour'] as int : m['rateDay'] as int)} / ${_byHour ? 'hour' : 'day'}',
                              false),
                          const SizedBox(height: 8),
                          _costRow(_byHour ? 'Hours' : 'Days',
                              _byHour ? '$_hours hrs' : '$_days days', false),
                          const SizedBox(height: 8),
                          _costRow('Platform fee', 'Rs. 200', false),
                          Container(
                              height: 0.5,
                              color: AppColors.divider,
                              margin: const EdgeInsets.symmetric(vertical: 10)),
                          _costRow('Total cost',
                              'Rs. ${_fmtCost(_totalCost + 200)}', true),
                        ]),
                      ),

                      const SizedBox(height: 110),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Bottom CTA bar ────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: AppColors.divider, width: 0.5)),
              ),
              child: Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Rs. ${_fmtCost(_totalCost + 200)}',
                      style: const TextStyle(
                          color: AppColors.primaryMid,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                  Text(
                      _byHour
                          ? 'for $_hours hours'
                          : 'for $_days day${_days > 1 ? 's' : ''}',
                      style: const TextStyle(
                          color: AppColors.textHint, fontSize: 12)),
                ]),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: isAvail
                        ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentScreen(
                                  machine: widget.machine,
                                  days: _byHour ? null : _days,
                                  hours: _byHour ? _hours : null,
                                  totalCost: _totalCost + 200,
                                  fromDate: _fromDate,
                                  toDate: _toDate,
                                ),
                              ),
                            )
                        : null,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: isAvail ? AppColors.gold : AppColors.divider,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          isAvail ? 'Proceed to Payment' : 'Currently Booked',
                          style: TextStyle(
                            color: isAvail
                                ? AppColors.primary
                                : AppColors.textLight,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _specItem(IconData icon, String val, String label, Color color) =>
      Expanded(
        child: Column(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: color.withOpacity(0.08), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 6),
          Text(val,
              style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 13),
              overflow: TextOverflow.ellipsis),
          Text(label,
              style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
        ]),
      );

  Widget _vDivider() =>
      Container(width: 0.5, height: 48, color: AppColors.divider);

  Widget _buildOwnerAvatar(Map<String, dynamic> m, Color color) {
    final photo = m['ownerPhoto'] as String?;
    final initials = ((m['owner'] ?? 'O') as String)
        .split(' ')
        .map((w) => w[0])
        .take(2)
        .join()
        .toUpperCase();
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3), width: 2)),
      clipBehavior: Clip.hardEdge,
      child: photo != null
          ? Image.network(photo,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _initials(initials, color))
          : _initials(initials, color),
    );
  }

  Widget _initials(String t, Color color) => Container(
        color: color.withOpacity(0.1),
        child: Center(
            child: Text(t,
                style: TextStyle(
                    color: color, fontSize: 14, fontWeight: FontWeight.w900))),
      );

  Widget _actionChip(IconData icon, String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
      );

  Widget _rateTab(String label, bool active, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: active
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06), blurRadius: 8)
                  ]
                : [],
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                  color: active ? AppColors.primaryMid : AppColors.textLight,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                  fontSize: 14,
                )),
          ),
        ),
      );

  Widget _datePicker(String label, DateTime? date, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: date != null ? AppColors.primaryMid : AppColors.divider,
              width: date != null ? 1.5 : 0.5,
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style:
                    const TextStyle(color: AppColors.textHint, fontSize: 11)),
            const SizedBox(height: 5),
            Row(children: [
              Icon(Icons.calendar_today_rounded,
                  size: 13,
                  color: date != null
                      ? AppColors.primaryMid
                      : AppColors.textLight),
              const SizedBox(width: 6),
              Text(_fmt(date),
                  style: TextStyle(
                    color:
                        date != null ? AppColors.textDark : AppColors.textHint,
                    fontWeight:
                        date != null ? FontWeight.w700 : FontWeight.normal,
                    fontSize: 13,
                  )),
            ]),
          ]),
        ),
      );

  Widget _stepperRow(
          {required String label,
          required int value,
          required VoidCallback onDec,
          required VoidCallback onInc}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              InkWell(
                onTap: onDec,
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Icon(Icons.remove_rounded,
                        size: 16, color: AppColors.textDark)),
              ),
              SizedBox(
                width: 36,
                child: Center(
                  child: Text('$value',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDark)),
                ),
              ),
              InkWell(
                onTap: onInc,
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Icon(Icons.add_rounded,
                        size: 16, color: AppColors.textDark)),
              ),
            ]),
          ),
        ]),
      );

  Widget _costRow(String label, String value, bool isTotal) => Row(children: [
        Text(label,
            style: TextStyle(
              color: isTotal ? AppColors.textDark : AppColors.textLight,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.normal,
              fontSize: isTotal ? 15 : 13,
            )),
        const Spacer(),
        Text(value,
            style: TextStyle(
              color: isTotal ? AppColors.primaryMid : AppColors.textDark,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
              fontSize: isTotal ? 20 : 13,
            )),
      ]);
}

// ─── PAYMENT SCREEN (MODIFIED TO ADD BOOKING) ─────────────────────────────────
class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> machine;
  final int? days;
  final int? hours;
  final int totalCost;
  final DateTime? fromDate;
  final DateTime? toDate;

  const PaymentScreen({
    super.key,
    required this.machine,
    required this.totalCost,
    this.days,
    this.hours,
    this.fromDate,
    this.toDate,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedMethod = 0;
  bool _processing = false;
  bool _paid = false;

  final List<Map<String, dynamic>> _methods = [
    {
      'label': 'Credit / Debit Card',
      'icon': Icons.credit_card_rounded,
      'sub': 'Visa, Mastercard, Amex'
    },
    {
      'label': 'Bank Transfer',
      'icon': Icons.account_balance_rounded,
      'sub': 'Direct bank payment'
    },
    {
      'label': 'Cash on Arrival',
      'icon': Icons.payments_rounded,
      'sub': 'Pay when machine arrives'
    },
    {
      'label': 'Mobile Wallet',
      'icon': Icons.phone_android_rounded,
      'sub': 'FriMi, eZ Cash, mCash'
    },
  ];

  // Card form
  final _cardNum = TextEditingController();
  final _cardName = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();

  @override
  void dispose() {
    _cardNum.dispose();
    _cardName.dispose();
    _expiry.dispose();
    _cvv.dispose();
    super.dispose();
  }

  String _fmtCost(int val) => val
      .toString()
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');

  String _fmt(DateTime? d) => d == null ? '—' : '${d.day}/${d.month}/${d.year}';

  Future<void> _pay() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2));

    // Create booking after successful payment
    final booking = Booking(
      id: 'BK${DateTime.now().millisecondsSinceEpoch}',
      machineId: widget.machine['id'],
      machineName: widget.machine['name'],
      machineImage: (widget.machine['images'] as List?)?.isNotEmpty == true
          ? (widget.machine['images'] as List).first as String
          : '',
      bookingDate: DateTime.now(),
      startDate: widget.fromDate ?? DateTime.now(),
      endDate: widget.toDate,
      days: widget.days,
      hours: widget.hours,
      totalCost: widget.totalCost,
      status: 'active',
    );

    BookingStore.instance.addBooking(booking);

    // Update machine availability
    MachineStore.instance
        .updateMachineAvailability(widget.machine['id'], 'Booked');

    setState(() {
      _processing = false;
      _paid = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_paid) return _buildSuccessScreen();

    final m = widget.machine;
    final color = m['color'] as Color;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Payment',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Order summary strip
          Container(
            color: AppColors.primary,
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22)),
              ),
              child: const SizedBox(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order summary card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(children: [
                      Row(children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: (m['images'] as List?)?.isNotEmpty == true
                              ? Image.network(
                                  (m['images'] as List).first as String,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                      m['icon'] as IconData,
                                      color: color,
                                      size: 26))
                              : Icon(m['icon'] as IconData,
                                  color: color, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(m['name'] as String,
                                  style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 3),
                              Row(children: [
                                const Icon(Icons.location_on_rounded,
                                    size: 11, color: AppColors.textLight),
                                const SizedBox(width: 2),
                                Text((m['loc'] ?? '') as String,
                                    style: const TextStyle(
                                        color: AppColors.textLight,
                                        fontSize: 12)),
                              ]),
                            ])),
                      ]),
                      Container(
                          height: 0.5,
                          color: AppColors.divider,
                          margin: const EdgeInsets.symmetric(vertical: 14)),
                      _summaryRow(
                          'Duration',
                          widget.hours != null
                              ? '${widget.hours} hours'
                              : '${widget.days} day${(widget.days ?? 1) > 1 ? 's' : ''}'),
                      if (widget.fromDate != null) ...[
                        const SizedBox(height: 7),
                        _summaryRow('Start date', _fmt(widget.fromDate)),
                      ],
                      if (widget.toDate != null) ...[
                        const SizedBox(height: 7),
                        _summaryRow('End date', _fmt(widget.toDate)),
                      ],
                      const SizedBox(height: 7),
                      _summaryRow('Machine hire',
                          'Rs. ${_fmtCost(widget.totalCost - 200)}'),
                      const SizedBox(height: 7),
                      _summaryRow('Platform fee', 'Rs. 200'),
                      Container(
                          height: 0.5,
                          color: AppColors.divider,
                          margin: const EdgeInsets.symmetric(vertical: 12)),
                      Row(children: [
                        const Text('Total amount',
                            style: TextStyle(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w800,
                                fontSize: 15)),
                        const Spacer(),
                        Text('Rs. ${_fmtCost(widget.totalCost)}',
                            style: const TextStyle(
                                color: AppColors.primaryMid,
                                fontWeight: FontWeight.w900,
                                fontSize: 22)),
                      ]),
                    ]),
                  ),

                  const SizedBox(height: 24),
                  const Text('Payment Method',
                      style: TextStyle(
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                  const SizedBox(height: 12),

                  // Payment method selector
                  ...List.generate(_methods.length, (i) {
                    final method = _methods[i];
                    final sel = _selectedMethod == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedMethod = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: sel
                              ? AppColors.primaryMid.withOpacity(0.05)
                              : AppColors.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                sel ? AppColors.primaryMid : AppColors.divider,
                            width: sel ? 1.5 : 0.5,
                          ),
                        ),
                        child: Row(children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.primaryMid.withOpacity(0.1)
                                  : AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(method['icon'] as IconData,
                                color: sel
                                    ? AppColors.primaryMid
                                    : AppColors.textLight,
                                size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(method['label'] as String,
                                    style: TextStyle(
                                      color: sel
                                          ? AppColors.textDark
                                          : AppColors.textMid,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    )),
                                Text(method['sub'] as String,
                                    style: const TextStyle(
                                        color: AppColors.textHint,
                                        fontSize: 12)),
                              ])),
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: sel
                                    ? AppColors.primaryMid
                                    : AppColors.divider,
                                width: sel ? 5.5 : 1.5,
                              ),
                            ),
                          ),
                        ]),
                      ),
                    );
                  }),

                  // Card form (only for card method)
                  if (_selectedMethod == 0) ...[
                    const SizedBox(height: 16),
                    const Text('Card Details',
                        style: TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w800,
                            fontSize: 16)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Column(children: [
                        // Card number
                        _cardField(
                          controller: _cardNum,
                          hint: '0000  0000  0000  0000',
                          label: 'Card Number',
                          icon: Icons.credit_card_rounded,
                          kb: TextInputType.number,
                          formatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            _CardNumberFormatter(),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _cardField(
                          controller: _cardName,
                          hint: 'Name on card',
                          label: 'Cardholder Name',
                          icon: Icons.person_outline_rounded,
                          kb: TextInputType.name,
                        ),
                        const SizedBox(height: 12),
                        Row(children: [
                          Expanded(
                              child: _cardField(
                            controller: _expiry,
                            hint: 'MM / YY',
                            label: 'Expiry',
                            icon: Icons.calendar_today_rounded,
                            kb: TextInputType.number,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              _ExpiryFormatter(),
                            ],
                          )),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _cardField(
                            controller: _cvv,
                            hint: '•••',
                            label: 'CVV',
                            icon: Icons.lock_outline_rounded,
                            kb: TextInputType.number,
                            obscure: true,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                          )),
                        ]),
                        const SizedBox(height: 14),
                        // Card brands row
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _cardBrand('VISA', const Color(0xFF1A1F71)),
                              const SizedBox(width: 10),
                              _cardBrand('MC', const Color(0xFFEB001B)),
                              const SizedBox(width: 10),
                              _cardBrand('AMEX', const Color(0xFF006FCF)),
                            ]),
                      ]),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Security note
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMid.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primaryMid.withOpacity(0.15)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.lock_rounded,
                          color: AppColors.primaryMid, size: 18),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Your payment is secured with 256-bit SSL encryption. We never store your card details.',
                          style: TextStyle(
                              color: AppColors.textMid,
                              fontSize: 12,
                              height: 1.5),
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Pay button bar ────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: GestureDetector(
                onTap: _processing ? null : _pay,
                child: Container(
                  decoration: BoxDecoration(
                    color: _processing
                        ? AppColors.primaryLight
                        : AppColors.primaryMid,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: _processing
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2.5),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                const Icon(Icons.lock_rounded,
                                    color: Colors.white, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Pay Rs. ${_fmtCost(widget.totalCost)} Securely',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                              ]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) => Row(children: [
        Text(label,
            style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 13)),
      ]);

  Widget _cardField({
    required TextEditingController controller,
    required String hint,
    required String label,
    required IconData icon,
    TextInputType? kb,
    bool obscure = false,
    List<TextInputFormatter>? formatters,
  }) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textMid,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AppColors.divider),
          ),
          child: TextField(
            controller: controller,
            keyboardType: kb,
            obscureText: obscure,
            inputFormatters: formatters,
            style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 15,
                fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(color: AppColors.textHint, fontSize: 14),
              prefixIcon: Icon(icon, color: AppColors.textLight, size: 18),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            ),
          ),
        ),
      ]);

  Widget _cardBrand(String name, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Text(name,
            style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5)),
      );

  Widget _buildSuccessScreen() {
    final m = widget.machine;
    final bookingRef =
        'AGR${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Success icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 52),
              ),
              const SizedBox(height: 20),
              const Text('Payment Successful!',
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 26,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text('Booking #$bookingRef',
                  style: const TextStyle(
                      color: AppColors.textLight, fontSize: 13)),
              const SizedBox(height: 28),

              // Booking receipt card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Machine info
                    Row(children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: (m['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: (m['images'] as List?)?.isNotEmpty == true
                            ? Image.network(
                                (m['images'] as List).first as String,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                    m['icon'] as IconData,
                                    color: m['color'] as Color,
                                    size: 26))
                            : Icon(m['icon'] as IconData,
                                color: m['color'] as Color, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(m['name'] as String,
                                style: const TextStyle(
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14),
                                maxLines: 2),
                            Text('Owner: ${m['owner']}',
                                style: const TextStyle(
                                    color: AppColors.textLight, fontSize: 12)),
                          ])),
                    ]),
                    Container(
                        height: 0.5,
                        color: AppColors.divider,
                        margin: const EdgeInsets.symmetric(vertical: 16)),

                    _receiptRow(
                        Icons.access_time_rounded,
                        'Duration',
                        widget.hours != null
                            ? '${widget.hours} hours'
                            : '${widget.days} day${(widget.days ?? 1) > 1 ? 's' : ''}'),
                    const SizedBox(height: 10),
                    if (widget.fromDate != null)
                      _receiptRow(Icons.calendar_today_rounded, 'Start Date',
                          _fmt(widget.fromDate)),
                    if (widget.fromDate != null) const SizedBox(height: 10),
                    _receiptRow(Icons.location_on_rounded, 'Location',
                        (m['loc'] ?? '') as String),
                    const SizedBox(height: 10),
                    _receiptRow(Icons.person_rounded, 'Owner',
                        (m['owner'] ?? '') as String),

                    Container(
                        height: 0.5,
                        color: AppColors.divider,
                        margin: const EdgeInsets.symmetric(vertical: 16)),

                    Row(children: [
                      const Text('Amount Paid',
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w800,
                              fontSize: 15)),
                      const Spacer(),
                      Text('Rs. ${_fmtCost(widget.totalCost)}',
                          style: const TextStyle(
                              color: AppColors.success,
                              fontWeight: FontWeight.w900,
                              fontSize: 22)),
                    ]),

                    Container(
                        height: 0.5,
                        color: AppColors.divider,
                        margin: const EdgeInsets.symmetric(vertical: 14)),

                    // What's next
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: AppColors.gold.withOpacity(0.3)),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                color: AppColors.goldDark, size: 16),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'The machine owner will contact you within 2 hours to confirm the pickup/delivery arrangement.',
                                style: TextStyle(
                                    color: AppColors.goldDark,
                                    fontSize: 12,
                                    height: 1.5),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryMid,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text('Back to Home',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: const Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.download_rounded,
                                color: AppColors.textMid, size: 18),
                            SizedBox(width: 8),
                            Text('Download Receipt',
                                style: TextStyle(
                                    color: AppColors.textMid,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15)),
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(IconData icon, String label, String value) =>
      Row(children: [
        Icon(icon, size: 14, color: AppColors.textLight),
        const SizedBox(width: 8),
        Text('$label  ',
            style: const TextStyle(color: AppColors.textLight, fontSize: 13)),
        Expanded(
          child: Text(value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 13),
              overflow: TextOverflow.ellipsis),
        ),
      ]);
}

// ─── INPUT FORMATTERS ─────────────────────────────────────────────────────────
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue next) {
    final digits = next.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 16 ? digits.substring(0, 16) : digits;
    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write('  ');
      buffer.write(limited[i]);
    }
    final str = buffer.toString();
    return TextEditingValue(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue next) {
    final digits = next.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 4 ? digits.substring(0, 4) : digits;
    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i == 2) buffer.write(' / ');
      buffer.write(limited[i]);
    }
    final str = buffer.toString();
    return TextEditingValue(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

// ─── ADD MACHINE SHEET ────────────────────────────────────────────────────────
class AddMachineSheet extends StatefulWidget {
  const AddMachineSheet({super.key});

  @override
  State<AddMachineSheet> createState() => _AddMachineSheetState();
}

class _AddMachineSheetState extends State<AddMachineSheet> {
  String _type = 'Tractor';
  final _nameCtrl = TextEditingController();
  final _rateDay = TextEditingController();
  final _rateHour = TextEditingController();
  final _hpCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _location = '';

  final List<String> _types = [
    'Tractor',
    'Harvester',
    'Tiller',
    'Sprayer',
    'Seeder',
    'Excavator',
    'Other'
  ];

  final Map<String, dynamic> _typeInfo = {
    'Tractor': {'icon': Icons.agriculture_rounded, 'color': Color(0xFF1B6B3A)},
    'Harvester': {
      'icon': Icons.agriculture_rounded,
      'color': Color(0xFFB7791F)
    },
    'Tiller': {'icon': Icons.agriculture_rounded, 'color': Color(0xFF2B6CB0)},
    'Sprayer': {'icon': Icons.water_drop_rounded, 'color': Color(0xFFC53030)},
    'Seeder': {'icon': Icons.grass_rounded, 'color': Color(0xFF6B46C1)},
    'Excavator': {
      'icon': Icons.construction_rounded,
      'color': Color(0xFFC05621)
    },
    'Other': {'icon': Icons.build_rounded, 'color': Color(0xFF718096)},
  };

  final List<Map<String, String>> _districts = [
    {'name': 'Colombo', 'province': 'Western Province'},
    {'name': 'Gampaha', 'province': 'Western Province'},
    {'name': 'Kandy', 'province': 'Central Province'},
    {'name': 'Galle', 'province': 'Southern Province'},
    {'name': 'Anuradhapura', 'province': 'North Central Province'},
    {'name': 'Polonnaruwa', 'province': 'North Central Province'},
    {'name': 'Kurunegala', 'province': 'North Western Province'},
    {'name': 'Badulla', 'province': 'Uva Province'},
    {'name': 'Ratnapura', 'province': 'Sabaragamuwa Province'},
    {'name': 'Trincomalee', 'province': 'Eastern Province'},
    {'name': 'Jaffna', 'province': 'Northern Province'},
    {'name': 'Matara', 'province': 'Southern Province'},
    {'name': 'Hambantota', 'province': 'Southern Province'},
    {'name': 'Kegalle', 'province': 'Sabaragamuwa Province'},
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _rateDay.dispose();
    _rateHour.dispose();
    _hpCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _pickLocation() {
    String search = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) {
          final f = _districts
              .where((d) =>
                  d['name']!.toLowerCase().contains(search.toLowerCase()))
              .toList();
          return Container(
            height: MediaQuery.of(ctx).size.height * 0.65,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(children: [
              const SizedBox(height: 12),
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 12),
              const Text('Select District',
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: TextField(
                    autofocus: true,
                    onChanged: (v) => set(() => search = v),
                    decoration: const InputDecoration(
                      hintText: 'Search district...',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search_rounded,
                          color: AppColors.primaryMid, size: 18),
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  itemCount: f.length,
                  itemBuilder: (_, i) => ListTile(
                    title: Text(f[i]['name']!),
                    subtitle: Text(f[i]['province']!,
                        style: const TextStyle(fontSize: 12)),
                    leading: const Icon(Icons.location_on_rounded,
                        color: AppColors.primaryMid, size: 18),
                    onTap: () {
                      setState(() => _location = f[i]['name']!);
                      Navigator.pop(ctx);
                    },
                  ),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }

  void _submit() {
    if (_nameCtrl.text.trim().isEmpty || _rateDay.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill required fields'),
          backgroundColor: AppColors.warning));
      return;
    }
    final info = _typeInfo[_type]!;
    MachineStore.instance.addMachine({
      'name': _nameCtrl.text.trim(),
      'type': _type,
      'icon': info['icon'] as IconData,
      'color': info['color'] as Color,
      'owner': 'You',
      'ownerPhoto': null,
      'loc': _location.isNotEmpty ? _location : 'Not specified',
      'rateDay':
          int.tryParse(_rateDay.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      'rateHour':
          int.tryParse(_rateHour.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      'availability': 'Available',
      'hp': _hpCtrl.text.trim().isNotEmpty ? _hpCtrl.text.trim() : '—',
      'year': DateTime.now().year.toString(),
      'desc': _descCtrl.text.trim().isNotEmpty
          ? _descCtrl.text.trim()
          : 'Listed by owner.',
      'images': <String>[],
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Machine listed successfully!'),
        backgroundColor: AppColors.success));
  }

  Widget _field(TextEditingController ctrl, String hint, IconData icon,
          {TextInputType? kb}) =>
      Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: TextField(
          controller: ctrl,
          keyboardType: kb,
          style: const TextStyle(color: AppColors.textDark, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
            prefixIcon: Icon(icon, color: AppColors.primaryMid, size: 18),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.93,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(children: [
        const SizedBox(height: 12),
        Center(
            child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2)))),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(children: [
            const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('List Your Machine',
                      style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                  Text('Earn by renting out your equipment',
                      style:
                          TextStyle(color: AppColors.textLight, fontSize: 12)),
                ]),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: AppColors.surface, shape: BoxShape.circle),
                child: const Icon(Icons.close_rounded,
                    color: AppColors.textMid, size: 18),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Machine Type *',
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _types.map((t) {
                  final sel = _type == t;
                  final info = _typeInfo[t]!;
                  final c = info['color'] as Color;
                  return GestureDetector(
                    onTap: () => setState(() => _type = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: sel ? c.withOpacity(0.08) : AppColors.surface,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                            color: sel ? c : AppColors.divider,
                            width: sel ? 1.5 : 0.5),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(info['icon'] as IconData,
                            size: 14, color: sel ? c : AppColors.textLight),
                        const SizedBox(width: 5),
                        Text(t,
                            style: TextStyle(
                                color: sel ? c : AppColors.textMid,
                                fontWeight:
                                    sel ? FontWeight.w800 : FontWeight.normal,
                                fontSize: 13)),
                      ]),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              const Text('Machine Name *',
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              const SizedBox(height: 8),
              _field(_nameCtrl, 'e.g. John Deere Tractor 5075E',
                  Icons.agriculture_rounded),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const Text('Rate / Day (Rs.) *',
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                      const SizedBox(height: 8),
                      _field(_rateDay, '0', Icons.payments_rounded,
                          kb: TextInputType.number),
                    ])),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const Text('Rate / Hour (Rs.)',
                          style: TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                      const SizedBox(height: 8),
                      _field(_rateHour, '0', Icons.schedule_rounded,
                          kb: TextInputType.number),
                    ])),
              ]),
              const SizedBox(height: 14),
              const Text('Engine Power (HP)',
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              const SizedBox(height: 8),
              _field(_hpCtrl, 'e.g. 75 HP', Icons.bolt_rounded),
              const SizedBox(height: 14),
              const Text('Description',
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: TextField(
                  controller: _descCtrl,
                  maxLines: 3,
                  style:
                      const TextStyle(color: AppColors.textDark, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Condition, features, includes operator?',
                    hintStyle:
                        TextStyle(color: AppColors.textHint, fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(14),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Location *',
                  style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickLocation,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _location.isEmpty
                        ? AppColors.surface
                        : AppColors.primaryMid.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _location.isEmpty
                          ? AppColors.divider
                          : AppColors.primaryMid,
                      width: _location.isEmpty ? 0.5 : 1.5,
                    ),
                  ),
                  child: Row(children: [
                    Icon(Icons.location_on_rounded,
                        color: _location.isEmpty
                            ? AppColors.textHint
                            : AppColors.primaryMid,
                        size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(
                      _location.isEmpty ? 'Select district' : _location,
                      style: TextStyle(
                        color: _location.isEmpty
                            ? AppColors.textHint
                            : AppColors.textDark,
                        fontWeight: _location.isEmpty
                            ? FontWeight.normal
                            : FontWeight.w700,
                        fontSize: 14,
                      ),
                    )),
                    Icon(
                      _location.isEmpty
                          ? Icons.chevron_right_rounded
                          : Icons.edit_location_alt_outlined,
                      color: _location.isEmpty
                          ? AppColors.textHint
                          : AppColors.primaryMid,
                      size: 18,
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: GestureDetector(
                  onTap: _submit,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryMid,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline_rounded,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text('List Machine for Hire',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16)),
                          ]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ]),
          ),
        ),
      ]),
    );
  }
}
