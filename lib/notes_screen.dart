import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final Box notesBox = Hive.box('notesBox');
  final TextEditingController noteController = TextEditingController();

  User? get currentUser => FirebaseAuth.instance.currentUser;
  bool get isFirebaseUser => currentUser != null;

  // Add note
  Future<void> addNote() async {
    if (noteController.text.trim().isEmpty) return;

    final noteText = noteController.text.trim();
    final timestamp = DateTime.now();

    try {
      // 1. Save locally to Hive (for offline access)
      await notesBox.add({
        'content': noteText,
        'time': timestamp.toString(),
        'synced': isFirebaseUser,
      });

      // 2. Sync to Firestore if logged in
      if (isFirebaseUser) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .collection('notes')
            .add({
          'content': noteText,
          'time': timestamp,
        });
      }
    } catch (e) {
      debugPrint("Error adding note: $e");
    }

    noteController.clear();
    setState(() {});
  }

  void deleteNote(int index) {
    notesBox.deleteAt(index);
    setState(() {});
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool cloudActive = isFirebaseUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My CyberLogs"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: cloudActive ? Colors.green.shade50 : Colors.orange.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  cloudActive ? Icons.cloud_done : Icons.cloud_off,
                  color: cloudActive ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  cloudActive 
                    ? "Logged in as ${currentUser?.email}" 
                    : "Local Mode (No Cloud Sync)",
                  style: TextStyle(
                    color: cloudActive ? Colors.green.shade800 : Colors.orange.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Input Area
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: "Write a new log...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (_) => addNote(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: addNote,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Notes List
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: notesBox.listenable(),
              builder: (context, Box box, _) {
                if (box.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text("No logs yet. Start typing above!", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final note = box.getAt(index);
                    String content = "";
                    if (note is String) {
                      content = note;
                    } else if (note is Map) {
                      content = note['content'] ?? "";
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.description, size: 20)),
                        title: Text(content),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => deleteNote(index),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
