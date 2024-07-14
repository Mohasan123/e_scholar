import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import "package:iconsax/iconsax.dart";

import '../../../auth/auth_methods.dart';
import '../../../constant/pallete_color.dart';
import '../../../models/module.dart';

class AddModal extends StatefulWidget {
  const AddModal({super.key});

  @override
  State<AddModal> createState() => _AddModalState();
}

class _AddModalState extends State<AddModal> {
  TextEditingController nameController = TextEditingController();
  TextEditingController moduleNumController = TextEditingController();
  String selectedSection = 'Autumn';
  final _formKey = GlobalKey<FormState>();
  final AuthMethods _authMethods = AuthMethods();

  Future<void> _clearFields() async {
    moduleNumController.clear();
    nameController.clear();
    setState(() {
      selectedSection = "Autumn";
    });
  }

  Future<bool> _nameExists(String name) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('modules')
        .where('name', isEqualTo: name)
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
          backgroundColor: ColorPalette.primaryColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: IconButton(
                highlightColor: ColorPalette.primaryColor,
                onPressed: () {
                  context.go('/home/admin');
                },
                icon: const Icon(
                  Iconsax.arrow_circle_left,
                  color: Colors.white,
                )),
          ),
          centerTitle: true,
          title: const Text("Ajouter un Module",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 60.0),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nom de Module",
                    hintText: "Enter Module Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    suffixIcon: const Icon(Iconsax.book),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: TextFormField(
                  controller: moduleNumController,
                  decoration: InputDecoration(
                    labelText: "Nombre de Module",
                    hintText: "Enter M2 or M12",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    suffixIcon: const Icon(Icons.view_module_outlined),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                child: DropdownButtonFormField<String>(
                  value: selectedSection,
                  items: ['Autumn', 'Spring']
                      .map((section) => DropdownMenuItem(
                            value: section,
                            child: Text(section),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSection = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Period",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  width: 450,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool exist = await _nameExists(nameController.text);
                        if (exist) {
                          AnimatedSnackBar.material(
                            'Module Already exists !!',
                            type: AnimatedSnackBarType.info,
                            mobileSnackBarPosition:
                                MobileSnackBarPosition.bottom,
                          ).show(context);
                        }
                        String id = _authMethods.fireStore
                            .collection('modules')
                            .doc()
                            .id;
                        Module module = Module(
                          id: id,
                          name: nameController.text,
                          semester: selectedSection,
                          moduleNum: moduleNumController.text,
                        );

                        await _authMethods.addModule(module);
                        AnimatedSnackBar.material(
                          'Module Create Successfully !!',
                          type: AnimatedSnackBarType.success,
                          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                        ).show(context);
                        _clearFields();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                    ),
                    child: const Text(
                      'Ajouter',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
