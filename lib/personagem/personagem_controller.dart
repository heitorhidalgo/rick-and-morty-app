import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rick_morty_app/models/personagem_model.dart';

class PersonagemController extends GetxController {
  late BuildContext context;

  // CONTROLES DE ESTADO
  final isLoading = true.obs; // Carregamento inicial (tela toda)

  //Deve começar como false, senão o loading aparece sem scrollar
  final isLoadMore = false.obs;

  final scrollController = ScrollController(); // Sensor de rolagem

  // DADOS
  final personagens = <PersonagemModel>[].obs;
  int currentPage = 1; // Começamos na pg 1

  @override
  void onInit() {
    super.onInit();

    //Busca a primeira página assim que inicia
    fetchPersonagens();

    //Adiciona o ouvinte no scroll
    scrollController.addListener(() {
      // Se a posição atual for igual ou quase igual a posição máxima (perto do fim)
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        // E se não estiver carregando nada agora...
        if (!isLoadMore.value && !isLoading.value) {
          carregarMaisPersonagens();
        }
      }
    });
  }

  // Função para carregamento inicial pg 1
  Future<void> fetchPersonagens() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('https://rickandmortyapi.com/api/character?page=1'),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        List<dynamic> lista = body['results'];

        personagens.value =
            lista.map((e) => PersonagemModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Erro no fetch inicial: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Função para carregar mais personagens (Paginação Infinita)
  Future<void> carregarMaisPersonagens() async {
    try {
      isLoadMore.value = true; // Mostra o loading na parte de baixo
      currentPage++; // Vai para a próxima pg

      final response = await http.get(
        Uri.parse(
          'https://rickandmortyapi.com/api/character?page=$currentPage',
        ),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        List<dynamic> novosItens = body['results'];

        // Uso do addAll para somar na lista existente
        personagens.addAll(
          novosItens.map((e) => PersonagemModel.fromJson(e)).toList(),
        );
      }
    } catch (e) {
      print('Erro ao carregar mais: $e');
      currentPage--; // Caso dê erro, volta o contador para tentar novamente depois
    } finally {
      isLoadMore.value = false; // Esconde o loading
    }
  }

  @override
  void onClose() {
    scrollController
        .dispose(); // Boa prática: sempre fechar o controller ao sair
    super.onClose();
  }
}
