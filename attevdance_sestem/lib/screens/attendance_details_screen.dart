import 'package:flutter/material.dart';
import '../../api.dart';
import '../../catoger_model.dart';

class AttendanceDetailsScreen extends StatefulWidget {
  const AttendanceDetailsScreen({super.key});

  @override
  State<AttendanceDetailsScreen> createState() =>
      _AttendanceDetailsScreenState();
}

class _AttendanceDetailsScreenState extends State<AttendanceDetailsScreen> {
  bool isLoading = true;
  Map<String, dynamic>? student;
  List<Map<String, dynamic>> activeHistory = [];
  String instructorId = '';
  String studentId = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      studentId = args['studentId'] ?? '';
      instructorId = args['instructorId'] ?? '';
      fetchStudentHistory();
    }
  }

  Future<void> fetchStudentHistory() async {
    if (studentId.isEmpty || instructorId.isEmpty) return;

    try {
      final data = await studentHistory(
        studentId: studentId,
        instructorId: instructorId,
      );

      setState(() {
        student =
            data['student'] != null
                ? Map<String, dynamic>.from(data['student'])
                : null;
        activeHistory =
            data['activeHistory'] != null
                ? List<Map<String, dynamic>>.from(
                  (data['activeHistory'] as List).map(
                    (e) => Map<String, dynamic>.from(e),
                  ),
                )
                : [];
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching student history: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(String? isoDate) {
    if (isoDate == null) return '';
    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return isoDate;
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  String formatTime(String? isoDate) {
    if (isoDate == null) return '';

    final dt = DateTime.tryParse(isoDate);
    if (dt == null) return '';

    // Add 2 hours
    final adjustedDate = dt.add(const Duration(hours: 2));

    int hour = adjustedDate.hour;
    final minute = adjustedDate.minute.toString().padLeft(2, '0');

    final isAm = hour < 12;
    final period = isAm ? 'AM' : 'PM';

    // Convert to 12-hour format
    hour = hour % 12;
    if (hour == 0) hour = 12;

    return "$hour:$minute $period";
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Attendance Details'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : student == null
                ? const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Card(
                        child: ListTile(
                          title: Text(student?['fullName']?.toString() ?? ''),
                          subtitle: Text(
                            'Section: ${student?['sectionId']?.toString() ?? ''}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: activeHistory.length,
                          itemBuilder: (_, index) {
                            final entry = activeHistory[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  formatDate(entry['date']?.toString()),
                                ),
                                subtitle: Text(
                                  "${formatTime(entry['date']?.toString())} - ${entry['status']?.toString() ?? ''}",
                                ),
                                trailing: Icon(
                                  entry['status']?.toString().toLowerCase() ==
                                          'present'
                                      ? Icons.check
                                      : Icons.close,
                                  color:
                                      entry['status']
                                                  ?.toString()
                                                  .toLowerCase() ==
                                              'present'
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
