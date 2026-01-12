import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/user.dart';

class ActivityLogsScreen extends StatefulWidget {
  final UserModel currentUser;
  const ActivityLogsScreen({super.key, required this.currentUser});

  @override
  State<ActivityLogsScreen> createState() => _ActivityLogsScreenState();
}

class _ActivityLogsScreenState extends State<ActivityLogsScreen> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<dynamic> _logs = [];

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    setState(() => _isLoading = true);
    try {
      final data = await supabase
          .from('activity_logs')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _logs = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CC),
      appBar: AppBar(
        title: const Text("System Logs", style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchLogs,
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[index];
                  final DateTime date = DateTime.parse(log['created_at']).toLocal();
                  final String formattedDate = DateFormat('dd MMM, hh:mm a').format(date);

                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: log['role'] == 'owner' ? Colors.blue : Colors.orange,
                        child: Icon(
                          log['action'].toString().contains('DELETE') ? Icons.warning : Icons.info,
                          color: Colors.white, size: 18,
                        ),
                      ),
                      title: Text("${log['user_name']} - ${log['action']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${log['details']}", style: const TextStyle(fontSize: 13)),
                          Text(formattedDate, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}