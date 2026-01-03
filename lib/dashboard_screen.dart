import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String deviceInfo = "Loading...";
  String publicIP = "Loading...";
  final List<Map<String, String>> securityTips = [
    {
      'title': 'Enable Two-Factor Authentication',
      'subtitle': '2FA adds an extra layer of security to your online accounts.'
    },
    {
      'title': 'Use Strong, Unique Passwords',
      'subtitle': 'Avoid using the same password across multiple websites.'
    },
    {
      'title': 'Beware of Phishing Scams',
      'subtitle': 'Don\'t click on suspicious links or open attachments from unknown senders.'
    },
    {
      'title': 'Keep Your Software Updated',
      'subtitle': 'Software updates often contain important security patches.'
    },
    {
      'title': 'Use a VPN on Public Wi-Fi',
      'subtitle': 'A VPN encrypts your internet connection to protect your data from eavesdroppers.'
    }
  ];

  @override
  void initState() {
    super.initState();
    fetchDeviceInfo();
    fetchPublicIP();
  }

  Future<void> fetchDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    try {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      setState(() {
        deviceInfo =
        "${androidInfo.model} (Android ${androidInfo.version.release})";
      });
    } catch (e) {
      setState(() {
        deviceInfo = "Unable to fetch device info";
      });
    }
  }

  Future<void> fetchPublicIP() async {
    try {
      final response =
      await http.get(Uri.parse("https://api.ipify.org?format=json"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          publicIP = data['ip'];
        });
      }
    } catch (e) {
      setState(() {
        publicIP = "No Internet";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Device Status",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Card(
            child: ListTile(
              leading: const Icon(Icons.phone_android),
              title: const Text("Device"),
              subtitle: Text(deviceInfo),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.wifi),
              title: const Text("Public IP"),
              subtitle: Text(publicIP),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            "Security Feed",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: securityTips.length,
            itemBuilder: (context, index) {
              final tip = securityTips[index];
              return Card(
                color: Colors.blueGrey.shade800,
                child: ListTile(
                  leading: const Icon(Icons.security),
                  title: Text(tip['title']!),
                  subtitle: Text(tip['subtitle']!),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
