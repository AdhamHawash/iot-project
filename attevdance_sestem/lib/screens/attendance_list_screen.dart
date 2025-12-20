import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../catoger_model.dart';
import '../../api.dart'; // تأكد أن getSection موجودة هنا

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({super.key});

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  bool isLoading = true;
  List<dynamic> students = [];
  String sectionName = '';

  @override
  void initState() {
    super.initState();
    fetchSectionData();
  }

  Future<void> fetchSectionData() async {
    final selected = CatogerModel.selected;
    if (selected == null) return;

    try {
      final data = await getSection(
        sectionId: selected.sectionId,
        instructorId: selected.id,
      );
      setState(() {
        students = data; // قائمة الطلاب
        sectionName = data.isNotEmpty ? data[0]['sectionName'] ?? '' : '';
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching section: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = CatogerModel.selected;

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
          title: const Text('Attendance List'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : selected == null || students.isEmpty
                ? const Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        showCheckboxColumn:
                            false, // ✅ هذا يمنع ظهور أي CheckBox
                        columns: const [
                          DataColumn(label: Text('Student Name')),
                          DataColumn(label: Text('Student ID')),
                          DataColumn(label: Text('Attendance %')),
                        ],
                        rows:
                            students.map((student) {
                              return DataRow(
                                onSelectChanged: (_) {
                                  final studentId =
                                      student['_id']?.toString() ?? '';
                                  if (studentId.isNotEmpty) {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.details,
                                      arguments: {
                                        'studentId': studentId,
                                        'instructorId':
                                            CatogerModel.selected?.id,
                                      },
                                    );
                                  }
                                },
                                cells: [
                                  DataCell(Text(student['fullName'] ?? '')),
                                  DataCell(Text(student['studentCode'] ?? '')),
                                  DataCell(
                                    Text(
                                      student['countAttendPercent'] != null
                                          ? '${(student['countAttendPercent'] as num) % 1 == 0 ? (student['countAttendPercent'] as num).toInt() : (student['countAttendPercent'] as num).toStringAsFixed(2)}%'
                                          : '0%',
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
  