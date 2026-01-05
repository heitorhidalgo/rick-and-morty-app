import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importante para usar GetMaterialApp
import 'package:get_storage/get_storage.dart'; // Para salvar dados locais (Tema)
import 'package:rick_morty_app/theme/theme_controller.dart';

import 'personagem/personagem_page.dart';

// A função main agora é assíncrona (async) porque precisa esperar o banco de dados iniciar
void main() async {
  // Inicializa o GetStorage
  // Isso garante que as preferências do usuário (como tema escuro) sejam carregadas antes do aplicativo desenhar a primeira tela.
  await GetStorage.init();

  // Roda o aplicativo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos GetMaterialApp em vez de MaterialApp padrão
    // Isso habilita os superpoderes do GetX:
    // - Navegação sem context
    // - Troca de tema dinâmica
    // - Snackbars e Dialogs simplificados
    return GetMaterialApp(
      title: 'Rick and Morty App', // Boa prática: Nome do App
      // --- CONFIGURAÇÃO DE TEMAS ---

      // Define qual modo usar (Claro, Escuro ou Sistema) baseado no que está salvo
      themeMode: ThemeController().theme,

      // Definição visual do Tema Claro
      theme: ThemeData.light(),

      // Definição visual do Tema Escuro
      darkTheme: ThemeData.dark(),

      // Remove a faixinha vermelha de "DEBUG" no canto da tela
      debugShowCheckedModeBanner: false,

      // A primeira tela que abre
      home: const HomePage(), // 'const' melhora a performance aqui
    );
  }
}
