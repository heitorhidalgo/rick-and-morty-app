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

  // Design do card de personagem
  // Widget cardPersonagem() {
  //   return Card(
  //     margin: const EdgeInsets.all(10),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //     child: Row(
  //       children: [
  //         GestureDetector(
  //           // Ao tocar no card, abre os detalhes
  //           onTap: () {
  //             showDialog(
  //               context: controller.context,
  //               builder: (BuildContext context) {
  //                 return DetalhesPersonagem();
  //               },
  //             );
  //           },
  //           child: ClipRRect(
  //             // Deixa a imagem arredondada, apenas na parte superior e inferior da esquerda
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(15),
  //               bottomLeft: Radius.circular(15),
  //             ),
  //             child: Image.network(
  //               item.image,
  //               height: 100,
  //               width: 100,
  //               fit: BoxFit.cover,
  //               loadingBuilder: (context, child, progress) {
  //                 if (progress == null) return child;
  //                 return const SizedBox(
  //                   height: 100,
  //                   width: 100,
  //                   child: Center(child: CircularProgressIndicator()),
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           // Expandir para a linha toda
  //           child: Padding(
  //             padding: const EdgeInsets.all(10),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   item.name,
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 5),
  //                 Text(item.status, style: const TextStyle(fontSize: 14)),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget cardPersonagem(PersonagemModel item) {
  //   return Card(
  //     margin: const EdgeInsets.all(10),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //     child: Row(
  //       children: [
  //         GestureDetector(
  //           // Ao tocar no card, abre os detalhes
  //           onTap: () {
  //             showDialog(
  //               context: controller.context,
  //               builder: (BuildContext context) {
  //                 return detalhesPersonagem(item);
  //               },
  //             );
  //           },
  //           child: ClipRRect(
  //             // Deixa a imagem arredondada, apenas na parte superior e inferior da esquerda
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(15),
  //               bottomLeft: Radius.circular(15),
  //             ),
  //             child: Image.network(
  //               item.image,
  //               height: 100,
  //               width: 100,
  //               fit: BoxFit.cover,
  //               loadingBuilder: (context, child, progress) {
  //                 if (progress == null) return child;
  //                 return const SizedBox(
  //                   height: 100,
  //                   width: 100,
  //                   child: Center(child: CircularProgressIndicator()),
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           // Expandir para a linha toda
  //           child: Padding(
  //             padding: const EdgeInsets.all(10),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   item.name,
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 5),
  //                 Text(item.status, style: const TextStyle(fontSize: 14)),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget detalhesPersonagem(PersonagemModel item) {
  //   return AlertDialog(
  //     // Caixa de texto que irá aparecer na tela ao clicar no card
  //     content: Container(
  //       width: orientacao == Orientation.portrait ? 275 : 225,
  //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
  //       padding: const EdgeInsets.only(left: 10, top: 10),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min, // Ajusta altura ao conteúdo
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const SizedBox(height: 20),
  //           Center(
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(25),
  //               child: Image.network(item.image, width: 150, height: 150),
  //             ),
  //           ),
  //           const SizedBox(height: 30),
  //           Text(
  //             'Nome: ${item.name}',
  //             style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 10),
  //           Text(
  //             'Status: ${item.status}',
  //             style: const TextStyle(fontSize: 23),
  //           ),
  //           const SizedBox(height: 5),
  //           Text(
  //             'Espécie: ${item.species}',
  //             style: const TextStyle(fontSize: 23),
  //           ),
  //           const SizedBox(height: 5),
  //           Text(
  //             'Gênero: ${item.gender}',
  //             style: const TextStyle(fontSize: 23),
  //           ),
  //           const SizedBox(height: 5),
  //           if (item.type.isEmpty)
  //             const Text('Tipo: unknown', style: TextStyle(fontSize: 23))
  //           else
  //             Text('Tipo: ${item.type}', style: const TextStyle(fontSize: 23)),
  //         ],
  //       ),
  //     ),
  //     actions: [
  //       TextButton(
  //         onPressed: () => Get.back(),
  //         child: const Text('Fechar', style: TextStyle(fontSize: 20)),
  //       ),
  //     ],
  //   );
  // }
}
