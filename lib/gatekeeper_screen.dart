import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

// Consolidating LockProvider here to resolve import issues.
class LockProvider extends ChangeNotifier {
  bool _isUnlocked = false;

  bool get isUnlocked => _isUnlocked;

  void unlock() {
    _isUnlocked = true;
    notifyListeners();
  }

  void lock() {
    _isUnlocked = false;
    notifyListeners();
  }
}

class GatekeeperScreen extends StatelessWidget {
  const GatekeeperScreen({super.key});

  Future<void> authenticate(BuildContext context) async {
    final auth = LocalAuthentication();

    try {
      final success = await auth.authenticate(
        localizedReason: 'Authenticate to unlock Vault',
      );

      if (success) {
        context.read<LockProvider>().unlock();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vault Unlocked")),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Authentication Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.fingerprint),
        label: const Text("Authenticate"),
        onPressed: () => authenticate(context),
      ),
    );
  }
}
