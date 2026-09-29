import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/common.dart';

class WorkerDetailScreen extends StatelessWidget {
  final Worker worker;
  final List<Rating> ratings;

  const WorkerDetailScreen({
    super.key,
    required this.worker,
    this.ratings = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      WorkerAvatar(
                        initials: worker.initials,
                        photoUrl: worker.photoUrl,
                        size: 96,
                        ringColor: Colors.white,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        worker.fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.accent, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '${worker.ratingAvg.toStringAsFixed(1)} (${worker.jobsCompleted} jobs)',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  _InfoCard(
                      icon: Icons.location_on_outlined,
                      label: 'Area',
                      value: worker.area),
                  _InfoCard(
                      icon: Icons.translate,
                      label: 'Languages',
                      value: worker.languages.join(', ')),
                  _InfoCard(
                      icon: Icons.work_outline,
                      label: 'Experience',
                      value: '${worker.experienceYears} years'),
                  _InfoCard(
                      icon: Icons.cleaning_services_outlined,
                      label: 'Services',
                      value: worker.services.join(', ')),
                  _InfoCard(
                      icon: Icons.payments_outlined,
                      label: 'Rate',
                      value: 'KSh ${worker.expectedRate}/hr'),
                  const SizedBox(height: AppSpacing.xl),
                  const Text('About',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    worker.bio,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Text('Reviews',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.md),
                  if (ratings.isEmpty)
                    const Text('No reviews yet',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.textSecondary))
                  else
                    ...ratings.map((r) => _ReviewCard(rating: r)),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, worker),
            child: const Text('Book this worker'),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Rating rating;

  const _ReviewCard({required this.rating});

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
            children: [
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < rating.score ? Icons.star_rounded : Icons.star_outline,
                    size: 16,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                rating.fromRole == 'customer' ? 'Customer' : 'Worker',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(rating.comment,
              style: const TextStyle(fontSize: 14, height: 1.4)),
          if (rating.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: rating.tags
                  .map((t) => BadgeChip(label: t, color: AppColors.info, icon: Icons.check))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
