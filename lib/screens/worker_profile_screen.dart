import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/common.dart';

class WorkerProfileScreen extends StatelessWidget {
  final Worker worker;
  final int verificationProgress;

  const WorkerProfileScreen({
    super.key,
    required this.worker,
    this.verificationProgress = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text(
              'Profile',
              style:
                  TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Profile header
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                children: [
                  WorkerAvatar(
                    initials: worker.initials,
                    photoUrl: worker.photoUrl,
                    size: 80,
                    ringColor: Colors.white,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    worker.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      worker.levelName,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Rating & stats
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.star_rounded,
                    label: 'Rating',
                    value: worker.ratingAvg.toStringAsFixed(1),
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _StatCard(
                    icon: Icons.work_outline,
                    label: 'Jobs done',
                    value: worker.jobsCompleted.toString(),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _StatCard(
                    icon: Icons.trending_up,
                    label: 'Level',
                    value: '${worker.level}',
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Badges
            const Text(
              'Badges',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: worker.badges.map((b) {
                IconData icon = Icons.verified;
                Color color = AppColors.success;
                if (b.contains('Team Leader')) {
                  icon = Icons.workspace_premium;
                  color = AppColors.accent;
                } else if (b.contains('Top')) {
                  icon = Icons.star;
                  color = AppColors.accent;
                } else if (b.contains('Training')) {
                  icon = Icons.school;
                  color = AppColors.info;
                }
                return BadgeChip(label: b, color: color, icon: icon);
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Verification status
            const Text(
              'Verification',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _VerificationRow(
                    label: 'Phone number',
                    status: 'verified',
                  ),
                  _VerificationRow(
                    label: 'National ID',
                    status: worker.isVerified ? 'verified' : 'pending',
                  ),
                  _VerificationRow(
                    label: 'Good Conduct Certificate',
                    status: worker.isVerified ? 'verified' : 'pending',
                  ),
                  _VerificationRow(
                    label: 'References',
                    status: worker.isVerified ? 'verified' : 'pending',
                  ),
                  _VerificationRow(
                    label: 'Training',
                    status: worker.badges.contains('Training Completed')
                        ? 'verified'
                        : 'pending',
                  ),
                  _VerificationRow(
                    label: 'M-Pesa number',
                    status: 'verified',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Level progress
            if (worker.level < 3) ...[
              const Text(
                'Next level',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    Icon(Icons.workspace_premium,
                        color: AppColors.accent, size: 24),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worker.level == 1
                                ? '2 more jobs to reach Verified Worker'
                                : '${10 - worker.jobsCompleted % 10} more jobs to reach Team Leader',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.warning),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: (worker.jobsCompleted % 10) / 10,
                            backgroundColor:
                                AppColors.warning.withValues(alpha: 0.2),
                            color: AppColors.accent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Training
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'Training & certificates',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            _TrainingItem(
              title: 'Cleaning fundamentals',
              completed: true,
            ),
            _TrainingItem(
              title: 'Chemical safety',
              completed: true,
            ),
            _TrainingItem(
              title: 'Customer service',
              completed: true,
            ),
            _TrainingItem(
              title: 'Hospitality service',
              completed: worker.badges.contains('Training Completed'),
            ),
            _TrainingItem(
              title: 'Team Leader training',
              completed: worker.isTeamLeader,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Text(
            label,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _VerificationRow extends StatelessWidget {
  final String label;
  final String status;

  const _VerificationRow({required this.label, required this.status});

  @override
  Widget build(BuildContext context) {
    final verified = status == 'verified';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                verified ? Icons.check_circle : Icons.access_time,
                size: 16,
                color: verified ? AppColors.success : AppColors.warning,
              ),
              const SizedBox(width: 4),
              Text(
                verified ? 'Verified' : 'Pending',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: verified ? AppColors.success : AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrainingItem extends StatelessWidget {
  final String title;
  final bool completed;

  const _TrainingItem({required this.title, required this.completed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.school,
            size: 20,
            color: completed ? AppColors.success : AppColors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: completed ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
          if (completed)
            const BadgeChip(
              label: 'Done',
              color: AppColors.success,
              icon: Icons.check,
            )
          else
            const BadgeChip(
              label: 'Available',
              color: AppColors.info,
              icon: Icons.play_arrow,
            ),
        ],
      ),
    );
  }
}
