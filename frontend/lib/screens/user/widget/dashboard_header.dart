import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final bool mobile =
        MediaQuery.of(context).size.width < 700;

    return Row(
      children: [

        if (mobile)
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: const [

              Text(
                "Welcome Back ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 6),


              Text(
                "Manage your support tickets efficiently.",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),

        
      ],
    );
  }
}