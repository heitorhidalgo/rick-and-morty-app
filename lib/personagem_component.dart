import 'package:flutter/material.dart';
import 'package:rick_morty_app/personagem_controller.dart';

mixin class PersonagemComponent {
  final PersonagemController controller = PersonagemController();

  late Orientation orientacao;

  initialize(BuildContext context) async {
    controller.context = context;
    orientacao = MediaQuery.of(context).orientation;
  }

  Widget body() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: orientacao == Orientation.portrait ? 10 : 5),
            logo(),
          ],
        ),
      ),
    );
  }

  Widget logo() {
    return Center(
      heightFactor: 1,
      child: Image.asset(
        'assets/images/logo.png',
        width: orientacao == Orientation.portrait ? 300 : 200,
        height: orientacao == Orientation.portrait ? 300 : 200,
      ),
    );
  }
}
