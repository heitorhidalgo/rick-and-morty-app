import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rick_morty_app/personagem_model.dart';

class PersonagemController extends GetxController {
  late BuildContext context;

  final isLoading = true.obs;

  final personagens = <PersonagemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPersonagens();
  }

  buscaPersonagem() async {
    Uri url = Uri.parse('https://rickandmortyapi.com/api/character');

    http.Response response;

    response = await http.get(url);
  }
}
