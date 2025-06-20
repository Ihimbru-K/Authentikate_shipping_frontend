import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../widgets/custom_textfield_widget.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown_widget.dart';
import '../widgets/dispute_service.dart';

class DisputeScreen extends StatefulWidget {
  const DisputeScreen({super.key});

  @override
  _DisputeScreenState createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> {
  final _sessionIdController = TextEditingController();
  final _matriculationController = TextEditingController();
  final _courseIdController = TextEditingController();
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _sessionIdController.dispose();
    _matriculationController.dispose();
    _courseIdController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _submitDispute() async {
    try {
      final sessionId = int.parse(_sessionIdController.text);
      final courseId = int.parse(_courseIdController.text);
      await DisputeService.submitDispute(sessionId, _matriculationController.text, courseId, _detailsController.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dispute submitted successfully!')));
      Navigator.pop(context); // Return to previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log CA Mark Issue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _sessionIdController,
                label: 'Session ID',
               // keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _matriculationController,
                label: 'Matriculation Number',
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _courseIdController,
                label: 'Course ID',
                //keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _detailsController,
                label: 'Dispute Details',
                hint: 'Describe the issue with the CA mark...',
               // maxLines: 4,
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                text: 'Submit Dispute',
                onPressed: _submitDispute,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fingerprint), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        onTap: (index) {
          switch (index) {
            case 0: Navigator.pushNamed(context, '/dashboard'); break;
            case 1: Navigator.pushNamed(context, '/authenticate'); break;
            case 2: Navigator.pushNamed(context, '/students'); break;
            case 3: Navigator.pushNamed(context, '/settings'); break;
          }
        },
      ),
    );
  }
}