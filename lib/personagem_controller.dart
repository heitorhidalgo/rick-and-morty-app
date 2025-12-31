import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rick_morty_app/personagem_model.dart';

class PersonagemController extends GetxController {
  late BuildContext context;

  //controles de estado
  final isLoading = true.obs; //carregamento inicial (tela toda)
  final isLoadMore =
      true.obs; //carregamento paginação (apenas a parte de baixo)
  final scrollController = ScrollController(); //sensor de rolagem

  RxList personagens = <PersonagemModel>[].obs;
  int currentPage = 1; // começamos na pg 1

  @override
  void onInit() {
    super.onInit();
    // busca a primeira pg
    fetchPersonagens();

    //adiciona o ouvinte no scroll
    scrollController.addListener(() {
      //Se a posição atual for igual ou quase igual a posição máxima
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        //e se não estiver carregando nada agora...
        if (!isLoadMore.value && !isLoading.value) {
          carregarMaisPersonagens();
        }
      }
    });
  }

  //função para carregamento inicial
  Future<void> fetchPersonagens() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(
          'https://rickandmortyapi.com/api/character?page=1',
        ), //força pg 1
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        List<dynamic> lista = body['results'];
        personagens.value =
            lista.map((e) => PersonagemModel.fromJson(e)).toList();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  //função para carregar mais personagens (paginação)
  Future<void> carregarMaisPersonagens() async {
    try {
      isLoadMore.value = true; //mostra o loading na parte de baixo
      currentPage++; // vai para a próxima pg

      final response = await http.get(
          Uri.parse(
              'https://rickandmortyapi.com/api/character?page=$currentPage')
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        List<dynamic> novosItens = body['results'];

        //uso do addAll para somar na lista
        personagens.addAll(
            novosItens.map((e) => PersonagemModel.fromJson(e)).toList()
        );
      }
    } catch (e) {
      print('Erro ao carregar mais: $e');
      currentPage--; // caso der erro, volta para a ágina anterior para tentar novamente
    } finally {
      isLoadMore.value = false; //esconde o loading
    }
  }

  @override
  void onClose() {
    scrollController.dispose(); //boa prática, sempre fechar o controller ao sair
    super.onClose();
  }
}



















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
