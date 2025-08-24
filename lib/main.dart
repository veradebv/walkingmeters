import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/walk_controller.dart';

void main () {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WalkingApp());
}

class WalkingApp extends StatelessWidget {
  const WalkingApp ({ super.key });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WalkController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0EA5E9)),
          useMaterial3: true,
        ),
      ),
    );
  }
}