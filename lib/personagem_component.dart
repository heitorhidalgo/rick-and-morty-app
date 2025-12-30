import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rick_morty_app/personagem_controller.dart';
import 'package:rick_morty_app/theme_controller.dart';

mixin class PersonagemComponent {
  final PersonagemController controller = Get.put(PersonagemController());

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
          const SizedBox(height: 10),
          Expanded(
            child: Obx(
              () => ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.personagens.length,
                itemBuilder: (context, index) {
                  final item = controller.personagens[index];
                  return cardPersonagem(item);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget logo() {
    return Center(
      heightFactor: 1,
      child: Image.asset(
        'assets/images/logo.png',
        width: orientacao == Orientation.portrait ? 300 : 180,
        height: orientacao == Orientation.portrait ? 300 : 180,
      ),
    );
  }

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

  Widget cardPersonagem(Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: Image.network(
              item['image']!,
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

              errorBuilder:
                  (context, error, stackTrace) => const SizedBox(
                    height: 100,
                    width: 100,
                    child: Icon(Icons.error),
                  ),
            ),
          ),
          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 12,
                      color:
                          item['status'] == 'alive' ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${item['status']} - ${item['species']} (${item['gender']})',
                    ),
                    if (item.type.isNotEmpty) Text('Tipo: ${item.type}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
