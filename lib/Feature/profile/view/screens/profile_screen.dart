import 'package:bs/Core/Util/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:bs/Feature/profile/cubit/profile_cubit.dart';
import 'package:bs/Feature/profile/cubit/profile_state.dart';
import 'package:bs/Feature/profile/repo/profile_repo.dart';
import 'package:bs/Feature/profile/services/profile_service.dart';
import 'package:bs/Feature/profile/view/widgets/profile_menu_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(ProfileRepo(ProfileService()))..loadProfile(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileLoadStatus.loggedOut) {
            context.go(Routes.login);
          }
        },
        builder: (context, state) {
          if (state.status == ProfileLoadStatus.loading ||
              state.status == ProfileLoadStatus.loggingOut) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProfileLoadStatus.failure) {
            return Center(child: Text(state.error ?? 'Something went wrong'));
          }

          final profile = state.profile!;

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            children: [
              _ProfileHeader(profile: profile),

              const SizedBox(height: 30),

              _Section(
                title: 'Management',
                children: [
                  ProfileMenuTile(
                    icon: Icons.storefront_outlined,
                    title: 'Edit Salon Details',
                    onTap: () {},
                  ),
                  ProfileMenuTile(
                    icon: Icons.group_outlined,
                    title: 'Manage Staff',
                    onTap: () {},
                  ),
                  ProfileMenuTile(
                    icon: Icons.credit_card_outlined,
                    title: 'Manage Subscription',
                    onTap: () {},
                  ),
                ],
              ),

              _Section(
                title: 'Analytics & Support',
                children: [
                  ProfileMenuTile(
                    icon: Icons.bar_chart_outlined,
                    title: 'View Reports',
                    onTap: () {},
                  ),
                  ProfileMenuTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                ],
              ),

              _Section(
                title: 'Account',
                children: [
                  ProfileMenuTile(
                    icon: Icons.settings_outlined,
                    title: 'Account Settings',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    context.read<ProfileCubit>().logout();
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final profile;
  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: Colors.teal.shade100,
          child: const Icon(Icons.store, size: 40, color: Colors.black54),
        ),
        const SizedBox(height: 12),
        Text(
          profile.salonName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(profile.ownerName, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
