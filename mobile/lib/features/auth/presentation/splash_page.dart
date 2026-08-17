import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/main_shell.dart';

class SplashPage extends StatefulWidget {
const SplashPage({super.key});

@override
State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
@override
void initState() {
super.initState();

Timer(
const Duration(seconds: 2),
() {
if (!mounted) return;

Navigator.of(context).pushReplacement(
MaterialPageRoute(
builder: (_) => const MainShell(),
),
);
},
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: Center(
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Container(
width: 88,
height: 88,
decoration: BoxDecoration(
color: const Color(0xFF5B5FEF),
borderRadius: BorderRadius.circular(24),
),
child: const Icon(
Icons.account_balance_wallet_rounded,
color: Colors.white,
size: 46,
),
),
const SizedBox(height: 20),
const Text(
'Splitly',
style: TextStyle(
fontSize: 32,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 8),
const Text(
'Split expenses. Stay even.',
style: TextStyle(
color: Colors.grey,
fontSize: 15,
),
),
const SizedBox(height: 32),
const SizedBox(
width: 24,
height: 24,
child: CircularProgressIndicator(
strokeWidth: 2.5,
),
),
],
),
),
);
}
}

