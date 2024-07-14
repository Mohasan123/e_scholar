import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_scolar_app/auth/auth_methods.dart';
import 'package:e_scolar_app/constant/pallete_color.dart';
import 'package:e_scolar_app/models/requestDocument.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key, required this.docs});

  final List<QueryDocumentSnapshot> docs;

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
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Iconsax.arrow_circle_left,
                color: Colors.white,
              )),
        ),
        centerTitle: true,
        title: const Text("Notifications",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
          child: Column(
            children: docs.map((doc) {
              final request = Request.fromSnapshot(doc);
              return ExpansionTile(
                title: Text("Demand depuis ${request.studentName}"),
                children: [
                  ListTile(
                    title: Text("Nom d'Etudiant: ${request.studentName}"),
                    subtitle: Text("Nom de Document: ${request.documentType}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.primaryColor,
                      ),
                      onPressed: () {
                        _showRequestDetails(context, request);
                      },
                      child: const Text(
                        'Voir les Details',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showRequestDetails(BuildContext context, Request request) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Demand Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nom d' 'Etudiant: ${request.studentName}'),
              Text('Date de Demand: ${request.requestedAt}'),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette.primaryColor,
                ),
                onPressed: () async {
                  // Send notification to student that their request is ready
                  await AuthMethods().completeDocumentRequest(
                      request.id, request.studentName, request.studentName);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Notification Envoyer par ${request.studentName}'),
                    ),
                  );
                },
                child: const Text(
                  'Completer Le Demand',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Fermer',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
