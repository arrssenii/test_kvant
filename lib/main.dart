// import 'package:flutter/material.dart';
// import 'web_layout.dart';
// 
// void main() {
//   runApp(const MyWebApp());
// }
// 
// class MyWebApp extends StatelessWidget {
//   const MyWebApp({super.key});
// 
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Сайт с JSON-сайдбаром',
//       home: WebLayout(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'web_layout.dart';

void main() {
  runApp(const MyWebApp());
}

/// Основной виджет приложения
class MyWebApp extends StatelessWidget {
  const MyWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Сайт с JSON-сайдбаром',
      home: WebLayout(), // Запуск основного layout'а
      debugShowCheckedModeBanner: false,
    );
  }
}

