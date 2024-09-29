import 'package:flutter/material.dart';

import 'categories_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
          color: Color.fromARGB(255, 239, 238, 237), child: CategoriesScreen()),
    );
  }
}
