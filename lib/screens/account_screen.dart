import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Account',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Profile card
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primarySoft,
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      child: const Icon(Icons.person,
                          color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Anthony Mwangi',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '+254 712 345 678',
                            style: const TextStyle(
                                fontSize: 14, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: AppColors.textTertiary),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Menu items
              _MenuSection(
                title: 'Saved',
                items: [
                  _MenuItem(
                    icon: Icons.place_outlined,
                    label: 'Addresses',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.payments_outlined,
                    label: 'Payment methods',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.bookmark_outline,
                    label: 'Saved requirement profiles',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.favorite_outline,
                    label: 'Favourite workers',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              _MenuSection(
                title: 'Account',
                items: [
                  _MenuItem(
                    icon: Icons.subscriptions_outlined,
                    label: 'Subscriptions',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.card_giftcard,
                    label: 'Refer & earn',
                    onTap: () {},
                    trailing: const BadgeChip(
                      label: 'KSh 200',
                      color: AppColors.accent,
                      icon: Icons.card_giftcard,
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.help_outline,
                    label: 'Help & support',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.language,
                    label: 'Language',
                    onTap: () {},
                    trailing: const Text(
                      'English',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              _MenuSection(
                title: 'Privacy',
                items: [
                  _MenuItem(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy & data controls',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.description_outlined,
                    label: 'Terms & policies',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              ...items.asMap().entries.map((entry) {
                final i = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    item,
                    if (i < items.length - 1)
                      const Divider(height: 1, indent: 56),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: const TextStyle(fontSize: 15),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right,
          color: AppColors.textTertiary, size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }
}
