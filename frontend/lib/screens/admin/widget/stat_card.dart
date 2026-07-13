import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Get.width >= 1200;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(isDesktop ? 22 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Container(
                  height: isDesktop ? 55 : 48,
                  width: isDesktop ? 55 : 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .12),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: isDesktop ? 30 : 26,
                  ),
                ),

                const Spacer(),

                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),

            const Spacer(),

            Text(
              value,
              style: TextStyle(
                fontSize: isDesktop ? 34 : 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: isDesktop ? 17 : 15,
              ),
            ),

            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 13,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}