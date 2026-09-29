import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/common.dart';

class WorkerCard extends StatelessWidget {
  final Worker worker;
  final VoidCallback? onTap;
  final bool showDistance;

  const WorkerCard({
    super.key,
    required this.worker,
    this.onTap,
    this.showDistance = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                WorkerAvatar(
                  initials: worker.initials,
                  photoUrl: worker.photoUrl,
                  size: 56,
                  ringColor: worker.isVerified ? AppColors.success : AppColors.warning,
                ),
                if (worker.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                        border: Border.all(color: AppColors.surface, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        worker.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (worker.isTeamLeader) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.workspace_premium,
                            size: 16, color: AppColors.accent),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingStars(
                        rating: worker.ratingAvg,
                        reviewCount: worker.jobsCompleted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${worker.experienceYears}y exp',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      if (worker.isVerified)
                        const BadgeChip(
                          label: 'ID & Good Conduct',
                          color: AppColors.success,
                          icon: Icons.verified,
                        )
                      else
                        const BadgeChip(
                          label: 'Pending',
                          color: AppColors.warning,
                          icon: Icons.access_time,
                        ),
                      if (worker.isTeamLeader)
                        const BadgeChip(
                          label: 'Team Leader',
                          color: AppColors.accent,
                          icon: Icons.workspace_premium,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final Service service;
  final VoidCallback? onTap;

  const ServiceTile({super.key, required this.service, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(service.icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              service.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            PriceTag(
              amount: service.basePrice,
              unit: service.priceUnit == 'hour' ? '/hr' : null,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }
}
