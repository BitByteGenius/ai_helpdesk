import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

class TicketSearch extends StatefulWidget {
  const TicketSearch({super.key});

  @override
  State<TicketSearch> createState() => _TicketSearchState();
}

class _TicketSearchState extends State<TicketSearch> {
  final TicketController controller = Get.find<TicketController>();

  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(
      const Duration(milliseconds: 400),
      () {
        controller.searchTickets(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.searchController,
      onChanged: _onSearch,
      decoration: InputDecoration(
        hintText: "Search tickets by title, description, or requester...",
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.textSecondary),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller.searchController,
          builder: (context, value, _) {
            if (value.text.isEmpty) {
              return const SizedBox.shrink();
            }

            return IconButton(
              icon: const Icon(Icons.close_rounded, size: 16),
              onPressed: () {
                controller.searchController.clear();
                controller.searchTickets("");
              },
            );
          },
        ),
        filled: true,
        fillColor: AppColors.surfaceSubtle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

