import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/common.dart';

class WorkerEarningsScreen extends StatelessWidget {
  final int totalEarnings;
  final int availableBalance;
  final List<Booking> completedJobs;

  const WorkerEarningsScreen({
    super.key,
    required this.totalEarnings,
    required this.availableBalance,
    required this.completedJobs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text(
              'Earnings',
              style:
                  TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Balance card
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available balance',
                    style: TextStyle(
                        fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'KSh',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _format(availableBalance),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                          ),
                          child: const Text('Cash out'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Summary
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: 'Today',
                    amount: 1800,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _SummaryCard(
                    label: 'This week',
                    amount: 8400,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _SummaryCard(
                    label: 'This month',
                    amount: 32400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Job breakdown
            const Text(
              'Recent jobs',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            ...completedJobs.map((j) => _EarningRow(job: j)),
          ],
        ),
      ),
    );
  }

  String _format(int n) {
    final s = n.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final int amount;

  const _SummaryCard({required this.label, required this.amount});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          PriceTag(amount: amount, size: 18),
        ],
      ),
    );
  }
}

class _EarningRow extends StatelessWidget {
  final Booking job;

  const _EarningRow({required this.job});

  @override
  Widget build(BuildContext context) {
    final earnings = (job.totalPrice * 0.8).round();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.successSoft,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(Icons.check,
                color: AppColors.success, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.serviceName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  job.scheduledDate != null
                      ? '${job.scheduledDate!.day}/${job.scheduledDate!.month}'
                      : 'Recent',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          PriceTag(amount: earnings, size: 16),
        ],
      ),
    );
  }
}
