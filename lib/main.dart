import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'models/models.dart';
import 'services/supabase_service.dart';
import 'screens/customer_home_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/bookings_list_screen.dart';
import 'screens/job_tracking_screen.dart';
import 'screens/worker_detail_screen.dart';
import 'screens/account_screen.dart';
import 'screens/worker_jobs_screen.dart';
import 'screens/worker_earnings_screen.dart';
import 'screens/worker_profile_screen.dart';
import 'screens/team_leader_screen.dart';
import 'widgets/common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const FreshHomeApp());
}

class FreshHomeApp extends StatelessWidget {
  const FreshHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fresh Home',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      home: const RoleSelectorScreen(),
    );
  }
}

class RoleSelectorScreen extends StatelessWidget {
  const RoleSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: const Icon(Icons.cleaning_services,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'Fresh Home',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Verified on-demand domestic & cleaning services. Choose how you want to use the app.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _RoleCard(
                icon: Icons.home_outlined,
                title: 'I need a cleaner',
                subtitle: 'Book verified workers for your home, hotel or event',
                color: AppColors.primary,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CustomerApp()),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _RoleCard(
                icon: Icons.work_outline,
                title: 'I am a worker',
                subtitle: 'Find jobs, track earnings and grow your career',
                color: AppColors.accent,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const WorkerApp()),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_user,
                        size: 16, color: AppColors.success),
                    const SizedBox(width: 4),
                    const Text(
                      'Every worker ID & Good Conduct verified',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}

// =================== CUSTOMER APP ===================

class CustomerApp extends StatefulWidget {
  const CustomerApp({super.key});

  @override
  State<CustomerApp> createState() => _CustomerAppState();
}

class _CustomerAppState extends State<CustomerApp> {
  final _supabase = SupabaseService.instance;
  int _currentIndex = 0;
  List<Service> _services = [];
  List<Worker> _workers = [];
  List<Booking> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final services = await _supabase.fetchServices();
      final workers = await _supabase.fetchWorkers();
      final bookings = await _supabase.fetchBookings();
      if (mounted) {
        setState(() {
          _services = services;
          _workers = workers;
          _bookings = bookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) print('Error loading data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onServiceTap(Service service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingScreen(
          preselectedService: service,
          workers: _workers,
          teams: [],
          services: _services,
          onBook: _createBooking,
        ),
      ),
    );
  }

  void _onBookTap(bool isTeam) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingScreen(
          isTeamBooking: isTeam,
          workers: _workers,
          teams: [],
          services: _services,
          onBook: _createBooking,
        ),
      ),
    );
  }

  void _onWorkerTap(Worker worker) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkerDetailScreen(
          worker: worker,
          ratings: [],
        ),
      ),
    );
  }

  void _onBookingTap(Booking booking) {
    final worker = booking.workerId != null
        ? _workers.where((w) => w.id == booking.workerId).firstOrNull
        : null;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobTrackingScreen(
          booking: booking,
          worker: worker,
        ),
      ),
    );
  }

  Future<void> _createBooking(Map<String, dynamic> data) async {
    try {
      await _supabase.createBooking(data);
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking confirmed! We are finding your worker.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) print('Error creating booking: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not create booking. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: LoadingIndicator(message: 'Loading...'));
    }

    final screens = [
      CustomerHomeScreen(
        services: _services,
        workers: _workers,
        bookings: _bookings,
        onServiceTap: _onServiceTap,
        onBookTap: _onBookTap,
        onWorkerTap: _onWorkerTap,
        onBookingTap: _onBookingTap,
      ),
      BookingsListScreen(
        bookings: _bookings,
        onBookingTap: _onBookingTap,
      ),
      const _MessagesScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

// =================== WORKER APP ===================

class WorkerApp extends StatefulWidget {
  const WorkerApp({super.key});

  @override
  State<WorkerApp> createState() => _WorkerAppState();
}

class _WorkerAppState extends State<WorkerApp> {
  final _supabase = SupabaseService.instance;
  int _currentIndex = 0;
  List<Booking> _availableJobs = [];
  List<Booking> _myJobs = [];
  List<Booking> _completedJobs = [];
  List<Worker> _teamMembers = [];
  bool _isLoading = true;
  bool _isOnline = false;

  // Simulated worker (Grace Wanjiru)
  Worker? _me;
  Team? _myTeam;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final workers = await _supabase.fetchWorkers();
      final bookings = await _supabase.fetchBookings();
      final teams = await _supabase.fetchTeams();

      // Find Grace as the logged-in worker
      _me = workers.where((w) => w.fullName == 'Grace Wanjiru').firstOrNull;
      if (_me == null && workers.isNotEmpty) _me = workers.first;

      // Find team if worker is a team leader or member
      if (_me != null) {
        _myTeam = teams.where((t) => t.leaderId == _me!.id).firstOrNull;
        if (_myTeam == null && teams.isNotEmpty) {
          // Check if worker is a member of any team
          for (final t in teams) {
            final members = await _supabase.fetchTeamMembers(t.id);
            if (members.any((m) => m.id == _me!.id)) {
              _myTeam = t;
              _teamMembers = members;
              break;
            }
          }
        }
        if (_myTeam != null && _teamMembers.isEmpty) {
          _teamMembers = await _supabase.fetchTeamMembers(_myTeam!.id);
        }
      }

      // Categorize bookings
      _availableJobs = bookings.where((b) => b.status == 'pending').toList();
      _myJobs = bookings.where((b) =>
          b.status == 'assigned' ||
          b.status == 'on_the_way' ||
          b.status == 'arrived' ||
          b.status == 'in_progress').toList();
      _completedJobs = bookings.where((b) => b.status == 'completed').toList();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) print('Error loading worker data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onAcceptJob(Booking job) {
    setState(() {
      _availableJobs.removeWhere((b) => b.id == job.id);
      _myJobs.add(job.copyWith(status: 'assigned'));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Job accepted! Check in when you arrive.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _onJobTap(Booking job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobTrackingScreen(booking: job, worker: _me),
      ),
    );
  }

  int get _availableBalance => _completedJobs.fold<int>(
      0, (sum, j) => sum + (j.totalPrice * 0.8).round());

  int get _totalEarnings => _availableBalance;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: LoadingIndicator(message: 'Loading...'));
    }

    final hasTeam = _myTeam != null;

    final screens = [
      WorkerJobsScreen(
        availableJobs: _availableJobs,
        myJobs: _myJobs,
        onAcceptJob: _onAcceptJob,
        onJobTap: _onJobTap,
        isOnline: _isOnline,
        onToggleOnline: (v) => setState(() => _isOnline = v),
      ),
      const _CalendarScreen(),
      WorkerEarningsScreen(
        totalEarnings: _totalEarnings,
        availableBalance: _availableBalance,
        completedJobs: _completedJobs,
      ),
      _me != null
          ? WorkerProfileScreen(worker: _me!)
          : const Center(child: Text('No profile found')),
    ];

    // Add team tab if worker is a team leader
    final navItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.work_outline),
        activeIcon: Icon(Icons.work),
        label: 'Jobs',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today_outlined),
        activeIcon: Icon(Icons.calendar_today),
        label: 'Calendar',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.payments_outlined),
        activeIcon: Icon(Icons.payments),
        label: 'Earnings',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    final allScreens = List<Widget>.from(screens);
    if (hasTeam) {
      allScreens.insert(2, TeamLeaderScreen(
        team: _myTeam!,
        members: _teamMembers,
        teamJobs: _availableJobs.where((j) => j.bookingType == 'team').toList(),
      ));
      navItems.insert(2, const BottomNavigationBarItem(
        icon: Icon(Icons.group_outlined),
        activeIcon: Icon(Icons.group),
        label: 'Team',
      ));
    }

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: allScreens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: navItems,
      ),
    );
  }
}

// =================== PLACEHOLDER SCREENS ===================

class _MessagesScreen extends StatelessWidget {
  const _MessagesScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Messages',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: EmptyState(
                  icon: Icons.chat_bubble_outline,
                  title: 'No messages yet',
                  subtitle:
                      'Chat with your worker or customer once a booking is confirmed',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarScreen extends StatelessWidget {
  const _CalendarScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Calendar',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: EmptyState(
                  icon: Icons.calendar_today_outlined,
                  title: 'No scheduled jobs',
                  subtitle:
                      'Your upcoming and scheduled jobs will appear here',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension to add copyWith on Booking
extension BookingCopy on Booking {
  Booking copyWith({
    String? status,
    int? progress,
  }) {
    return Booking(
      id: id,
      customerName: customerName,
      customerType: customerType,
      serviceId: serviceId,
      serviceName: serviceName,
      bookingType: bookingType,
      status: status ?? this.status,
      address: address,
      latitude: latitude,
      longitude: longitude,
      scheduledDate: scheduledDate,
      scheduledTime: scheduledTime,
      durationHours: durationHours,
      workersRequired: workersRequired,
      totalPrice: totalPrice,
      workerId: workerId,
      teamId: teamId,
      progress: progress ?? this.progress,
    );
  }
}
