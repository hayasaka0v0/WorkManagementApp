import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning/core/theme/app_pallete.dart';
import 'package:learning/features/auth/presentation/bloc/auth_bloc.dart';
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Column(
        children: [
          // Top 1/3: User Name (and Avatar)
          Expanded(
            flex: 1,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                String userName = 'User';
                String? email;
                
                if (state is AuthAuthenticated) {
                  userName = state.user.fullName ?? 'User';
                  email = state.user.email;
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppPallete.backgroundColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: AppPallete.gradient2,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: AppPallete.whiteColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (email != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppPallete.greyColor,
                              ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Bottom 2/3: Options List
          Expanded(
            flex: 2,
            child: Container(
              color: AppPallete.backgroundColor,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
                  _buildOptionTile(
                    context,
                    icon: Icons.settings_outlined,
                    title: 'Preferences',
                    onTap: () {},
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.question_mark,
                    title: 'FAQs',
                    onTap: () {},
                  ),
                  _buildOptionTile(
                    context,
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {},
                  ),
                  const Divider(height: 40),
                  _buildOptionTile(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    textColor: AppPallete.errorColor,
                    iconColor: AppPallete.errorColor,
                    onTap: () {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Card(
      elevation: 0,
      color: AppPallete.transparentColor,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? AppPallete.greyColor),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppPallete.greyColor),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppPallete.borderColor, width: 0.5),
        ),
      ),
    );
  }
}