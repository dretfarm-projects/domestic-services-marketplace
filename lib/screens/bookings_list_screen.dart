import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/common.dart';

class BookingsListScreen extends StatelessWidget {
  final List<Booking> bookings;
  final Function(Booking) onBookingTap;

  const BookingsListScreen({
    super.key,
    required this.bookings,
    required this.onBookingTap,
  });

  @override
  Widget build(BuildContext context) {
    final upcoming = bookings
        .where((b) =>
            b.status == 'pending' ||
            b.status == 'assigned' ||
            b.status == 'on_the_way' ||
            b.status == 'arrived' ||
            b.status == 'in_progress')
        .toList();
    final past = bookings
        .where((b) => b.status == 'completed' || b.status == 'cancelled')
        .toList();

    return Scaffold(
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                child: const Text(
                  'My Bookings',
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Past'),
                ],
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                dividerColor: Colors.transparent,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _BookingList(
                      bookings: upcoming,
                      onBookingTap: onBookingTap,
                      emptyIcon: Icons.calendar_today_outlined,
                      emptyTitle: 'No upcoming bookings',
                      emptySubtitle: 'Book your first clean in under a minute',
                    ),
                    _BookingList(
                      bookings: past,
                      onBookingTap: onBookingTap,
                      emptyIcon: Icons.history,
                      emptyTitle: 'No past bookings',
                      emptySubtitle: 'Your completed jobs will appear here',
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

class _BookingList extends StatelessWidget {
  final List<Booking> bookings;
  final Function(Booking) onBookingTap;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptySubtitle;

  const _BookingList({
    required this.bookings,
    required this.onBookingTap,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: EmptyState(
          icon: emptyIcon,
          title: emptyTitle,
          subtitle: emptySubtitle,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: bookings.length,
      itemBuilder: (context, i) => _BookingCard(
        booking: bookings[i],
        onTap: () => onBookingTap(bookings[i]),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onTap;

  const _BookingCard({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isActive = booking.status == 'in_progress' ||
        booking.status == 'assigned' ||
        booking.status == 'on_the_way' ||
        booking.status == 'arrived';

    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    switch (booking.status) {
      case 'completed':
        statusColor = AppColors.success;
        statusLabel = 'Completed';
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        statusColor = AppColors.error;
        statusLabel = 'Cancelled';
        statusIcon = Icons.cancel;
        break;
      case 'in_progress':
        statusColor = AppColors.primary;
        statusLabel = 'In progress';
        statusIcon = Icons.cleaning_services;
        break;
      case 'assigned':
        statusColor = AppColors.info;
        statusLabel = 'Worker assigned';
        statusIcon = Icons.person;
        break;
      case 'on_the_way':
        statusColor = AppColors.info;
        statusLabel = 'On the way';
        statusIcon = Icons.directions_walk;
        break;
      default:
        statusColor = AppColors.warning;
        statusLabel = 'Pending';
        statusIcon = Icons.access_time;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isActive ? statusColor.withValues(alpha: 0.3) : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.serviceName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                BadgeChip(
                  label: statusLabel,
                  color: statusColor,
                  icon: statusIcon,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
              Icon(Icons.calendar_today_outlined,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                booking.scheduledDate != null
                    ? '${booking.scheduledDate!.day}/${booking.scheduledDate!.month}/${booking.scheduledDate!.year}'
                    : 'Date TBD',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(width: AppSpacing.md),
              Icon(Icons.access_time,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                booking.scheduledTime ?? 'Time TBD',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.place_outlined,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      booking.address ?? 'Nairobi',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                PriceTag(amount: booking.totalPrice, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
