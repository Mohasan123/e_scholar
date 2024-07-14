import 'dart:io';

import 'package:e_scolar_app/auth/auth_methods.dart';
import 'package:e_scolar_app/models/notes.dart';
// import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../constant/pallete_color.dart';

class StudentNoteScreen extends StatelessWidget {
  final String studentId;
  final AuthMethods _authMethods = AuthMethods();

  StudentNoteScreen({
    super.key,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.primaryColor,
        centerTitle: true,
        title: const Text(
          'Your Notes',
          style: TextStyle(color: Colors.white),
        ),
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
        actions: [
          IconButton(
            onPressed: () async {
              await _generateAndSavePdf();
            },
            icon: const Icon(
              Iconsax.document_download,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: _authMethods.getNotesByStudent(studentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Note> notes = snapshot.data ?? [];
            if (notes.isEmpty) {
              return const Center(
                child: Text('No notes available'),
              );
            }

            // Calculate average
            double totalPracticalWork = 0.0;
            double totalVariousWorks = 0.0;
            Set<String> moduleIds = {};

            for (var note in notes) {
              totalPracticalWork += note.practicalWork;
              totalVariousWorks += note.variousWork;
              moduleIds.add(note.moduleId);
            }

            double average = ((totalPracticalWork + totalVariousWorks) / 2) /
                moduleIds.length;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      Note note = notes[index];
                      return ListTile(
                        title: Text(note.moduleId),
                        subtitle: Text(
                            'Travaux Pratique: ${note.practicalWork}, Travaux Divers : ${note.variousWork}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Moyenne: $average',
                    style: average >= 10
                        ? const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)
                        : const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> _generateAndSavePdf() async {
    final pdf = pw.Document();
    final notes = await _authMethods.getNotesByStudent(studentId);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Etudiant Notes',
                  style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 16),
              pw.ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8.0),
                    child: pw.Text(
                      'Module: ${note.moduleId} - Practical: ${note.practicalWork}, Divers: ${note.variousWork}',
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/student_notes.pdf');
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }
}
