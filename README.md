### Class Definition
- A custom Log class was created to store each log entry:
- class Log {
  String action;
  DateTime timestamp;
  String status;

  Log(this.action, this.timestamp, this.status);
  }
- Classes help group related data and makes each log entry a reusable object.

### List of Log Objects
- A List<Log> was created with sample data:
- final List<Log> logs = [
  Log("Login Attempt", DateTime.now(), "Success"),
  Log("Password Change", DateTime.now().subtract(Duration(minutes: 10)), "Success"),
  Log("Invalid OTP", DateTime.now().subtract(Duration(hours: 1)), "Failed"),
  Log("Logout", DateTime.now().subtract(Duration(hours: 2)), "Success"),
  ];
- Lists allow storing multiple logs together and is easier to loop through and display.

### Displaying Logs Using a Loop
- map() was used to convert each Log object into a widget:
- children: logs.map((log) {
  return Padding(
  padding: const EdgeInsets.only(bottom: 12),
  child: Text(
  "${log.action} • ${log.timestamp} • Status: ${log.status}",
  style: const TextStyle(fontSize: 16),
  ),
  );
  }).toList(),
- map() automatically loops through the list and helps build multiple widgets efficiently this does not repeat code.

- ![WhatsApp Image 2025-12-10 at 17 26 53_1ecdce74](https://github.com/user-attachments/assets/65d412da-eef5-4ea0-800c-89e3f211c57e)
