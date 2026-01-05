# 📘 Guia de Desenvolvimento - Template MVC com GetX

Este projeto serve como base para aplicativos que consomem APIs REST, possuem listagem infinita (paginação), modo escuro e gerenciamento de estado com GetX.

---

## 🚀 1. Setup Inicial

**Dependências (`pubspec.yaml`):**
Adicione os pacotes essenciais para requisições, estado e persistência local.
```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6           # Gerência de estado e rotas
  http: ^1.2.0          # Requisições API
  get_storage: ^2.1.1   # Salvar dados (ex: tema escuro)

```

### 📂 Estrutura de Pastas Recomendada (MVC ajustado)

```text
lib/
├── personagem_component     # Widgets reutilizáveis (Card, Botões)
├── personagem_controller    # Lógica de negócios (GetxController)
├── personagem_model         # Moldes dos dados (Classes)
├── home_page                # Telas visuais (Scaffolds)
├── theme_controller.dart    # Lógica de temas
└── main.dart
```
## 📱 2. Page (A Tela Estática)
**Objetivo:** Desenhar a tela completa usando dados falsos (Mock).

1. **Arquivo:** ex: `home_page.dart`.
2. **Desenhe a Estrutura:** Use `Scaffold`, `AppBar` e `ListView`.
3. **Use Dados "Mockados" (Hardcoded):** Escreva os textos e links de imagens diretamente no código.
    * *Por que?* Para ver o resultado na hora, sem depender de internet ou API.
4. **Estilize:** Ajuste fontes, cores e espaçamentos (`Padding`, `SizedBox`) até ficar idêntico ao design desejado.

```dart
// Exemplo de código nesta fase:
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personagens')),

      // Lista estática apenas para testar o scroll e visual
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // MOCK 1: Desenhamos o card com dados fixos
          Card(
            color: Colors.grey[800],
            child: Row(
              children: [
                // Imagem fixa da internet ou ícone para testar tamanho
                Container(
                  width: 100, height: 100,
                  color: Colors.green, // Simulando imagem carregada
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    // AQUI: Escrevemos direto o que queremos ver
                    Text("Rick Sanchez", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text("Alive - Human", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // MOCK 2: Copiamos e colamos o card só para ver a lista cheia
          Card(
            color: Colors.grey[800],
            child: Row(
              children: [
                Container(
                  width: 100, height: 100,
                  color: Colors.yellow,
                  child: const Icon(Icons.person, size: 50, color: Colors.black),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Morty Smith", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text("Alive - Human", style: TextStyle(color: Colors.grey)),
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
```

## 🧩 3. Component (Organização)
**Objetivo:** Organizar o código e preparar para reutilização.

1. **Identifique a Repetição:** Olhe para o seu `ListView`. O código do Card se repete? Se sim, ele deve virar um componente.
2. **Extraia o Widget:** Recorte o código do Card e crie uma função ou um Widget separado (ex: `cardPersonagem`).
3. **Crie Parâmetros:** Substitua os textos fixos ("Rick Sanchez") por variáveis que chegam no construtor da função (`String nome`, `String status`).
    * *Por que?* Assim, o mesmo componente serve para desenhar o Rick, o Morty ou qualquer outro personagem.

```dart
// Exemplo: Transformando o card em componente
// Exemplo: Transformamos aquele monte de código da Fase 1 nesta função limpa

// 1. Recebemos os dados variáveis como parâmetros (Argumentos)
Widget cardPersonagem({
  required String name,
  required String status,
  required Color colorTest, // Apenas para manter o teste visual por enquanto
}) {

  // 2. Retornamos o layout que recortamos da Page
  return Card(
    margin: const EdgeInsets.only(bottom: 10),
    color: Colors.grey[800],
    child: Row(
      children: [
        // Imagem (Ainda simulada, mas usando a cor passada por parâmetro)
        Container(
          width: 100, height: 100,
          color: colorTest,
          child: const Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3. Usamos a variável 'name' em vez do texto fixo
            Text(
                name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)
            ),

            // Usamos a variável 'status'
            Text(
                status,
                style: const TextStyle(color: Colors.grey)
            ),
          ],
        ),
      ],
    ),
  );
}

// --- COMO FICA A PAGE AGORA ---
// body: ListView(
//   children: [
//      cardPersonagem(name: "Rick", status: "Alive", colorTest: Colors.green),
//      cardPersonagem(name: "Morty", status: "Alive", colorTest: Colors.yellow),
//   ]
// )
```


## 📝 4. Model (O Contrato)
**Objetivo:** Definir a estrutura de dados baseada no que foi desenhado.

1. **Crie os atributos:** Olhe para o seu Widget de Card. Quais informações ele pede?
    * *Tem foto?* Precisa de uma `String image`.
    * *Tem nome?* Precisa de uma `String name`.
    * *Tem status?* Precisa de uma `String status`.
2. **Imutabilidade:** Crie a classe em models com atributos `final` (imutáveis).
3. **Conversão dos dados da API:** Crie o `factory .fromJson` para converter o mapa da API neste objeto, usando `??` para evitar erros caso venha nulo.

```dart
// Exemplo de código nesta fase:
class PersonagemModel {
  // 1. Atributos definidos pelo que a UI precisa
  final int id;
  final String name;
  final String status;
  final String image;

  // 2. Construtor padrão com 'required'
  PersonagemModel({
    required this.id,
    required this.name,
    required this.status,
    required this.image,
  });

  // 3. O "Tradutor" (Factory) com segurança de nulos
  factory PersonagemModel.fromJson(Map<String, dynamic> json) {
    return PersonagemModel(
      // Se 'id' for nulo, usa 0
      id: json['id'] ?? 0, 
      
      // Se 'name' for nulo, exibe 'Desconhecido' na tela
      name: json['name'] ?? 'Desconhecido', 
      
      // Se 'status' vier vazio, coloca 'Unknown'
      status: json['status'] ?? 'Unknown',
      
      // Se não tiver imagem, deixa vazio (o componente de imagem deve tratar isso)
      image: json['image'] ?? '', 
    );
  }
}
```


## ⚙️ 5. Controller (O Motor)
**Objetivo:** Criar a lógica que vai substituir os dados falsos por dados reais da API.

1. **Arquivo:** Crie o arquivo do controller (ex: `personagem_controller.dart`).
2. **Observabilidade:** Crie as **variáveis observáveis (`.obs`)**. Elas são os "baldes" onde guardaremos os dados que vêm da internet.
3. **Busca de dados:** Implemente a função que busca os dados (o método `fetch`).
4. **Gerenciamento de estado:** Gerencie o estado de carregamento (`isLoading`) para saber quando mostrar a bolinha girando.

```dart
// Exemplo de código nesta fase:
class PersonagemController extends GetxController {
  // 1. Variáveis Observáveis (O Estado)
  // isLoading começa true para mostrarmos o loading assim que a tela abrir
  final isLoading = true.obs;
  final listaPersonagens = <PersonagemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    buscarDados(); // Chama a busca assim que o controller nasce
  }

  // 2. A Função de Busca (A Ação)
  Future<void> buscarDados() async {
    try {
      isLoading.value = true;
      // ... aqui vai sua chamada http (http.get...) ...

      // Simulando o preenchimento da lista com dados da API
      // listaPersonagens.value = ... (resultado da api convertido)
    } catch (e) {
      print("Deu erro: $e");
    } finally {
      // Independente de sucesso ou erro, desligamos o loading
      isLoading.value = false;
    }
  }
}
```

## 🔌️ 6. A Conexão (Integração) 
**Objetivo:** Ligar a Tela (View) ao Motor (Controller).

1. **Atualização:** Volte no arquivo da sua Page ou Component.
2. **Injeção de dependência:** Injete o Controller: Use Get.put() para inicializar a lógica criada na fase anterior.
3. **Reatividade:** Use o Obx: Envolva a parte da tela que muda (a lista) com o widget Obx.
4. **Substituição:** Substitua os dados fixos: Onde estava "Rick Sanchez", coloque controller.lista[index].name.

```dart
// Exemplo de código nesta fase:
class HomePage extends StatelessWidget {
  // 1. Injetando o Controller (O Motor)
  final controller = Get.put(PersonagemController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Personagens")),

      // 2. O Obx escuta as mudanças nas variáveis .obs
      body: Obx(() {

        // Estado A: Ainda está carregando?
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // Estado B: Carregou e tem dados?
        return ListView.builder(
          itemCount: controller.listaPersonagens.length,
          itemBuilder: (context, index) {
            // Pegamos o item real da lista
            final item = controller.listaPersonagens[index];

            // 3. Chamamos o componente criado na Fase 2, mas agora com DADOS REAIS
            return cardPersonagem(
              nome: item.name,      // Antes era "Rick" (fixo)
              status: item.status,  // Antes era "Alive" (fixo)
              imagem: item.image,
            );
          },
        );
      }),
    );
  }
}
```
---

## 📝 Checklist de Execução (UI First)

### Fase 1: Preparação
- [ ] **Setup:** Criar o projeto (`flutter create`) e limpar o `main.dart`.
- [ ] **Dependências:** Adicionar `get`, `http` e `get_storage` no `pubspec.yaml`.
- [ ] **Estrutura:** Criar os arquivos `pages`, `controllers`, `models`.

### Fase 2: Visual
- [ ] **Design:** Desenhar a tela completa com `Scaffold` e Widgets básicos.
- [ ] **Mock:** Preencher com textos, cores e imagens fixas (Hardcoded) para validar o visual.
- [ ] **Refatorar:** Identificar códigos repetidos e extrair para Componentes/Widgets.

### Fase 3: Lógica
- [ ] **Model:** Criar a classe Model baseada **apenas** nos campos que você desenhou na tela.
- [ ] **Controller:** Criar a lógica de busca (API) e as variáveis de estado (`.obs`).

### Fase 4: Conexão
- [ ] **Injeção:** Inicializar o Controller na Page (`Get.put`).
- [ ] **Reatividade:** Envolver os widgets dinâmicos com `Obx(() => ...)`.
- [ ] **Integrar:** Substituir os dados fixos ("Mock") pelos dados reais do Controller.

---