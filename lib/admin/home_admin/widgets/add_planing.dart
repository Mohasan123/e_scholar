import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:e_scolar_app/auth/auth_methods.dart';
import 'package:e_scolar_app/models/schedule.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../constant/pallete_color.dart';
import '../../../models/group.dart';
import '../../../models/module.dart';
import '../../../models/professor.dart';
import '../../../models/sector.dart';
import '../../../models/student.dart';

class AddPlaning extends StatefulWidget {
  const AddPlaning({super.key});

  @override
  State<AddPlaning> createState() => _AddPlaningState();
}

class _AddPlaningState extends State<AddPlaning> {
  final AuthMethods _authMethods = AuthMethods();
  TextEditingController roomController = TextEditingController();
  DateTime? startTime;
  DateTime? endTime;
  final _formKey = GlobalKey<FormState>();

  TextEditingController sectorController = TextEditingController();
  List<Sector> _sectors = [];
  List<Group> _groups = [];
  List<Module> _modules = [];
  List<Student> _students = [];
  List<Professor> _professors = [];
  List<Sector> _selectedSector = [];
  List<String> _selectedGroups = [];
  List<Student> _selectedStudents = [];
  List<Professor> _selectedProfessors = [];
  List<Module> _selectedModules = [];

  final _sectorMultiSelectKey = GlobalKey<FormFieldState>();
  final _groupMultiSelectKey = GlobalKey<FormFieldState>();
  final _studentMultiSelectKey = GlobalKey<FormFieldState>();
  final _professorMultiSelectKey = GlobalKey<FormFieldState>();
  final _moduleMultiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<Sector> sectors = await _authMethods.getSectors();
      List<Group> groups = await _authMethods.getGroups();
      List<Student> students = await _authMethods.getStudents();
      List<Module> modules = await _authMethods.getModules();
      List<Professor> professor = await _authMethods.getProfessors();
      setState(() {
        _sectors = sectors;
        // _groups = groups;
        _modules = modules;
        _students = students;
        _professors = professor;
      });

      print("Sector: $_sectors");
      print("Groups: $_groups");
      print("Students: $_students");
      print("Modules: $_modules");
      print("Modules: $_professors");
    } catch (e) {
      print("Error Loading data: $e");
    }
  }

  Future<void> addSchedule() async {
    List<String> studentIds =
        _selectedStudents.map((student) => student.name).toList();
    List<String> moduleIds =
        _selectedModules.map((module) => module.name).toList();
    List<String> professorIds =
        _selectedProfessors.map((professor) => professor.name).toList();
    List<String> sectorsId =
        _selectedSector.map((sector) => sector.name).toList();
    final schedule = Schedule(
      id: _authMethods.fireStore.collection('schedules').doc().id,
      startTime: startTime!,
      endTime: endTime!,
      room: roomController.text,
      sectors: sectorsId,
      // groups: _selectedGroups,
      students: studentIds,
      professors: professorIds,
      modules: moduleIds,
    );
    await _authMethods.addSchedule(schedule);
  }

  Future<void> _clearFields() async {
    sectorController.clear();
    _studentMultiSelectKey.currentState?.reset();
    _moduleMultiSelectKey.currentState?.reset();
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
          title: const Text("Creer un Calendrier",
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
                    controller: roomController,
                    decoration: InputDecoration(
                      labelText: 'Classe',
                      hintText: "Entrer Un Classe",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      suffixIcon: const Icon(Icons.meeting_room_rounded),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                _buildMultiSelectField(
                  key: _sectorMultiSelectKey,
                  items: _sectors
                      .map((sector) =>
                          MultiSelectItem<Sector>(sector, sector.name))
                      .toList(),
                  title: "Secteur",
                  selectedColor: ColorPalette.primaryColor,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                    border:
                        Border.all(color: ColorPalette.primaryColor, width: 2),
                  ),
                  buttonIcon:
                      const Icon(Icons.library_books, color: Colors.black54),
                  buttonText: "Select Secteur",
                  onConfirm: (results) {
                    setState(() {
                      _selectedSector = results.cast<Sector>();
                    });
                  },
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
                  },
                ),
                const SizedBox(height: 20.0),
                _buildMultiSelectField(
                  key: _professorMultiSelectKey,
                  items: _professors
                      .map((professor) =>
                          MultiSelectItem<Professor>(professor, professor.name))
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
                      _selectedProfessors = results.cast<Professor>();
                      // _selectedProfessors = results
                      //     .map((professor) => professor.uid.toString())
                      //     .toList();
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
                  buttonIcon:
                      const Icon(Icons.group_add, color: Colors.black54),
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
                  child: DateTimeField(
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1990),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                    format: DateFormat("yyyy-MM-dd HH:mm"),
                    decoration: const InputDecoration(
                      labelText: 'Debut',
                      suffixIcon:
                          Icon(Icons.calendar_today, color: Colors.black54),
                    ),
                    onChanged: (value) {
                      startTime = value;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: DateTimeField(
                    cursorColor: ColorPalette.primaryColor,
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1990),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                    format: DateFormat("yyyy-MM-dd HH:mm"),
                    decoration: const InputDecoration(
                      suffixIcon:
                          Icon(Icons.calendar_today, color: Colors.black54),
                      labelText: 'Fin',
                    ),
                    onChanged: (value) {
                      endTime = value;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: double.infinity,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await addSchedule();
                          AnimatedSnackBar.material(
                            'Account Add Successfully :)',
                            type: AnimatedSnackBarType.success,
                            mobileSnackBarPosition:
                                MobileSnackBarPosition.bottom,
                          ).show(context);
                          context.go('/home/admin');
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
                          backgroundColor: ColorPalette.primaryColor),
                      child: const Text(
                        "Ajouter Calendrier",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
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
