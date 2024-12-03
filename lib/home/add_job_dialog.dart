import 'package:flutter/material.dart';
import 'package:future_job/models/job_model.dart';

class AddJobDialog extends StatefulWidget {
  final Function(Job) onJobAdded;

  const AddJobDialog({Key? key, required this.onJobAdded}) : super(key: key);

  @override
  _AddJobDialogState createState() => _AddJobDialogState();
}

class _AddJobDialogState extends State<AddJobDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyLogoController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _companyLogoController.dispose();
    _jobTitleController.dispose();
    _companyNameController.dispose();
    _salaryController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter un nouveau job'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _companyLogoController,
                decoration:
                    InputDecoration(labelText: 'URL du logo de l\'entreprise'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'URL du logo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jobTitleController,
                decoration: InputDecoration(labelText: 'Titre du poste'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le titre du poste';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(labelText: 'Nom de l\'entreprise'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom de l\'entreprise';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salaryController,
                decoration: InputDecoration(labelText: 'Salaire'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le salaire';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Lieu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le lieu';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final newJob = Job(
                companyLogo: _companyLogoController.text,
                jobTitle: _jobTitleController.text,
                companyName: _companyNameController.text,
                salary: _salaryController.text,
                location: _locationController.text,
              );
              await widget.onJobAdded(newJob);
              Navigator.of(context).pop(); // Fermer le dialogue après l'ajout
            }
          },
          child: Text('Ajouter'),
        ),
      ],
    );
  }
}
