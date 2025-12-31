import 'package:flutter/material.dart';
import 'package:rick_morty_app/personagem_component.dart';

// Classe principal da página
class HomePage extends StatefulWidget {
  // Construtor constante (melhora performance do Flutter)
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Classe de Estado (Onde a tela é desenhada)
// O 'with PersonagemComponent' injeta o código de design aqui
class _HomePageState extends State<HomePage> with PersonagemComponent {

  @override
  Widget build(BuildContext context) {
    // Chama a função do Mixin que configura o contexto e a orientação (retrato/paisagem)
    // Isso garante que suas variáveis 'controller' e 'orientacao' funcionem
    initialize(context);

    // Retorna o esqueleto da tela
    return Scaffold(
      // O body() vem direto do arquivo 'personagem_component'
      body: body(),
    );
  }
}