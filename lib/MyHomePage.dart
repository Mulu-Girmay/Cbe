import 'package:flutter/material.dart';

const Color cbeGreen = Color(0xFF006B3F);
const Color cbeGold = Color(0xFFFFD700);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: cbeGreen,
        elevation: 0,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.white),
          onSelected: (value) {},
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: 'pin',
              child: Row(
                children: [
                  Icon(Icons.key, color: cbeGreen),
                  SizedBox(width: 8),
                  Text('Change PIN'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: cbeGreen),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'FAQ',
              child: Row(
                children: [
                  Icon(Icons.question_answer, color: cbeGreen),
                  SizedBox(width: 8),
                  Text('FAQ'),
                ],
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "EN",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {},
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/images/cbe.jpg",
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Commercial Bank Of Ethiopia",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: cbeGreen,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "The Bank You can always Rely on",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          "Mulu Girmay Gebru",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "1234 567 890",
                            style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.copy, size: 16, color: Colors.black54),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "***** Birr",
                        style: TextStyle(color: Colors.black54),
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
              const SizedBox(height: 8),
              const Text(
                "Services",
                style: TextStyle(color: cbeGreen, fontWeight: FontWeight.w600),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: cbeGreen,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "Receive money",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accounts"),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Recents"),
        ],
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
