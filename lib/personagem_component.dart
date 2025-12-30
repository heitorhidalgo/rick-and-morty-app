import 'package:flutter/material.dart';
import 'package:rick_morty_app/personagem_controller.dart';

mixin class PersonagemComponent {
  final PersonagemController controller = PersonagemController();

  late Orientation orientacao;

  initialize(BuildContext context) async {
    controller.context = context;
    orientacao = MediaQuery.of(context).orientation;
  }
}

Widget body() {
  return SafeArea(child: Container(height: 200, width: 200, color: Colors.red));
}
