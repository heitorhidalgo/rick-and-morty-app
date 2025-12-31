import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rick_morty_app/personagem_controller.dart';
import 'package:rick_morty_app/personagem_model.dart';
import 'package:rick_morty_app/theme_controller.dart';

mixin class PersonagemComponent {
  final PersonagemController controller = Get.put(PersonagemController());
  PersonagemModel? personagem;

  late Orientation orientacao;

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
              //Deixando observável com o GetX
              //loading inicial
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
              }
              //Quando a lista estiver vazia
              if (controller.personagens.isEmpty) {
                return const Center(
                  child: Text('Nenhum personagem encontrado'),
                );
              }
              //Mostra a lista no caso de sucesso
              return ListView.builder(
                //conexão com o sensor
                controller: controller.scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                itemCount:
                    controller.personagens.length +
                    1, //lista tem o tamanho dos personagens + 1 (para o loading do fim)
                itemBuilder: (context, index) {
                  //lógica do fim da lista
                  if (index == controller.personagens.length) {
                    return const Padding(
                      padding: EdgeInsets.all(15),
                      child: Center(),
                    );
                  }
                  final item = controller.personagens[index];
                  return cardPersonagem(item);
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
        //Sempre que colocar alguma imagem, ir no pubspec.yaml e alterar o assets, colocando o caminho correto
        'assets/images/logo.png',
        width: orientacao == Orientation.portrait ? 300 : 180,
        height: orientacao == Orientation.portrait ? 300 : 180,
      ),
    );
  }

  //Widget para alterar tema, criado junto com a theme_controller
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
  Widget cardPersonagem(PersonagemModel item) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          GestureDetector(
            //Ao tocar no card, abre os detalhes
            onTap: () {
              showDialog(
                context: controller.context,
                builder: (BuildContext context) {
                  return detalhesPersonagem(item);
                },
              );
              // SHOW DIALOG
            },
            child: ClipRRect(
              //Deixa a imagem arredondada
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: Image.network(
                item.image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    height: 100,
                    width: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
          ),
          Expanded(
            //Expandir para a linha toda
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(item.status, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget detalhesPersonagem(PersonagemModel item) {
    return AlertDialog(
      //Caixa de texto que irá aparecer na tela ao clicar no card
      content: Container(
        height: orientacao == Orientation.portrait ? 500 : 350,
        width: orientacao == Orientation.portrait ? 275 : 225,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.only(left: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(item.image, width: 150, height: 150),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Nome: ${item.name}',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Status: ${item.status}', style: TextStyle(fontSize: 23)),
            const SizedBox(height: 5),
            Text('Espécie: ${item.species}', style: TextStyle(fontSize: 23)),
            const SizedBox(height: 5),
            Text('Gênero: ${item.gender}', style: TextStyle(fontSize: 23)),
            const SizedBox(height: 5),
            if (item.type.isEmpty)
              Text('Tipo: unknown', style: TextStyle(fontSize: 23))
            else
              Text('Tipo: ${item.type}', style: TextStyle(fontSize: 23)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Fechar', style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }
}
