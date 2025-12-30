class PersonagemModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String type;
  final String gender;

  PersonagemModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.type,
    required this.gender,
  });

  factory PersonagemModel.fromJson(Map<String, dynamic> json) {
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
