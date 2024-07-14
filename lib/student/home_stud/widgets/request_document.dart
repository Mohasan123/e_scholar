import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_scolar_app/models/requestDocument.dart';
import 'package:e_scolar_app/models/student.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../auth/auth_methods.dart';
import '../../../constant/pallete_color.dart';

class DocumentRequest extends StatefulWidget {
  const DocumentRequest({super.key});

  @override
  State<DocumentRequest> createState() => _DocumentRequestState();
}

class _DocumentRequestState extends State<DocumentRequest> {
  final _formKey = GlobalKey<FormState>();
  final _documentTypeController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();

  Student? _currentStudent;

  @override
  void initState() {
    super.initState();
    _fetchCurrentStudent();
  }

  Future<void> _fetchCurrentStudent() async {
    Student? student = await _authMethods.getCurrentStudent();
    setState(() {
      _currentStudent = student;
    });
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState?.validate() ?? false) {
      String documentType = _documentTypeController.text;
      if (_currentStudent != null) {
        Request request = Request(
          id: FirebaseFirestore.instance.collection('request').doc().id,
          studentName: _currentStudent!.name,
          codeApogee: _currentStudent!.codeApogee,
          documentType: documentType,
          requestedAt: DateTime.now(),
        );
        await FirebaseFirestore.instance
            .collection('request')
            .doc(request.id)
            .set(request.toMap());
        AnimatedSnackBar.material(
          'Account Add Successfully :)',
          type: AnimatedSnackBarType.success,
          mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        ).show(context);
        // _clearFields();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: ColorPalette.primaryColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
              onPressed: () {
                context.go('/');
              },
              icon: const Icon(
                Iconsax.arrow_circle_left,
                color: Colors.white,
              )),
        ),
        centerTitle: true,
        title: const Text("Demand Document",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _currentStudent == null
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _documentTypeController,
                      decoration:
                          const InputDecoration(labelText: 'Document Type'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter the document type';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.primaryColor),
                      onPressed: () {
                        _submitRequest();
                        context.go('/');
                      },
                      child: const Text(
                        'Submit Request',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            letterSpacing: 1),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
