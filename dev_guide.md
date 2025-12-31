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
├── personagem_component  
├── personagem_controller    # Lógica de negócios (O Cérebro)
├── personagem_model         # Moldes dos dados (A Segurança)
├── home_page                # Telas visuais (O Rosto)
├── theme_controller.dart
└── main.dart
```
## 🏗️ 2. A Camada de Dados (Model)
**Objetivo:** Traduzir o JSON da API para objetos Dart seguros.

1. Crie a classe com atributos `final` (para garantir a imutabilidade dos dados).
2. Use o construtor `factory .fromJson` para realizar a conversão.
3. **Dica de Ouro:** Sempre use `json['campo'] ?? valor_padrao` para evitar telas vermelhas de erro (*Null Safety*).

## ⚙️ 3. A Lógica (Controller)
**Objetivo:** Buscar dados, gerenciar loading e paginação.

**Passo a passo da Lógica:**

1. **Variáveis Observáveis (`.obs`):**
    * `isLoading`: Para o controle do carregamento inicial (tela cheia).
    * `isLoadMore`: Para o controle do carregamento da paginação (loading pequeno no rodapé).
    * `lista`: A lista de dados reativa (`RxList`).

2. **ScrollController:**
    * Crie um `ScrollController` e adicione um *listener* no `onInit()` para detectar quando a posição do scroll chega ao fim da lista (`pixels >= maxScrollExtent`).

3. **Paginação:**
    * Use o método `.addAll()` para adicionar os novos itens à lista existente (ao invés de substituir).
    * Incremente uma variável `currentPage` (`++`) a cada nova busca realizada com sucesso.


## 📱 4. A Interface (View/Component)
**Objetivo:** Mostrar os dados reagindo ao Controller.

**Estrutura do Widget:**

1. Use `Obx(() => ...)` para escutar as mudanças.
2. **Trate os 3 estados:**
    * `if (isLoading)` ➔ Mostre o Loading Central.
    * `if (lista.isEmpty)` ➔ Mostre a Mensagem de Vazio.
    * `return ListView.builder` ➔ Mostre a lista de sucesso.

**Configuração do ListView:**

* **`controller`**: Conecte o `scrollController` do controller aqui.
* **`itemCount`**: Use `lista.length + 1` (Isso é crucial para caber o loading no final).
* **`itemBuilder`**: Realize a verificação do índice:
    * **Se** o índice for igual ao tamanho da lista ➔ Mostre o loading de rodapé.
    * **Senão** ➔ Mostre o Card do personagem.

## 🎨 5. Funcionalidades Extras

### Modo Escuro (ThemeController)
1. Use `GetStorage` para ler/salvar a preferência (`bool`).
2. No `main.dart`, configure: `themeMode: ThemeController().theme`.
3. Para trocar o tema: `Get.changeThemeMode(...)`.

### Dialog de Detalhes
1. No Card, envolva o widget principal com `GestureDetector` ou `InkWell`.
2. Use a função `showDialog` passando o `context` atual.
3. Passe o objeto do modelo (`item`) como parâmetro para a função do Dialog, permitindo preencher os textos dinamicamente.

---

## 📝 Checklist para Novo Projeto

- [ ] Criar projeto Flutter.
- [ ] Limpar `main.dart` e adicionar pacotes (`get`, `http`, `get_storage`).
- [ ] Criar **Model** baseado no JSON da API (com tratamento de nulos).
- [ ] Criar **Controller** com lógica de *fetch* e *scroll listener*.
- [ ] Criar **View** conectando o `ScrollController` ao ListView.
- [ ] Testar carregamento inicial e paginação infinita.
- [ ] Implementar persistência de tema (Modo Escuro).