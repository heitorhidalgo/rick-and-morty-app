class PersonagemModel {
  //atributos
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String type;
  final String gender;

  PersonagemModel({
    //construtores
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.type,
    required this.gender,
  });

  factory PersonagemModel.fromJson(Map<String, dynamic> json) {
    //Dados que chegam da api
    return PersonagemModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      species: json['species'] ?? '',
      image: json['image'] ?? '',
      type: json['type'] ?? '',
      gender: json['gender'] ?? '',
    );
  }
}
