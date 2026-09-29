import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/common.dart';
import '../widgets/worker_card.dart';

class CustomerHomeScreen extends StatefulWidget {
  final List<Service> services;
  final List<Worker> workers;
  final List<Booking> bookings;
  final Function(Service) onServiceTap;
  final Function(bool) onBookTap;
  final Function(Worker) onWorkerTap;
  final Function(Booking) onBookingTap;

  const CustomerHomeScreen({
    super.key,
    required this.services,
    required this.workers,
    required this.bookings,
    required this.onServiceTap,
    required this.onBookTap,
    required this.onWorkerTap,
    required this.onBookingTap,
  });

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final activeBooking = widget.bookings
        .where((b) =>
            b.status == 'in_progress' ||
            b.status == 'assigned' ||
            b.status == 'on_the_way' ||
            b.status == 'arrived')
        .toList();
    final topWorkers = widget.workers.take(3).toList();
    final householdServices =
        widget.services.where((s) => s.category == 'household').take(4).toList();
    final otherServices = widget.services
        .where((s) => s.category != 'household')
        .take(4)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {},
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Habari, Anthony',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontSize: 24),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(Icons.place_outlined,
                                      size: 16, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Kasarani, Nairobi',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down,
                                      size: 18, color: AppColors.textTertiary),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primarySoft,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                            ),
                            child: const Icon(Icons.person,
                                color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Book buttons
                      Row(
                        children: [
                          Expanded(
                            child: _BookButton(
                              label: 'Book an individual',
                              sublabel: 'One verified worker',
                              icon: Icons.person_outline,
                              color: AppColors.primary,
                              onTap: () => widget.onBookTap(false),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _BookButton(
                              label: 'Book a team',
                              sublabel: 'For events & hotels',
                              icon: Icons.group_outlined,
                              color: AppColors.accent,
                              onTap: () => widget.onBookTap(true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Trust strip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.successSoft,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                              color: AppColors.success.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.verified_user,
                                color: AppColors.success, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            const Expanded(
                              child: Text(
                                'All workers ID & Good Conduct verified',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),

              // Active booking
              if (activeBooking.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg),
                    child: _ActiveBookingCard(
                      booking: activeBooking.first,
                      onTap: () => widget.onBookingTap(activeBooking.first),
                    ),
                  ),
                ),

              // Services grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.82,
                          crossAxisSpacing: AppSpacing.sm,
                          mainAxisSpacing: AppSpacing.sm,
                        ),
                        itemCount: householdServices.length,
                        itemBuilder: (context, i) => ServiceTile(
                          service: householdServices[i],
                          onTap: () =>
                              widget.onServiceTap(householdServices[i]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // More services
              if (otherServices.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.82,
                        crossAxisSpacing: AppSpacing.sm,
                        mainAxisSpacing: AppSpacing.sm,
                      ),
                      itemCount: otherServices.length,
                      itemBuilder: (context, i) => ServiceTile(
                        service: otherServices[i],
                        onTap: () => widget.onServiceTap(otherServices[i]),
                      ),
                    ),
                  ),
                ),

              // Book again
              if (topWorkers.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Book again',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('See all'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...topWorkers.map((w) => Padding(
                              padding:
                                  const EdgeInsets.only(bottom: AppSpacing.md),
                              child: WorkerCard(
                                worker: w,
                                onTap: () => widget.onWorkerTap(w),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookButton extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BookButton({
    required this.label,
    required this.sublabel,
    required this.icon,
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveBookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onTap;

  const _ActiveBookingCard({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      booking.serviceName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Live',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            StatusTimeline(currentStatus: booking.status),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.scheduledTime ?? 'Today',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                const Row(
                  children: [
                    Icon(Icons.map_outlined,
                        size: 16, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Track',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
