import 'package:flutter/material.dart';
import 'package:rick_morty_app/personagem_component.dart';

class HomePage extends StatefulWidget with PersonagemComponent {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with PersonagemComponent {
  @override
  build(BuildContext context) {
    initialize(context);
    return Scaffold(body: body());
  }
}
