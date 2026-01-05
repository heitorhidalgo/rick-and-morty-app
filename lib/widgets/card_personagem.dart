import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rick_morty_app/personagem/personagem_controller.dart';

import '../models/personagem_model.dart';
import 'detalhes_personagem.dart';

class CardPersonagem extends StatelessWidget {
  PersonagemController controller = Get.put(PersonagemController());

  PersonagemModel? item;
  double? alturaImagem;
  double? larguraImagem;
  double? tamanhoFonteNome;
  double? tamanhoFonteStatus;
  Orientation orientacao;

  CardPersonagem(
    this.item,
    this.alturaImagem,
    this.larguraImagem,
    this.tamanhoFonteNome,
    this.tamanhoFonteStatus,
    this.orientacao,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: controller.context,
                builder: (BuildContext context) {
                  return DetalhesPersonagem(
                    item,
                    150,
                    150,
                    23,
                    23,
                    23,
                    23,
                    23,
                    'Fechar',
                    20,
                    orientacao,
                  );
                },
              );
            },
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: Image.network(
                item!.image,
                height: alturaImagem,
                width: larguraImagem,
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
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item!.name,
                    style: TextStyle(
                      fontSize: tamanhoFonteNome,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item!.status,
                    style: TextStyle(fontSize: tamanhoFonteStatus),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
