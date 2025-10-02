import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'hurdle_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => HurdleProvider(),
      child: const MyApp(),
    ),
  );
}
