import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bs/Feature/home/cubit/home_cubit.dart';
import 'package:bs/Feature/home/cubit/home_state.dart';
import 'package:bs/Feature/home/view/widgets/schedule_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeLoadStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == HomeLoadStatus.failure) {
          return Center(child: Text(state.error ?? "Something went wrong"));
        }

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 12),

            /// SUMMARY CARDS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _SummaryCard(title: 'Total', value: state.total.toString()),
                  const SizedBox(width: 12),
                  _SummaryCard(
                    title: 'Completed',
                    value: state.completed.toString(),
                    valueColor: const Color(0xFF2ECC71),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// PENDING CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _PendingCard(pending: state.pending),
            ),

            const SizedBox(height: 20),

            /// TITLE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Today's Appointments",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),

            const SizedBox(height: 8),

            /// LIST / EMPTY VIEW
            if (state.schedules.isEmpty)
              const _NoAppointmentView()
            else
              ...state.schedules.map((e) => ScheduleCard(item: e)),

            const SizedBox(height: 100),
          ],
        );
      },
    );
  }
}

/// --------------------------------------------------
/// SUMMARY CARD
/// --------------------------------------------------
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    this.valueColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 92,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// --------------------------------------------------
/// PENDING CARD
/// --------------------------------------------------
class _PendingCard extends StatelessWidget {
  final int pending;

  const _PendingCard({required this.pending});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pending',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const Spacer(),
          Text(
            pending.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFFFFA000),
            ),
          ),
        ],
      ),
    );
  }
}

/// --------------------------------------------------
/// EMPTY STATE
/// --------------------------------------------------
class _NoAppointmentView extends StatelessWidget {
  const _NoAppointmentView();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: const [
          Icon(Icons.event_busy, size: 48, color: Colors.black38),
          SizedBox(height: 12),
          Text(
            'No appointment booked',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'You don’t have any appointments scheduled for today.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
