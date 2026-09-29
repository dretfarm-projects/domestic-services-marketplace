import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BadgeChip extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;

  const BadgeChip({
    super.key,
    required this.label,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: bg.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: bg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: bg,
            ),
          ),
        ],
      ),
    );
  }
}

class VerificationBadge extends StatelessWidget {
  final bool verified;
  final String label;

  const VerificationBadge({
    super.key,
    this.verified = true,
    this.label = 'Verified',
  });

  @override
  Widget build(BuildContext context) {
    return BadgeChip(
      label: verified ? label : 'Pending',
      color: verified ? AppColors.success : AppColors.warning,
      icon: verified ? Icons.verified_outlined : Icons.access_time,
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size, color: AppColors.accent),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: size - 2,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 2),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: size - 4,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class WorkerAvatar extends StatelessWidget {
  final String initials;
  final String? photoUrl;
  final double size;
  final Color? ringColor;

  const WorkerAvatar({
    super.key,
    required this.initials,
    this.photoUrl,
    this.size = 48,
    this.ringColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (ringColor ?? AppColors.primary).withValues(alpha: 0.8),
            (ringColor ?? AppColors.primaryDark),
          ],
        ),
      ),
      padding: EdgeInsets.all(ringColor != null ? 2 : 0),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primarySoft,
        ),
        child: photoUrl != null && photoUrl!.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  photoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _initialsWidget(),
                ),
              )
            : _initialsWidget(),
      ),
    );
  }

  Widget _initialsWidget() {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class StatusTimeline extends StatelessWidget {
  final String currentStatus;

  const StatusTimeline({super.key, required this.currentStatus});

  static const _steps = [
    {'key': 'assigned', 'label': 'Assigned', 'icon': Icons.assignment_turned_in_outlined},
    {'key': 'on_the_way', 'label': 'On the way', 'icon': Icons.directions_walk},
    {'key': 'arrived', 'label': 'Arrived', 'icon': Icons.place_outlined},
    {'key': 'in_progress', 'label': 'In progress', 'icon': Icons.cleaning_services_outlined},
    {'key': 'completed', 'label': 'Completed', 'icon': Icons.check_circle_outline},
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex =
        _steps.indexWhere((s) => s['key'] == currentStatus);

    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final stepIndex = i ~/ 2;
          final done = stepIndex < currentIndex;
          return Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              color: done ? AppColors.primary : AppColors.border,
            ),
          );
        }
        final stepIndex = i ~/ 2;
        final step = _steps[stepIndex];
        final done = stepIndex <= currentIndex;
        final isCurrent = stepIndex == currentIndex;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? AppColors.primary : AppColors.bg,
                border: Border.all(
                  color: done ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
              ),
              child: Icon(
                step['icon'] as IconData,
                size: 16,
                color: done ? Colors.white : AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              step['label'] as String,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                color: done ? AppColors.textPrimary : AppColors.textTertiary,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primarySoft,
            ),
            child: Icon(icon, size: 32, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

class PriceTag extends StatelessWidget {
  final int amount;
  final String? unit;
  final double size;

  const PriceTag({
    super.key,
    required this.amount,
    this.unit,
    this.size = 16,
  });

  String get _formatted {
    final s = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'KSh',
          style: TextStyle(
            fontSize: size * 0.65,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          _formatted,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (unit != null) ...[
          const SizedBox(width: 2),
          Text(
            unit!,
            style: TextStyle(
              fontSize: size * 0.6,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
