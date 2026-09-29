import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/common.dart';

class WorkerJobsScreen extends StatefulWidget {
  final List<Booking> availableJobs;
  final List<Booking> myJobs;
  final Function(Booking) onAcceptJob;
  final Function(Booking) onJobTap;
  final bool isOnline;
  final Function(bool) onToggleOnline;

  const WorkerJobsScreen({
    super.key,
    required this.availableJobs,
    required this.myJobs,
    required this.onAcceptJob,
    required this.onJobTap,
    required this.isOnline,
    required this.onToggleOnline,
  });

  @override
  State<WorkerJobsScreen> createState() => _WorkerJobsScreenState();
}

class _WorkerJobsScreenState extends State<WorkerJobsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Online toggle
            Container(
              margin: const EdgeInsets.all(AppSpacing.lg),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: widget.isOnline
                    ? AppColors.successSoft
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: widget.isOnline
                      ? AppColors.success.withValues(alpha: 0.3)
                      : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isOnline
                          ? AppColors.success
                          : AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      widget.isOnline ? 'Online & Available' : 'Offline',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: widget.isOnline
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Switch(
                    value: widget.isOnline,
                    onChanged: widget.onToggleOnline,
                    activeThumbColor: AppColors.success,
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg),
                children: [
                  // Today's jobs
                  if (widget.myJobs.isNotEmpty) ...[
                    const Text(
                      "Today's jobs",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...widget.myJobs.map((j) => _MyJobCard(
                          job: j,
                          onTap: () => widget.onJobTap(j),
                        )),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  // Available jobs
                  if (widget.availableJobs.isNotEmpty) ...[
                    const Text(
                      'Available jobs',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ...widget.availableJobs.map((j) => _JobOfferCard(
                          job: j,
                          onAccept: () => widget.onAcceptJob(j),
                        )),
                  ],

                  if (widget.availableJobs.isEmpty && widget.myJobs.isEmpty)
                    Center(
                      child: EmptyState(
                        icon: Icons.work_outline,
                        title: 'No jobs available',
                        subtitle: widget.isOnline
                            ? 'We will notify you when a job comes in'
                            : 'Go online to start receiving job offers',
                      ),
                    ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyJobCard extends StatelessWidget {
  final Booking job;
  final VoidCallback onTap;

  const _MyJobCard({required this.job, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job.serviceName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                BadgeChip(
                  label: job.status == 'in_progress'
                      ? 'Active'
                      : job.status == 'assigned'
                          ? 'Assigned'
                          : job.status,
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Icons.access_time,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${job.scheduledTime ?? 'Today'} - ${job.durationHours.toStringAsFixed(0)}h',
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
                      job.address ?? 'Nairobi',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const Text(
                  'Check in',
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
      ),
    );
  }
}

class _JobOfferCard extends StatelessWidget {
  final Booking job;
  final VoidCallback onAccept;

  const _JobOfferCard({required this.job, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    final earnings = (job.totalPrice * 0.8).round();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                job.serviceName,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.errorSoft,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer, size: 12, color: AppColors.error),
                    const SizedBox(width: 4),
                    Text(
                      '04:32',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
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
                job.scheduledTime ?? 'Today',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(width: AppSpacing.md),
              Icon(Icons.place_outlined,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                job.address ?? 'Nairobi',
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'You earn',
                  style: TextStyle(
                      fontSize: 14, color: AppColors.textSecondary),
                ),
                PriceTag(amount: earnings, size: 24),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                  child: const Text('Accept'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Decline'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
