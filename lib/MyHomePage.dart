import 'package:flutter/material.dart';

const Color cbeGreen = Color(0xFF006B3F);
const Color cbeGold = Color(0xFFFFD700);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showKeypad = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _showKeypad = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildKey(String label, {IconData? icon}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(4),
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: cbeGreen, width: 1.5),
          color: cbeGreen.withOpacity(0.08),
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: cbeGreen)
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: cbeGreen,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildKey("1"), _buildKey("2"), _buildKey("3")],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildKey("4"), _buildKey("5"), _buildKey("6")],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_buildKey("7"), _buildKey("8"), _buildKey("9")],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKey("Enter"),
            _buildKey("0"),
            _buildKey("", icon: Icons.backspace),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: cbeGreen,
        title: const Text(
          "CBE Mobile Banking",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
              style: TextStyle(color: cbeGold, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset("assets/images/cbe.jpg", height: 100),
              const SizedBox(height: 16),
              const Text(
                "Welcome to CBE Mobile Banking",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: cbeGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                "Commercial Bank of Ethiopia",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              TextField(
                focusNode: _focusNode,
                readOnly: true,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Enter PIN",
                  labelStyle: const TextStyle(color: cbeGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: cbeGreen, width: 2),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: cbeGreen),
                ),
              ),
              const SizedBox(height: 16),
              if (_showKeypad) _buildKeypad(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cbeGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cbeGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: cbeGreen.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.question_answer, color: cbeGreen),
                    const SizedBox(width: 8),
                    const Text(
                      "Ask a question",
                      style: TextStyle(color: cbeGreen),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Chat Bot",
                        style: TextStyle(
                          color: cbeGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "© Copyright 2024 CBE All rights reserved",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
