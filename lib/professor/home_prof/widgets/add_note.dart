import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:e_scolar_app/auth/auth_methods.dart';
import 'package:e_scolar_app/constant/pallete_color.dart';
import 'package:e_scolar_app/models/module.dart';
import 'package:e_scolar_app/models/notes.dart';
import 'package:e_scolar_app/models/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final AuthMethods _authMethods = AuthMethods();
  List<Student> _students = [];
  List<Module> _modules = [];
  List<Student> _selectedStudents = [];
  Module? _selectedModule;
  Map<String, TextEditingController> practicalWorkControllers = {};
  Map<String, TextEditingController> variousWorksControllers = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<Student> students = await _authMethods.getStudents();
      List<Module> modules = await _authMethods.getModules();
      setState(() {
        _students = students;
        _modules = modules;
      });
    } catch (e) {
      print("Error Loading data: $e");
    }
  }

  void _initializeControllers() {
    for (var student in _selectedStudents) {
      practicalWorkControllers[student.uid] = TextEditingController();
      variousWorksControllers[student.uid] = TextEditingController();
    }
  }

  Future<void> _fetchStudentsByModule(Module module) async {
    try {
      List<Student> students =
          await _authMethods.getStudentsByModules([module.id]);
      setState(() {
        _selectedStudents = students;
        _initializeControllers();
      });
    } catch (e) {
      print("Error fetching students: $e");
    }
  }

  Future<void> _saveNotes() async {
    for (var student in _selectedStudents) {
      String practicalWork = practicalWorkControllers[student.uid]?.text ?? '0';
      String variousWorks = variousWorksControllers[student.uid]?.text ?? '0';
      Note note = Note(
        id: _authMethods.fireStore.collection('notes').doc().id,
        studentId: student.uid,
        moduleId: _selectedModule!.name,
        practicalWork: double.parse(practicalWork),
        variousWork: double.parse(variousWorks),
      );
      await _authMethods.addOrUpdateNote(note);
      if (mounted) {
        AnimatedSnackBar.material(
          'Note Add Successfully :)',
          type: AnimatedSnackBarType.success,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        ).show(context);
      }
      if (mounted) {
        context.go('/home/professor');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
              onPressed: () {
                context.go('/home/professor');
              },
              icon: const Icon(
                Iconsax.arrow_circle_left,
                color: ColorPalette.primaryColor,
              )),
        ),
        title: const Text('Enter Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<Module>(
              hint: const Text('Select Module'),
              value: _selectedModule,
              onChanged: (Module? newValue) {
                setState(() {
                  _selectedModule = newValue;
                  if (newValue != null) {
                    _fetchStudentsByModule(newValue);
                  }
                });
              },
              items: _modules.map((Module module) {
                return DropdownMenuItem<Module>(
                  value: module,
                  child: Text(module.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedStudents.length,
                itemBuilder: (context, index) {
                  Student student = _selectedStudents[index];
                  return Column(
                    children: [
                      const Divider(
                        thickness: 2.0,
                        color: ColorPalette.primaryColor,
                      ),
                      ListTile(
                        title: Text(
                          student.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                        subtitle: Column(
                          children: [
                            TextField(
                              controller: practicalWorkControllers[student.uid],
                              decoration: const InputDecoration(
                                  labelText: 'Practical Work'),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d{0,2}$'))
                              ],
                            ),
                            TextField(
                              controller: variousWorksControllers[student.uid],
                              decoration: const InputDecoration(
                                  labelText: 'Various Works'),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 2.0,
                        color: ColorPalette.primaryColor,
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveNotes,
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryColor),
              child: const Text(
                'Save Notes',
                style: TextStyle(
                    color: Colors.white, fontSize: 18.0, letterSpacing: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
