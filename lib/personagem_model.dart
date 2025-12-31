class PersonagemModel {
  // ATRIBUTOS
  // Usamos 'final' para garantir que os dados não sejam alterados acidentalmente
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String type;
  final String gender;

  // CONSTRUTOR
  // O 'required' obriga que quem criar esse objeto passe todos os dados
  PersonagemModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.type,
    required this.gender,
  });

  // FÁBRICA (FACTORY)
  // Esse métod é o "tradutor". Ele pega o Mapa (JSON) bagunçado da API e transforma em um objeto PersonagemModel organizado e seguro.
  factory PersonagemModel.fromJson(Map<String, dynamic> json) {
    return PersonagemModel(
      // Tratamento de segurança (Null Safety):
      // Se o campo vier nulo (null), usamos o valor padrão à direita do '??'

      id: json['id'] ?? 0, // Se não tiver ID, assume 0
      name: json['name'] ?? 'Unknown', // Se não tiver nome
      status: json['status'] ?? 'Unknown',
      species: json['species'] ?? 'Unknown',
      image: json['image'] ?? '', // Se não tiver imagem, fica vazio (tratamos na tela)
      type: json['type'] ?? '', // API costuma mandar vazio ou nulo aqui
      gender: json['gender'] ?? 'Unknown',
    );
  }
}