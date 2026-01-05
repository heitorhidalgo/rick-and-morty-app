import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rick_morty_app/models/personagem_model.dart';
import 'package:rick_morty_app/personagem/personagem_controller.dart';
import 'package:rick_morty_app/theme/theme_controller.dart';

import '../widgets/card_personagem.dart';

mixin class PersonagemComponent {
  final PersonagemController controller = Get.put(
    PersonagemController(),
  ); // injeção de dependência com o GetX
  PersonagemModel? personagem; // o ? diz que a variável pode ser nula

  late Orientation
  orientacao; //variável para verificar se a orientação do celular é portrait(vertical) ou landscape(horizontal)

  initialize(BuildContext context) async {
    controller.context = context;
    orientacao = MediaQuery.of(context).orientation;
  }

  Widget body() {
    return SafeArea(
      child: Column(
        children: [
          mudarTema(),
          logo(),
          const SizedBox(height: 10),

          const Text(
            'Personagens',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          Expanded(
            child: Obx(() {
              // Deixando observável com o GetX

              // 1. Loading inicial (tela toda)
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
              }

              // 2. Quando a lista estiver vazia
              if (controller.personagens.isEmpty) {
                return const Center(
                  child: Text('Nenhum personagem encontrado'),
                );
              }

              // 3. Mostra a lista no caso de sucesso
              return ListView.builder(
                // Conexão com o sensor de scroll
                controller: controller.scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                // Lista tem o tamanho dos personagens + 1 (para o loading do fim)
                itemCount: controller.personagens.length + 1,
                itemBuilder: (context, index) {
                  // LÓGICA DO FIM DA LISTA (O ITEM EXTRA)
                  if (index == controller.personagens.length) {
                    // Usamos Obx aqui para o loading de baixo ser reativo
                    return Obx(() {
                      if (controller.isLoadMore.value) {
                        return const Padding(
                          padding: EdgeInsets.all(15),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          ),
                        );
                      } else {
                        // Caso não estiver carregando, aparece um espaço vazio
                        return const SizedBox(height: 20);
                      }
                    });
                  }

                  // Lógica do card normal (se não for o fim da lista)
                  final item = controller.personagens[index];
                  return CardPersonagem(item, 100, 100, 18, 14, orientacao);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget logo() {
    return Center(
      heightFactor: 1,
      child: Image.asset(
        // Sempre que colocar alguma imagem, ir no pubspec.yaml e alterar o assets
        'assets/images/logo.png',
        width: orientacao == Orientation.portrait ? 300 : 180,
        height: orientacao == Orientation.portrait ? 300 : 180,
      ),
    );
  }

  // Widget para alterar tema
  Widget mudarTema() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.brightness_4),
          onPressed: () => ThemeController().switchTheme(),
        ),
      ],
    );
  }
}
