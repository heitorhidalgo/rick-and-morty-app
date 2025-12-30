import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonagemController extends GetxController {
  late BuildContext context;

  final RxList<Map<String, String>> personagens =
      <Map<String, String>>[
        {
          'name': 'Rick Sanchez',
          'status': 'alive',
          'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
          'species': 'human',
        },
        {
          'name': 'Morty Smith',
          'status': 'alive',
          'image': 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
          'species': 'human',
        },
        {
          'name': 'Summer Smith',
          'status': 'alive',
          'image': 'https://rickandmortyapi.com/api/character/avatar/3.jpeg',
          'species': 'human',
        },
      ].obs;
}
