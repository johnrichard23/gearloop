import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_skeleton.dart';
import '../../domain/entities/booking_entity.dart';
import '../providers/my_bookings_provider.dart';
import '../widgets/booking_list_card.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future<void>.microtask(
      () => ref.read(myBookingsProvider.notifier).loadBookings(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myBookingsProvider);

    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      appBar: AppBar(
        title: const Text('My Bookings'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          labelStyle: AppTextStyles.kTextLabel.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTextStyles.kTextLabel,
          tabs: const [
            Tab(text: 'As Renter'),
            Tab(text: 'As Host'),
          ],
        ),
      ),
      body: Builder(
        builder: (context) {
          switch (state.status) {
            case MyBookingsStatus.idle:
            case MyBookingsStatus.loading:
              return _LoadingList();
            case MyBookingsStatus.error:
              return Center(
                child: ErrorStateWidget(
                  message: state.errorMessage ?? 'Something went wrong',
                  onRetry: () =>
                      ref.read(myBookingsProvider.notifier).loadBookings(),
                ),
              );
            case MyBookingsStatus.loaded:
              return TabBarView(
                controller: _tabController,
                children: [
                  _BookingsList(
                    bookings: state.asRenter,
                    isHostView: false,
                    emptyTitle: 'No bookings yet',
                    emptySubtitle:
                        'Browse gear and make your first booking request',
                    onTapBooking: (booking) {
                      context.push(
                        '/booking-detail',
                        extra: booking,
                      ).then((_) {
                        ref
                            .read(myBookingsProvider.notifier)
                            .loadBookings();
                      });
                    },
                  ),
                  _BookingsList(
                    bookings: state.asHost,
                    isHostView: true,
                    emptyTitle: 'No bookings yet',
                    emptySubtitle:
                        'When renters book your gear, requests will appear here',
                    onTapBooking: (booking) {
                      context.push(
                        '/booking-detail',
                        extra: booking,
                      ).then((_) {
                        ref
                            .read(myBookingsProvider.notifier)
                            .loadBookings();
                      });
                    },
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.kSpacing12),
      itemBuilder: (context, index) => const LoadingSkeleton(
        width: double.infinity,
        height: 110,
        radius: AppSpacing.kRadiusLarge,
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  const _BookingsList({
    required this.bookings,
    required this.isHostView,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.onTapBooking,
  });

  final List<BookingEntity> bookings;
  final bool isHostView;
  final String emptyTitle;
  final String emptySubtitle;
  final void Function(BookingEntity booking) onTapBooking;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          title: emptyTitle,
          subtitle: emptySubtitle,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.kSpacing12),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return BookingListCard(
          booking: booking,
          isHostView: isHostView,
          onTap: () => onTapBooking(booking),
        );
      },
    );
  }
}
