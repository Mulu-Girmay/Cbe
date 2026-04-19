import 'package:flutter/material.dart';

const Color cbeGreen = Color(0xFF006B3F);
const Color cbeGold = Color(0xFFFFD700);

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: cbeGreen,
        elevation: 0,
        title: const Text(""),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "EN",
              style: TextStyle(color: cbeGold, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 3,
                shadowColor: cbeGreen.withOpacity(0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/images/cbe.jpg",
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Commercial Bank Of Ethiopia",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: cbeGreen,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "The Bank You Rely",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Mulu Girmay",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "123456789",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 170,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cbeGreen,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.flash_on, color: cbeGold),
                    label: const Text(
                      "Quick Pay",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cardGenerator("Telecom Service", Icons.phone),
                  cardGenerator("Transfer", Icons.account_balance),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cardGenerator("Booking", Icons.home),
                  cardGenerator("Service", Icons.design_services),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Card cardGenerator(String text, IconData icon) {
  return Card(
    elevation: 1.5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Container(
      width: 155,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: cbeGreen),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: cbeGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
