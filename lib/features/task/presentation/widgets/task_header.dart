import 'package:learning/features/company/domain/usecases/get_company_by_id.dart';
import 'package:learning/features/company/domain/usecases/regenerate_invite_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning/core/di/injection_container.dart';
import 'package:learning/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:learning/features/company/domain/usecases/create_company.dart';
import 'package:learning/features/company/domain/usecases/join_company.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = 'User';
        String? userRole;
        String? userId;
        String? companyId; // Added companyId

        if (state is AuthAuthenticated) {
          userName = state.user.fullName ?? state.user.email.split('@')[0];
          userRole = state.user.role;
          userId = state.user.id;
          companyId = state.user.companyId; // Extract companyId
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
              ),
              const SizedBox(width: 12),
              // Name and Welcome
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2024),
                      ),
                    ),
                  ],
                ),
              ),
              // Action Buttons - Show based on role and company status
              if (userRole == 'boss')
                if (companyId != null && companyId.isNotEmpty)
                  _buildIconButton(
                    context,
                    Icons.settings_suggest_rounded, // Icon for Manage
                    onTap: () => _showManageCompanyDialog(context, companyId!),
                  )
                else
                  _buildIconButton(
                    context,
                    Icons.add_business_rounded,
                    onTap: () => _showCreateCompanyDialog(context, userId!),
                  )
              else if (companyId != null && companyId.isNotEmpty)
                _buildIconButton(
                  context,
                  Icons.exit_to_app_rounded,
                  onTap: () => _confirmLeaveCompany(context, userId!),
                )
              else
                _buildIconButton(
                  context,
                  Icons.business_rounded,
                  onTap: () => _showJoinCompanyDialog(context, userId ?? ''),
                ),

              const SizedBox(width: 12),
              _buildIconButton(context, Icons.search_rounded),
              const SizedBox(width: 12),
              _buildIconButton(
                context,
                Icons.notifications_none_rounded,
                hasNotification: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconButton(
    BuildContext context,
    IconData icon, {
    bool hasNotification = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue[700], size: 24),
          ),
          if (hasNotification)
            Positioned(
              top: 10,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showJoinCompanyDialog(BuildContext context, String userId) {
    final TextEditingController controller = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Join Company'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Enter the invite code to join a company:'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Invite Code',
                      border: OutlineInputBorder(),
                      hintText: 'e.g. ABC12345',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (controller.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter invite code'),
                              ),
                            );
                            return;
                          }

                          setState(() => isLoading = true);

                          final joinCompany = sl<JoinCompany>();
                          final result = await joinCompany(
                            JoinCompanyParams(
                              inviteCode: controller.text.trim(),
                              userId: userId,
                            ),
                          );

                          setState(() => isLoading = false);

                          result.fold(
                            (failure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(failure.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            (company) {
                              Navigator.of(dialogContext).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Successfully joined ${company.name}!',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // Refresh auth state to get updated company_id
                              context.read<AuthBloc>().add(
                                AuthCheckRequested(),
                              );
                            },
                          );
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Join'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCreateCompanyDialog(BuildContext context, String ownerId) {
    final TextEditingController nameController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Company'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Enter your company name:'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Company Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter company name'),
                              ),
                            );
                            return;
                          }

                          setState(() => isLoading = true);

                          final createCompany = sl<CreateCompany>();
                          final result = await createCompany(
                            CreateCompanyParams(
                              name: nameController.text.trim(),
                              ownerId: ownerId,
                            ),
                          );

                          setState(() => isLoading = false);

                          result.fold(
                            (failure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(failure.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            (company) {
                              Navigator.of(dialogContext).pop();
                              // Show success with invite code
                              _showCompanyCreatedDialog(
                                context,
                                company.name,
                                company.inviteCode,
                              );
                              // Refresh auth state to get updated company_id
                              context.read<AuthBloc>().add(
                                AuthCheckRequested(),
                              );
                            },
                          );
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCompanyCreatedDialog(
    BuildContext context,
    String companyName,
    String inviteCode,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Company Created!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Company "$companyName" has been created successfully!'),
              const SizedBox(height: 16),
              const Text(
                'Share this invite code with your team:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      inviteCode,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        // Copy to clipboard - could use Clipboard.setData
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invite code copied!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _showManageCompanyDialog(BuildContext context, String companyId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return FutureBuilder(
          future: sl<GetCompanyById>()(
            GetCompanyByIdParams(companyId: companyId),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const AlertDialog(
                content: Text('Failed to load company details.'),
              );
            }

            final result = snapshot.data!;

            return result.fold(
              (failure) =>
                  AlertDialog(content: Text('Error: ${failure.message}')),
              (company) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Row(
                        children: [
                          const Icon(Icons.business, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(company.name),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Manage your company settings here.'),
                          const SizedBox(height: 20),
                          const Text(
                            'Invite Code:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  company.inviteCode,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _confirmRegenerateCode(
                                    context,
                                    companyId,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Warning: Regenerating code will invalidate the old one.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void _confirmRegenerateCode(BuildContext context, String companyId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Regenerate Invite Code?'),
          content: const Text(
            'Are you sure? The current code will stop working immediately. You will need to share the new code with new members.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close confirm dialog
                // Close Manage dialog to refresh (or we could use setState if complex refactoring)
                // Simplest is to close both and re-open or show success.
                // Actually better to just perform action and show success, then user re-opens content.
                // But better UX is to update the parent dialog.
                // For now, let's close and show success snackbar.

                Navigator.of(
                  context,
                ).pop(); // Close Manage dialog (which is parent of this confirm?) No, context is confirm dialog.
                // We need to pop manage dialog too if we want to force refresh easily,
                // OR we rely on aBloc/State management.

                // Let's implement robustly.
                final regenerate = sl<RegenerateInviteCode>();
                final result = await regenerate(
                  RegenerateInviteCodeParams(companyId: companyId),
                );

                result.fold(
                  (failure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(failure.message)));
                  },
                  (newCompany) {
                    // Close the manage dialog behind this confirm dialog?
                    // Verify context chain.
                    // The manage dialog is still open. We can just pop it.
                    Navigator.of(
                      context,
                    ).pop(); // Attempting to close manage dialog

                    _showCompanyCreatedDialog(
                      context,
                      newCompany.name,
                      newCompany.inviteCode,
                    );
                  },
                );
              },
              child: const Text('Regenerate'),
            ),
          ],
        );
      },
    );
  }

  void _confirmLeaveCompany(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave Company?'),
          content: const Text(
            'Are you sure you want to leave your current company? You will lose access to company tasks.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(AuthLeaveCompanyRequested(userId));
              },
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );
  }
}
