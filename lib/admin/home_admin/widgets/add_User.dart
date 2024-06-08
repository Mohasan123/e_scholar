import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_scolar_app/auth/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import "package:iconsax/iconsax.dart";
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
                _buildTextField(nameController, "Full Name", Iconsax.user),
                const SizedBox(height: 10.0),
                _buildTextField(phoneController, "Phone Number", Iconsax.call),
                const SizedBox(height: 10.0),
                _buildTextField(passController, "Password", Icons.lock,
                    obscureText: true),
                const SizedBox(height: 10.0),
                _buildRoleDropdown(),
                const SizedBox(height: 10.0),
                _buildModuleMultiSelect(),
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
          hintText: "Enter $label",
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
          "Role of User :",
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
              });
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
            "Submit",
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
}
