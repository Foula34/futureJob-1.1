import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TopicsSubscribe extends StatefulWidget {
  const TopicsSubscribe({super.key});

  @override
  State<TopicsSubscribe> createState() => _TopicsSubscribeState();
}

class _TopicsSubscribeState extends State<TopicsSubscribe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Vos préférences"),
      ),);
  }
}