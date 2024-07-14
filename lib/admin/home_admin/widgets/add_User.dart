import 'dart:math';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:e_scolar_app/auth/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import "package:iconsax/iconsax.dart";
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../constant/pallete_color.dart';
import '../../../models/module.dart';
import '../../../models/userdata.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeApController = TextEditingController();
  TextEditingController codeMsController = TextEditingController();
  TextEditingController adresController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController placeBirthController = TextEditingController();
  DateTime? dateBirth;

  final _formKey = GlobalKey<FormState>();
  UserRole? dropdownValue = UserRole.student;
  final AuthMethods _authMethods = AuthMethods();
  List<Module> _modules = [];
  List<Module> _selectedModules = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('modules').get();
      setState(() {
        _modules =
            querySnapshot.docs.map((doc) => Module.fromSnapshot(doc)).toList();
        print("Modules Loaded : $_modules");
      });
    } catch (e) {
      print("Error Loading modules : $e");
    }
  }

  Future<void> _clearFields() async {
    emailController.clear();
    phoneController.clear();
    passController.clear();
    nameController.clear();
    codeApController.clear();
    _multiSelectKey.currentState?.reset();
    setState(() {
      _selectedModules = [];
      dropdownValue = UserRole.student;
    });
  }

  Future<bool> _userExists(String email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    final List<DocumentSnapshot> document = result.docs;
    return document.isNotEmpty;
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
          title: const Text("Create User",
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
                const SizedBox(height: 20.0),
                _buildTextField(emailController, "Email", Icons.email_outlined),
                const SizedBox(height: 10.0),
                _buildTextField(nameController, "Nom Complet", Iconsax.user),
                const SizedBox(height: 10.0),
                _buildTextField(codeMsController, "Code Massar", Icons.numbers),
                const SizedBox(height: 10.0),
                _buildTextField(placeController, "Lieu", Icons.place),
                const SizedBox(height: 10.0),
                _buildTextField(
                    placeBirthController, "Lieu de Naissance", Icons.place),
                const SizedBox(height: 10.0),
                _buildTextField(adresController, "Adresse", Iconsax.user),
                const SizedBox(height: 10.0),
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
                    format: DateFormat("yyyy-MM-dd"),
                    decoration: const InputDecoration(
                      labelText: 'Date de Naissance',
                      suffixIcon:
                          Icon(Icons.calendar_today, color: Colors.black54),
                    ),
                    onChanged: (value) {
                      dateBirth = value;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),

                _buildTextField(phoneController, "Tele", Iconsax.call),
                const SizedBox(height: 10.0),
                _buildTextField(passController, "Mot de passe", Icons.lock,
                    obscureText: true),
                const SizedBox(height: 10.0),
                _buildRoleDropdown(),
                const SizedBox(height: 10.0),
                // if (dropdownValue == UserRole.student) ...[
                // _buildTextField(
                //     codeController, "Six-Digit Code", Iconsax.key),
                Visibility(
                  visible: dropdownValue == UserRole.student ||
                      dropdownValue == UserRole.professor,
                  child: Column(
                    children: [
                      if (dropdownValue == UserRole.student)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
                            controller: codeApController,
                            decoration: InputDecoration(
                              labelText: 'Code Apogee',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0)),
                              suffixIcon: const Icon(Iconsax.key),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                            ),
                            validator: (value) {
                              if (dropdownValue == UserRole.student &&
                                  (value == null || value.isEmpty)) {
                                return 'Generer';
                              }
                              return null;
                            },
                          ),
                        ),
                      if (dropdownValue == UserRole.student)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.primaryColor),
                          onPressed: () {
                            codeApController.text = generateSixDigitCode();
                          },
                          child: const Text(
                            'Generer le Code',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                letterSpacing: 1),
                          ),
                        ),
                      const SizedBox(height: 10.0),
                      _buildModuleMultiSelect(),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                // _buildModuleMultiSelect(),
                // ],
                const SizedBox(height: 15.0),
                _buildSubmitButton(),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: "Entrer $label",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          suffixIcon: Icon(icon),
          contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
        ),
        obscureText: obscureText,
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Role de User :",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              letterSpacing: 1,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 20.0),
        DropdownButtonHideUnderline(
          child: DropdownButton<UserRole>(
            items: UserRole.values
                .map((role) => DropdownMenuItem<UserRole>(
                      value: role,
                      child: Text(role.toString().split('.').last),
                    ))
                .toList(),
            value: dropdownValue,
            onChanged: (UserRole? newValue) {
              setState(() {
                dropdownValue = newValue;
                if (newValue == UserRole.student) {
                  codeApController.text = generateSixDigitCode();
                } else {
                  codeApController.clear();
                }
              });
              // setState(() {
              //   dropdownValue = newValue;
              // });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModuleMultiSelect() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: MultiSelectDialogField(
        key: _multiSelectKey,
        items: _modules
            .map((module) => MultiSelectItem<Module>(module, module.name))
            .toList(),
        title: const Text("Modules"),
        selectedColor: ColorPalette.primaryColor,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: ColorPalette.primaryColor, width: 2),
        ),
        buttonIcon: const Icon(
          Icons.book,
          color: Colors.black54,
        ),
        buttonText: const Text(
          "Select Modules",
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
        onConfirm: (results) {
          setState(() {
            _selectedModules = results.cast<Module>();
          });
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
        child: ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.primaryColor),
          child: const Text(
            "Ajouter",
            style: TextStyle(
                color: Colors.white, fontSize: 18.0, letterSpacing: 1),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      bool exists = await _userExists(emailController.text);
      if (exists) {
        AnimatedSnackBar.material(
          'Account Already exists !!',
          type: AnimatedSnackBarType.info,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        ).show(context);
      }
      List<String> moduleIds =
          _selectedModules.map((module) => module.id).toList();
      String response = await _authMethods.registerUser(
        email: emailController.text,
        name: nameController.text,
        password: passController.text,
        role: dropdownValue!,
        modules: moduleIds,
        phone: phoneController.text,
        codeApogee:
            dropdownValue == UserRole.student ? codeApController.text : null,
        codeMassar:
            dropdownValue == UserRole.student ? codeMsController.text : null,
        adress: adresController.text,
        place: placeController.text,
        placeOfBirth: placeBirthController.text,
        dateOfBirth: dateBirth!,
      );

      if (response == "success") {
        AnimatedSnackBar.material(
          'Account Add Successfully :)',
          type: AnimatedSnackBarType.success,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        ).show(context);
        _clearFields();
      } else {
        AnimatedSnackBar.material(
          'Something went Wrong !!',
          type: AnimatedSnackBarType.error,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        ).show(context);
      }
    }
  }

  String generateSixDigitCode() {
    final random = Random();
    final code = random.nextInt(900000) + 100000;
    return code.toString();
  }
}
