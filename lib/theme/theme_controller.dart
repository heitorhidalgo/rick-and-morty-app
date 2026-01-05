import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController {
  // Cria a instância do banco de dados local
  final _box = GetStorage();

  // A chave que usaremos para salvar a escolha (como se fosse o nome da pasta no arquivo)
  final _key = 'isDarkMode';

  // --- MÉTODOS PRIVADOS (Internos) ---

  // Tenta ler do banco: O usuário já escolheu o tema antes?
  // Se _box.read retornar nulo (primeira vez), usa 'false' (Modo Claro) como padrão.
  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  // Salva a nova escolha no banco de dados
  _saveThemeBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  // --- MÉTODOS PÚBLICOS (Usados na Tela) ---

  // Essa propriedade é chamada lá no main.dart (themeMode: ThemeController().theme)
  // Ela decide qual tema o app deve usar ao abrir.
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  // Essa é a função do botão de trocar tema (o ícone da lua/sol)
  void switchTheme() {
    // Muda visualmente o tema na hora (GetX faz a mágica)
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);

    // Salva o INVERSO do que estava antes para lembrar na próxima vez
    _saveThemeBox(!_loadThemeFromBox());
  }
}