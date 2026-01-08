import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const DeviceInfoApp());
}

class DeviceInfoApp extends StatelessWidget {
  const DeviceInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CyberLog Settings',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: const DeviceModelScreen(),
    );
  }
}

class DeviceModelScreen extends StatefulWidget {
  const DeviceModelScreen({super.key});

  @override
  State<DeviceModelScreen> createState() => _DeviceModelScreenState();
}

class _DeviceModelScreenState extends State<DeviceModelScreen> {
  static const MethodChannel platform =
  MethodChannel('device_info_channel');

  String _deviceModel = 'Tap button to fetch';
  String _androidVersion = '...';

  Future<void> _getDeviceInfo() async {
    String deviceModel;
    String androidVersion;
    try {
      deviceModel = await platform.invokeMethod('getDeviceModel');
      androidVersion = await platform.invokeMethod('getAndroidVersion');
    } on PlatformException catch (e) {
      deviceModel = "Failed: ${e.message}";
      androidVersion = "Failed to get version.";
    }
    setState(() {
      _deviceModel = deviceModel;
      _androidVersion = "Android $androidVersion";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueGrey, Colors.black87],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  Icon(Icons.security, color: Colors.white, size: 50),
                  SizedBox(height: 10),
                  Text(
                    'CyberLog Security',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Device Information',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// Device Info Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.phone_android,
                        size: 40, color: Colors.blueGrey),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Device Model',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _deviceModel,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            /// Android Version Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.android,
                        size: 40, color: Colors.green),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Android Version',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _androidVersion,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            /// Button
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.info_outline),
                  label: const Text(
                    'Get Device Info',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _getDeviceInfo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
