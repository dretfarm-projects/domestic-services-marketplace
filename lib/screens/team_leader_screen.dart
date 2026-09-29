import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/common.dart';

class TeamLeaderScreen extends StatelessWidget {
  final Team team;
  final List<Worker> members;
  final List<Booking> teamJobs;

  const TeamLeaderScreen({
    super.key,
    required this.team,
    required this.members,
    required this.teamJobs,
  });

  @override
  Widget build(BuildContext context) {
    final verified = members.where((w) => w.isVerified).length;
    final pending = members.where((w) => !w.isVerified).length;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text(
              'My Team',
              style:
                  TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Team summary card
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.accent, const Color(0xFFD97706)],
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          team.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Icon(Icons.workspace_premium,
                          color: Colors.white, size: 28),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Led by ${team.leaderName}',
                    style: const TextStyle(
                        fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      _TeamStat(
                        label: 'Members',
                        value: '${members.length}',
                      ),
                      _TeamStat(
                        label: 'Verified',
                        value: '$verified',
                      ),
                      _TeamStat(
                        label: 'Pending',
                        value: '$pending',
                      ),
                      _TeamStat(
                        label: 'Rating',
                        value: team.rating.toStringAsFixed(1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Today's team jobs
            if (teamJobs.isNotEmpty) ...[
              const Text(
                "Today's team jobs",
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.md),
              ...teamJobs.map((j) => _TeamJobCard(job: j)),
              const SizedBox(height: AppSpacing.xl),
            ],

            // Team roster
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Team roster',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text('Invite'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...members.map((w) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _RosterRow(worker: w),
                )),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _TeamStat extends StatelessWidget {
  final String label;
  final String value;

  const _TeamStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _TeamJobCard extends StatelessWidget {
  final Booking job;

  const _TeamJobCard({required this.job});

  @override
  Widget build(BuildContext context) {
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
              BadgeChip(
                label: '${job.workersRequired} workers',
                color: AppColors.primary,
                icon: Icons.group,
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
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Allocate workers'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RosterRow extends StatelessWidget {
  final Worker worker;

  const _RosterRow({required this.worker});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          WorkerAvatar(
            initials: worker.initials,
            photoUrl: worker.photoUrl,
            size: 44,
            ringColor: worker.isVerified ? AppColors.success : AppColors.warning,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  worker.fullName,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    RatingStars(
                      rating: worker.ratingAvg,
                      reviewCount: worker.jobsCompleted,
                      size: 12,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (worker.isVerified)
            const BadgeChip(
              label: 'Verified',
              color: AppColors.success,
              icon: Icons.verified,
            )
          else
            const BadgeChip(
              label: 'Pending',
              color: AppColors.warning,
              icon: Icons.access_time,
            ),
        ],
      ),
    );
  }
}
