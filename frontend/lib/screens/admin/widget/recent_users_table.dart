import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/user_model.dart';
import 'package:intl/intl.dart';

class RecentUsersTable extends StatelessWidget {
  final List<UserModel> users;

  const RecentUsersTable({
    super.key,
    required this.users,
  });

  Color _roleColor(String role) {
    switch (role.toLowerCase()) {
      case "admin":
        return AppColors.purple;
      case "manager":
        return AppColors.warning;
      case "support":
        return AppColors.info;
      default:
        return AppColors.success;
    }
  }

  IconData _roleIcon(String role) {
    switch (role.toLowerCase()) {
      case "admin":
        return Icons.admin_panel_settings_rounded;
      case "manager":
        return Icons.manage_accounts_rounded;
      case "support":
        return Icons.support_agent_rounded;
      default:
        return Icons.person_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Users",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.surfaceSubtle,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${users.length} Active",
                  style: TextStyle(
                    color: context.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (users.isEmpty)
            SizedBox(
              height: 120,
              child: Center(
                child: Text(
                  "No users registered yet",
                  style: TextStyle(color: context.textMuted, fontSize: 13),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (_, _) => Divider(height: 16, color: context.borderLight),
              itemBuilder: (context, index) {
                final user = users[index];
                return _UserRow(
                  user: user,
                  roleColor: _roleColor(user.role),
                  roleIcon: _roleIcon(user.role),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  final UserModel user;
  final Color roleColor;
  final IconData roleIcon;

  const _UserRow({
    required this.user,
    required this.roleColor,
    required this.roleIcon,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 800;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: context.primarySubtle,
            backgroundImage: user.profileImage.isNotEmpty
                ? NetworkImage(user.profileImage)
                : null,
            child: user.profileImage.isEmpty
                ? Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: context.primaryColor,
                      fontSize: 14,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name.isNotEmpty ? user.name : "Unnamed User",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: context.textPrimary,
                  ),
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (isDesktop && user.phone.isNotEmpty) ...[
            Text(
              user.phone,
              style: TextStyle(
                fontSize: 12,
                color: context.textSecondary,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: roleColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(roleIcon, size: 12, color: roleColor),
                const SizedBox(width: 4),
                Text(
                  user.role.toUpperCase(),
                  style: TextStyle(
                    color: roleColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          if (isDesktop && user.createdAt != null) ...[
            const SizedBox(width: 16),
            Text(
              DateFormat("dd MMM yyyy").format(user.createdAt!),
              style: TextStyle(
                fontSize: 11,
                color: context.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}