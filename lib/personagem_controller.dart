import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rick_morty_app/personagem_model.dart';

class PersonagemController extends GetxController {
  late BuildContext context;

  final isLoading = true.obs;

  RxList personagens = <PersonagemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPersonagens();
  }

  Future<void> fetchPersonagens() async {
    try {
      isLoading.value = true;

      final Uri url = Uri.parse('https://rickandmortyapi.com/api/character');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> retorno = json.decode(response.body);

        final List<dynamic> listaResultados = retorno['results'];

        personagens.value =
            listaResultados
                .map((item) => PersonagemModel.fromJson(item))
                .toList();
      } else {
        Get.snackbar(
          'Erro',
          'Falha ao buscar dados: ${response.statusCode}',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Erro no controller: $e');
      Get.snackbar(
        'Erro',
        'Verifique a conexão: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
