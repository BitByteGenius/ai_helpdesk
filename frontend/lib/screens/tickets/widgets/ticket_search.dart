import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/controllers/ticket_controller.dart';
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
      const Duration(milliseconds: 500),
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
        hintText: "Search tickets...",
        prefixIcon: const Icon(Icons.search),

        suffixIcon: Obx(() {
          if (controller.searchController.text.isEmpty) {
            return const SizedBox.shrink();
          }

          return IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              controller.searchController.clear();
              controller.searchTickets("");
            },
          );
        }),

        filled: true,
        fillColor: Colors.grey.shade100,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}