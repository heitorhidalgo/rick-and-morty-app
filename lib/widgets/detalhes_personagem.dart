import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/personagem_model.dart';
import '../personagem/personagem_controller.dart';

class DetalhesPersonagem extends StatelessWidget {
  PersonagemController controller = Get.put(PersonagemController());

  PersonagemModel? item;
  double? larguraImagem;
  double? alturaImagem;
  double? tamanhoFonteNome;
  double? tamanhoFonteStatus;
  double? tamanhoFonteEspecie;
  double? tamanhoFonteGenero;
  double? tamanhoFonteTipo;
  String? textoDialog;
  double? tamanhoTextoDialog;
  Orientation orientacao;

  DetalhesPersonagem(
    this.item,
    this.larguraImagem,
    this.alturaImagem,
    this.tamanhoFonteNome,
    this.tamanhoFonteStatus,
    this.tamanhoFonteEspecie,
    this.tamanhoFonteGenero,
    this.tamanhoFonteTipo,
    this.textoDialog,
    this.tamanhoTextoDialog,
    this.orientacao,
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: orientacao == Orientation.portrait ? 275 : 225,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  item!.image,
                  width: larguraImagem,
                  height: alturaImagem,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Nome: ${item!.name}',
              style: TextStyle(
                fontSize: tamanhoFonteNome,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Status: ${item!.status}',
              style: TextStyle(fontSize: tamanhoFonteStatus),
            ),
            const SizedBox(height: 5),
            Text(
              'Espécie: ${item!.species}',
              style: TextStyle(fontSize: tamanhoFonteEspecie),
            ),
            const SizedBox(height: 5),
            Text(
              'Gênero: ${item!.gender}',
              style: TextStyle(fontSize: tamanhoFonteGenero),
            ),
            const SizedBox(height: 5),
            if (item!.type.isEmpty)
              Text(
                'Tipo: unknown',
                style: TextStyle(fontSize: tamanhoFonteTipo),
              )
            else
              Text(
                'Tipo: ${item!.type}',
                style: TextStyle(fontSize: tamanhoFonteTipo),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            '$textoDialog',
            style: TextStyle(fontSize: tamanhoTextoDialog),
          ),
        ),
      ],
    );
  }
}
