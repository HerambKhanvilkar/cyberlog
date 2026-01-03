import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:project/gatekeeper_screen.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final TextEditingController controller = TextEditingController();

  // --- Start of Encryption Fix ---
  // Corrected the IV to be exactly 16 characters long.
  static final key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // Must be 32 chars
  static final iv = encrypt.IV.fromUtf8('my16lengthsecret'); // MUST be 16 chars
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  // --- End of Encryption Fix ---

  Future<void> _authenticateAndUnlock() async {
    final auth = LocalAuthentication();
    try {
      final success = await auth.authenticate(
        localizedReason: 'Authenticate to unlock Vault',
      );
      if (mounted && success) {
        context.read<LockProvider>().unlock();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _encryptAndSave(String plainText) async {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    await Hive.box('vault').add(encrypted.base64);
    controller.clear();
  }

  String _decrypt(dynamic encryptedText) {
    if (encryptedText is! String) return '[Invalid Data]';
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedText);
      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      return '[Unreadable Note]';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<LockProvider>().isUnlocked) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 80),
            const SizedBox(height: 20),
            const Text("Vault Locked", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.fingerprint),
              label: const Text("Authenticate"),
              onPressed: _authenticateAndUnlock,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: "Add Secure Note",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    _encryptAndSave(controller.text);
                  }
                },
                child: const Text("Save to Vault"),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: Hive.box('vault').listenable(),
            builder: (context, Box box, _) {
              if (box.isEmpty) {
                return const Center(child: Text("Your vault is empty."));
              }
              return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final decryptedNote = _decrypt(box.getAt(index));
                  final isError = decryptedNote.startsWith('[');

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: Icon(isError ? Icons.warning_amber_rounded : Icons.lock_open),
                      title: Text(decryptedNote),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => box.deleteAt(index),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
