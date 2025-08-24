import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walkingmeters/src/controller/history_controller.dart';
import 'package:walkingmeters/src/controller/profile_controller.dart';
import 'package:walkingmeters/src/model/profile_model.dart';
import 'package:walkingmeters/src/model/walk_session_model.dart';
import 'src/controller/walk_controller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/ui/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(ProfileAdapter());
  Hive.registerAdapter(WalkSessionAdapter());

  // Open Boxes (like local databases)
  await Hive.openBox<Profile>('profileBox');
  await Hive.openBox<WalkSession>('historyBox');

  runApp(const WalkingApp());
}

class WalkingApp extends StatelessWidget {
  const WalkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalkController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => HistoryController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0EA5E9)),
          useMaterial3: true,
        ),
        // 👇 This was missing
        home: const HomeScreen(),
      ),
    );
  }
}
