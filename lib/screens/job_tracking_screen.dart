import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/common.dart';

class JobTrackingScreen extends StatelessWidget {
  final Booking booking;
  final Worker? worker;

  const JobTrackingScreen({
    super.key,
    required this.booking,
    this.worker,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      booking.serviceName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const BadgeChip(
                    label: 'Live',
                    color: AppColors.primary,
                    icon: Icons.circle,
                  ),
                ],
              ),
            ),

            // Map placeholder
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primarySoft,
                      AppColors.primarySoft.withValues(alpha: 0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _MapPainter(),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppRadius.full),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.directions_walk,
                                    color: AppColors.primary, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'ETA 15 min',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Worker info
            if (worker != null)
              Container(
                margin: const EdgeInsets.all(AppSpacing.lg),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    WorkerAvatar(
                      initials: worker!.initials,
                      photoUrl: worker!.photoUrl,
                      size: 52,
                      ringColor: AppColors.success,
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worker!.fullName,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          RatingStars(
                            rating: worker!.ratingAvg,
                            reviewCount: worker!.jobsCompleted,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'ID & Good Conduct verified',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.success),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(Icons.phone, size: 20),
                        ),
                        const SizedBox(height: 4),
                        IconButton.outlined(
                          onPressed: () {},
                          icon: const Icon(Icons.chat_bubble_outline,
                              size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Timeline
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Job progress',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  StatusTimeline(currentStatus: booking.status),
                ],
              ),
            ),

            // Safety
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Share job'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                      icon: const Icon(Icons.emergency),
                      label: const Text('SOS'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.15)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw a route
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.8);
    path.cubicTo(
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.6,
      size.height * 0.6,
      size.width * 0.8,
      size.height * 0.2,
    );
    canvas.drawPath(path, paint);

    // Start marker
    canvas.drawCircle(
      Offset(size.width * 0.2, size.height * 0.8),
      8,
      Paint()..color = AppColors.primary,
    );

    // End marker
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      8,
      Paint()..color = AppColors.accent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
