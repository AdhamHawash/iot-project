import 'package:flutter/material.dart';
import 'package:attevdance_sestem/api.dart';
import '../../../routes/app_routes.dart';
import '../catoger_model.dart';

class SelectInstructorScreen extends StatefulWidget {
  const SelectInstructorScreen({super.key});

  @override
  State<SelectInstructorScreen> createState() => _SelectInstructorScreenState();
}

class _SelectInstructorScreenState extends State<SelectInstructorScreen> {
  List<CatogerModel> instructors = []; // typed list
  CatogerModel? selectedInstructor; // nullable selected instructor
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInstructors();
  }

  Future<void> fetchInstructors() async {
    try {
      final data = await getInstructors(); // List<dynamic> from API

      // Convert JSON → CatogerModel
      final converted =
          data.map<CatogerModel>((inst) {
            return CatogerModel(id: inst['_id'], name: inst['fullName'] , sectionId: "");
          }).toList();

      setState(() {
        instructors = converted;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
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
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const CircularProgressIndicator()
              else
                DropdownButtonFormField<CatogerModel>(
                  decoration: const InputDecoration(
                    labelText: 'Select Instructor',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedInstructor,
                  items:
                      instructors.map((inst) {
                        return DropdownMenuItem<CatogerModel>(
                          value: inst,
                          child: Text(inst.name),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      // Store locally
                      selectedInstructor = value;

                      // ✅ Store globally in CatogerModel
                      CatogerModel.selected = value;
                    });
                  },
                ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      selectedInstructor == null
                          ? null
                          : () async {
                            final instructorId = selectedInstructor!.id;

                            // Call the POST function
                            final success = await sendCode(
                              instructorId: instructorId,
                            );

                            if (success) {
                              // Navigate only if OTP sent successfully
                              Navigator.pushNamed(
                                context,
                                AppRoutes.otp,
                                arguments: instructorId,
                              );
                            } else {
                              // Show error (optional)
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Failed to send code. Please try again.',
                                  ),
                                ),
                              );
                            }
                          },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
