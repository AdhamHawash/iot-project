import 'package:flutter/material.dart';
import 'package:attevdance_sestem/api.dart';
import '../../../routes/app_routes.dart';
import '../catoger_model.dart';

class SelectSectionScreen extends StatefulWidget {
  const SelectSectionScreen({super.key});

  @override
  State<SelectSectionScreen> createState() => _SelectSectionScreenState();
}

class _SelectSectionScreenState extends State<SelectSectionScreen> {
  List<dynamic> sections = [];
  dynamic selectedSection;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSections();
  }

  Future<void> fetchSections() async {
    try {
      final data = await getSections();
      setState(() {
        sections = data;
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const CircularProgressIndicator()
              else
                DropdownButtonFormField<dynamic>(
                  decoration: const InputDecoration(
                    labelText: 'Select Section',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedSection,
                  items:
                      sections.map((sec) {
                        return DropdownMenuItem<dynamic>(
                          value: sec,
                          child: Text(sec['sectionName']),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSection = value;

                      final old = CatogerModel.selected;

                      if (old != null) {
                        // ✅ Update only sectionId
                        CatogerModel.selected = CatogerModel(
                          id: old.id,
                          name: old.name,
                          sectionId: value['_id'],
                        );
                      }
                    });
                  },
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      selectedSection == null
                          ? null
                          : () {
                            Navigator.pushNamed(context, AppRoutes.fingerprint);
                          },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
