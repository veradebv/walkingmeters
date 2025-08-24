import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walkingmeters/src/controller/history_controller.dart';
import '../controller/walk_controller.dart';
import '../controller/profile_controller.dart';
import '../model/walk_session_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final walk = context.watch<WalkController>();
    final profile = context.watch<ProfileController>().profile;
    final history = context.watch<HistoryController>().sessions;

    final meters = walk.distanceMeters;
    final km = meters / 1000.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Walking Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Profile section
            if (profile != null)
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: profile.profilePicture.isNotEmpty
                      ? AssetImage(profile.profilePicture) as ImageProvider
                      : const AssetImage('assets/avatar.png'),
                ),
                title: Text(profile.name),
                subtitle: Text(profile.email),
              )
            else
              const Text("No profile saved"),

            const SizedBox(height: 16),

            // Walk stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Distance"),
                    Text(
                      meters < 1000
                          ? '${meters.toStringAsFixed(0)} m'
                          : '${km.toStringAsFixed(2)} km',
                      style: const TextStyle(
                          fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text("Time"),
                    Text(
                      _format(walk.elapsed),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Walk controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => walk.start(),
                    child: const Text("Start")),
                ElevatedButton(
                    onPressed: () => walk.pause(),
                    child: const Text("Pause")),
                ElevatedButton(
                    onPressed: () {
                      final dist = walk.distanceMeters;
                      if (dist > 0) {
                        context.read<HistoryController>().addSession(dist);
                      }
                      walk.stop();
                    },
                    child: const Text("Stop")),
              ],
            ),

            const SizedBox(height: 16),

            // ✅ History
            const Text("History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final WalkSession s = history[index];
                  final km = s.distanceMeters / 1000;
                  return ListTile(
                    title: Text(
                        s.distanceMeters < 1000
                            ? '${s.distanceMeters.toStringAsFixed(0)} m'
                            : '${km.toStringAsFixed(2)} km',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(s.date.toLocal().toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}