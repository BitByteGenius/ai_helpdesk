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
                "Welcome Back 👋",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 6),

              Text(
                "Rahul",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 5),

              Text(
                "Manage your support tickets efficiently.",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {},

          icon: Stack(
            children: [

              const Icon(
                Icons.notifications_none,
                
                size: 30,
              ),

              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            ],
          ),
        ),

        const SizedBox(width: 15),

        const CircleAvatar(
          radius: 24,
          child: Icon(Icons.person),
        ),
      ],
    );
  }
}