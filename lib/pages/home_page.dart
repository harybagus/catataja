import 'package:catataja/components/catataja_drawer_navigation.dart';
import 'package:catataja/components/catataja_logo.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const CatatAjaLogo(fontSize: 35),
      ),
      drawer: CatatAjaDrawerNavigation(token: widget.token),
    );
  }
}
