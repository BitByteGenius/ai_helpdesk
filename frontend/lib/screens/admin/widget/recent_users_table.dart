import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/user_model.dart';

class RecentUsersTable extends StatelessWidget {
  final List<UserModel> users;

  const RecentUsersTable({
    super.key,
    required this.users,
  });

  Color _roleColor(String role) {
    switch (role.toLowerCase()) {
      case "admin":
        return Colors.red;

      case "manager":
        return Colors.orange;

      case "support":
        return Colors.blue;

      default:
        return Colors.green;
    }
  }

  IconData _roleIcon(String role) {
    switch (role.toLowerCase()) {
      case "admin":
        return Icons.admin_panel_settings;

      case "manager":
        return Icons.manage_accounts;

      case "support":
        return Icons.support_agent;

      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              children: [

                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.people_alt_rounded,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Recent Users",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "${users.length} user${users.length == 1 ? "" : "s"}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                FilledButton.icon(
                  onPressed: () {
                    // TODO: Navigate to users page
                  },
                  icon: const Icon(Icons.people),
                  label: const Text("View All"),
                ),
              ],
            ),

            const SizedBox(height: 28),

            if (users.isEmpty)
              SizedBox(
                height: 250,
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [

                      Icon(
                        Icons.people_outline,
                        size: 70,
                        color: Colors.grey.shade400,
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "No Users Found",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "New registered users will appear here.",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {

                  final user = users[index];

                  return _UserTile(
                    user: user,
                    roleColor: _roleColor(user.role),
                    roleIcon: _roleIcon(user.role),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}


class _UserTile extends StatelessWidget {
  final UserModel user;
  final Color roleColor;
  final IconData roleIcon;

  const _UserTile({
    required this.user,
    required this.roleColor,
    required this.roleIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth > 900;

            if (desktop) {
              return Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.indigo.shade100,
                    backgroundImage: user.profileImage.isNotEmpty
                        ? NetworkImage(user.profileImage)
                        : null,
                    child: user.profileImage.isEmpty
                        ? Text(
                            user.name.isEmpty
                                ? "?"
                                : user.name[0].toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          )
                        : null,
                  ),

                  const SizedBox(width: 18),

                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            roleColor.withValues(alpha: .12),
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Icon(
                            roleIcon,
                            size: 16,
                            color: roleColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            user.role.toUpperCase(),
                            style: TextStyle(
                              color: roleColor,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 30),

                  SizedBox(
                    width: 140,
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user.phone.isEmpty
                                ? "-"
                                : user.phone,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 30),

                  SizedBox(
                    width: 150,
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          user.createdAt == null
                              ? "-"
                              : DateFormat(
                                  "dd MMM yyyy",
                                ).format(
                                  user.createdAt!,
                                ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  PopupMenuButton(
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 1,
                        child: Text("View"),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text("Edit"),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Text("Delete"),
                      ),
                    ],
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          Colors.indigo.shade100,
                      backgroundImage:
                          user.profileImage.isNotEmpty
                              ? NetworkImage(
                                  user.profileImage,
                                )
                              : null,
                      child:
                          user.profileImage.isEmpty
                              ? Text(
                                  user.name.isEmpty
                                      ? "?"
                                      : user.name[0]
                                          .toUpperCase(),
                                )
                              : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(user.email),

                const SizedBox(height: 8),

                Text(
                  "Phone : ${user.phone}",
                ),

                const SizedBox(height: 8),

                Text(
                  "Role : ${user.role}",
                ),

                const SizedBox(height: 8),

                Text(
                  user.createdAt == null
                      ? "-"
                      : DateFormat("dd MMM yyyy")
                          .format(
                          user.createdAt!,
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}