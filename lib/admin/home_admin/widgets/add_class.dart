import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:e_scolar_app/auth/auth_methods.dart';
import 'package:e_scolar_app/models/module.dart';
import 'package:e_scolar_app/models/professor.dart';
import 'package:e_scolar_app/models/sector.dart';
import 'package:e_scolar_app/models/student.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../constant/pallete_color.dart';
import '../../../models/group.dart';

class AddClass extends StatefulWidget {
  const AddClass({super.key});

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final AuthMethods _authMethods = AuthMethods();
  TextEditingController sectorController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  List<Group> _groups = [];
  List<Module> _modules = [];
  List<Student> _students = [];
  List<Professor> _professors = [];
  List<String> _selectedGroups = [];
  List<Student> _selectedStudents = [];
  List<String> _selectedProfessors = [];
  List<Module> _selectedModules = [];

  final _formKey = GlobalKey<FormState>();
  final _groupMultiSelectKey = GlobalKey<FormFieldState>();
  final _studentMultiSelectKey = GlobalKey<FormFieldState>();
  final _professorMultiSelectKey = GlobalKey<FormFieldState>();
  final _moduleMultiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _fetchStudentsByModules(List<Module> selectedModules) async {
    try {
      List<String> moduleIds =
          selectedModules.map((module) => module.id).toList();
      List<Student> students =
          await _authMethods.getStudentsByModules(moduleIds);
      setState(() {
        _students = students;
      });
      print("Filtered Student: $_students");
    } catch (e) {
      print("Error fetching Students: $e");
    }
  }

  Future<void> _clearFields() async {
    sectorController.clear();
    groupController.clear();
    _studentMultiSelectKey.currentState?.reset();
    _moduleMultiSelectKey.currentState?.reset();
  }

  Future<void> _loadData() async {
    try {
      List<Group> groups = await _authMethods.getGroups();
      List<Student> students = await _authMethods.getStudents();
      List<Module> modules = await _authMethods.getModules();
      List<Professor> professor = await _authMethods.getProfessors();
      setState(() {
        _groups = groups;
        _modules = modules;
        _students = students;
        _professors = professor;
      });

      print("Groups: $_groups");
      print("Students: $_students");
      print("Modules: $_modules");
    } catch (e) {
      print("Error Loading data: $e");
    }
  }

  Future<void> addSector() async {
    List<String> studentIds =
        _selectedStudents.map((student) => student.name).toList();
    List<String> moduleIds =
        _selectedModules.map((module) => module.name).toList();
    List<String> professorId =
        _selectedProfessors.map((professor) => professor).toList();
    final sector = Sector(
      id: _authMethods.fireStore.collection('sectors').doc().id,
      name: sectorController.text,
      groups: groupController.text,
      // => textFiled 7ssen** (number 102, 202, ..),
      students: studentIds,
      professors: professorId,
      // => textFiled  ('laarbii', ..), or multi select from users professor**
      modules: moduleIds,
    );
    await _authMethods.addSector(sector);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: ColorPalette.primaryColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: IconButton(
                onPressed: () {
                  context.go('/home/admin');
                },
                icon: const Icon(
                  Iconsax.arrow_circle_left,
                  color: Colors.white,
                )),
          ),
          centerTitle: true,
          title: const Text("Creer un Classe",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: sectorController,
                    decoration: InputDecoration(
                      labelText: 'Secteur',
                      hintText: "Nom de Secteur",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      suffixIcon: const Icon(Icons.library_books),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: groupController,
                    decoration: InputDecoration(
                      labelText: 'Group',
                      hintText: "Nom Group",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      suffixIcon: const Icon(Icons.library_books),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                _buildMultiSelectField(
                  key: _moduleMultiSelectKey,
                  items: _modules
                      .map((module) =>
                          MultiSelectItem<Module>(module, module.name))
                      .toList(),
                  title: "Modules",
                  selectedColor: ColorPalette.primaryColor,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    border:
                        Border.all(color: ColorPalette.primaryColor, width: 2),
                  ),
                  buttonIcon: const Icon(Icons.book, color: Colors.black54),
                  buttonText: "Select Modules",
                  onConfirm: (results) {
                    setState(() {
                      _selectedModules = results.cast<Module>();
                    });
                    _fetchStudentsByModules(_selectedModules);
                  },
                ),
                const SizedBox(height: 20.0),
                _buildMultiSelectField(
                  key: _professorMultiSelectKey,
                  items: _professors
                      .map((professor) => MultiSelectItem(professor,
                          professor.name)) // Using email or another identifier
                      .toList(),
                  title: "Professors",
                  selectedColor: ColorPalette.primaryColor,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    border:
                        Border.all(color: ColorPalette.primaryColor, width: 2),
                  ),
                  buttonIcon: const Icon(Icons.person, color: Colors.black54),
                  buttonText: "Select Professors",
                  onConfirm: (results) {
                    setState(() {
                      _selectedProfessors = results
                          .map((professor) => professor.uid.toString())
                          .toList();
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                _buildMultiSelectField(
                  key: _studentMultiSelectKey,
                  items: _students
                      .map((student) =>
                          MultiSelectItem<Student>(student, student.name))
                      .toList(),
                  title: "Etudiant",
                  selectedColor: ColorPalette.primaryColor,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    border:
                        Border.all(color: ColorPalette.primaryColor, width: 2),
                  ),
                  buttonIcon: const Icon(Icons.school, color: Colors.black54),
                  buttonText: "Select Etudiants",
                  onConfirm: (results) {
                    setState(() {
                      _selectedStudents = results.cast<Student>();
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        gradient: LinearGradient(
                            colors: [
                              ColorPalette.primaryColor,
                              ColorPalette.primaryColor.withOpacity(0.8)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight)),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addSector();
                          AnimatedSnackBar.material(
                            'Account Add Successfully :)',
                            type: AnimatedSnackBarType.success,
                            mobileSnackBarPosition:
                                MobileSnackBarPosition.bottom,
                          ).show(context);
                          _clearFields();
                        } else {
                          AnimatedSnackBar.material(
                            'Something went Wrong !!',
                            type: AnimatedSnackBarType.error,
                            mobileSnackBarPosition:
                                MobileSnackBarPosition.bottom,
                          ).show(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        padding: EdgeInsets.all(0.0),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text("Ajouter Secteur",
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectField({
    required GlobalKey<FormFieldState<dynamic>> key,
    required List<MultiSelectItem> items,
    required String title,
    required Color selectedColor,
    required BoxDecoration decoration,
    required Icon buttonIcon,
    required String buttonText,
    required void Function(List results) onConfirm,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: MultiSelectDialogField(
        key: key,
        items: items,
        title: Text(title),
        selectedColor: selectedColor,
        decoration: decoration,
        buttonIcon: buttonIcon,
        buttonText: Text(
          buttonText,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
        onConfirm: onConfirm,
      ),
    );
  }
}
