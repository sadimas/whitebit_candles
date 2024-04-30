import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:whitebit_app/repositories/candle_repository.dart';
import 'repositories/abstract_repository.dart';
import 'screens/home_screen.dart';

void main() {
  GetIt.I.registerSingleton<CandleProvider>(CandleRepository(dio: Dio()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(title: 'Candles Whitebit BTC/USDT 15m'),
    );
  }
}


