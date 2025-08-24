import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/walk_controller.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Walking Tracker')),
      body: Consumer<WalkController>(
        builder: (context, walk, _) {
          final meters = walk.distanceMeters;
          final km = meters / 1000.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Distance',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        meters < 1000
                            ? '${meters.toStringAsFixed(0)} m'
                            : '${km.toStringAsFixed(2)} km',
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Time',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _format(walk.elapsed),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Walking path / map goes here',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}