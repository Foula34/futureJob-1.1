import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class InterestsSelectionScreen extends StatefulWidget {
  @override
  _InterestsSelectionScreenState createState() =>
      _InterestsSelectionScreenState();
}

class _InterestsSelectionScreenState extends State<InterestsSelectionScreen> {
  // Liste des centres d'intérêt
  final List<String> interests = [
    "Informatique",
    "Économie",
    "Management",
    "Santé",
    "Art"
  ];
  // Map pour suivre les sélections des utilisateurs
/*************  ✨ Codeium Command ⭐  *************/
  /// Builds the widget tree for the TopicsSubscribe screen.
  ///
  /// This method returns a [Scaffold] that contains an [AppBar] with a centered
  /// title displaying "Vos préférences".
  ///
  /// The [context] parameter is used to build the widget tree.
/******  31b9d7d1-f91b-44cc-a509-f4335e8121e9  *******/ final Map<String, bool>
      selectedInterests = {};

  @override
  void initState() {
    super.initState();
    // Initialiser toutes les cases à "non sélectionné"
    for (String interest in interests) {
      selectedInterests[interest] = false;
    }
  }

  // Fonction pour gérer l'abonnement/désabonnement
  void toggleSubscription(String interest, bool isSelected) async {
    if (isSelected) {
      await FirebaseMessaging.instance.subscribeToTopic(interest);
      print("Abonné au topic : $interest");
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic(interest);
      print("Désabonné du topic : $interest");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Centres d'intérêt"),
      ),
      body: ListView(
        children: interests.map((interest) {
          return CheckboxListTile(
            title: Text(interest),
            value: selectedInterests[interest],
            onChanged: (bool? value) {
              setState(() {
                selectedInterests[interest] = value!;
              });
              toggleSubscription(interest, value!);
            },
          );
        }).toList(),
      ),
    );
  }
}
