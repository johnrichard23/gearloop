import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../listings/presentation/providers/listings_provider.dart';
import '../../../listings/presentation/widgets/listings_grid.dart';

/// "Near you" on Home: a short grid of nearby gear with a "See all" to Browse.
/// Each card already carries the trust cues: rating, review count, host name
/// and the verified badge.
class HomeNearYouSection extends ConsumerWidget {
  const HomeNearYouSection({required this.onSeeAll, super.key});

  final VoidCallback onSeeAll;

  static const int _kPreviewCount = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Clears the floating tab bar, the same way Browse does.
    final bottomPadding = MediaQuery.paddingOf(context).bottom + 48;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.kSpacing16,
          ),
          child: _SectionHeader(
            title: 'Near you in Sorsogon',
            actionLabel: 'See all',
            onAction: onSeeAll,
          ),
        ),
        ref
            .watch(listingsProvider)
            .when(
              loading: () => ListingsGrid.skeleton(
                bottomPadding: bottomPadding,
                isEmbedded: true,
                skeletonCount: _kPreviewCount,
              ),
              error: (_, _) => ErrorStateWidget(
                message: 'Could not load gear near you.',
                onRetry: () => ref.invalidate(listingsProvider),
              ),
              data: (listings) => listings.isEmpty
                  ? const EmptyStateWidget(
                      title: 'No gear nearby yet',
                      subtitle: 'Be the first neighbour to list something.',
                      icon: Icons.camera_alt_outlined,
                    )
                  : ListingsGrid(
                      listings: listings.take(_kPreviewCount).toList(),
                      bottomPadding: bottomPadding,
                      isEmbedded: true,
                    ),
            ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: AppTextStyles.kTextHeading3)),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            minimumSize: const Size(
              AppSpacing.kSpacing48,
              AppSpacing.kSpacing48,
            ),
          ),
          child: Text(
            actionLabel,
            style: AppTextStyles.kTextBodyMedium.copyWith(
              color: AppColors.kColorPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
