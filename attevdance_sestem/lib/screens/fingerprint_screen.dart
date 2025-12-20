import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../api.dart'; // make sure runSensor is imported

class FingerprintScreen extends StatefulWidget {
  const FingerprintScreen({super.key});

  @override
  State<FingerprintScreen> createState() => _FingerprintScreenState();
}

class _FingerprintScreenState extends State<FingerprintScreen> {
  bool isLoading = false;
  String statusMessage = '';

  // Call runSensor with the given state
  Future<void> handleSensor(bool state) async {
    setState(() {
      isLoading = true;
      statusMessage =
          state ? 'Starting fingerprint scan...' : 'Stopping scan...';
    });

    final success = await runSensor(stats: state);

    setState(() {
      isLoading = false;
      statusMessage =
          success
              ? state
                  ? 'Fingerprint scan started successfully'
                  : 'Fingerprint scan stopped successfully'
              : 'Failed to ${state ? 'start' : 'stop'} scan';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/1-Select Instructor Screen.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: isLoading ? null : () => handleSensor(true),
                  child: const Text('Start Fingerprint Scan'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: isLoading ? null : () => handleSensor(false),
                  child: const Text('Stop Scanning'),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.list);
                  },
                  child: const Text('Attendance Table'),
                ),
                const SizedBox(height: 24),
                if (isLoading)
                  const CircularProgressIndicator()
                else if (statusMessage.isNotEmpty)
                  Text(
                    statusMessage,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
