# 📚 STODO - Gerenciador Unificado de Estudos

O **STODO** é um ecossistema mobile de alta performance projetado para centralizar o fluxo de aprendizado. Ele permite que o usuário organize seus conteúdos por **Tópicos** e realize o rastreio fino de progresso de leitura (baseado no benchmark *Skoob*), unificando materiais de estudo em uma única interface intuitiva.

---

## 🚀 Visão Geral do Produto

O STODO resolve a fragmentação do acompanhamento de estudos através de um **Agrupamento Flexível**. O usuário pode:
1.  **Criar Tópicos:** Categorizar por disciplina (ex: Flutter, Direito Civil).
2.  **Gerenciar Livros:** Cadastrar obras com status detalhados.
3.  **Vínculo Opcional:** Um livro pode ou não pertencer a um tópico, reduzindo a fricção no cadastro inicial.

---

## 🛠️ Stack Técnica & Dependências

O projeto utiliza **Flutter** com foco em persistência local robusta e baixa latência de interface.

### Dependências Core (`pubspec.yaml`)
```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.4.2          # Engine SQLite para persistência relacional
  path: ^1.9.1             # Utilitário para manipulação de caminhos
  path_provider: ^2.1.5    # Acesso aos diretórios seguros do sistema
  image_picker: ^1.2.1     # Captura e seleção de capas de livros
  flutter_bloc: ^9.1.1     # Gerenciamento de estado com BLoC/Cubit
```

### 💾 Estratégia de Persistência e Mídia
1. **Gestão de Imagens (Capas)**
Para manter o banco de dados leve e performático, o STODO utiliza o Padrão de Referência de Caminho. Não salvamos arquivos binários (BLOB) no SQLite.

**Fluxo de Implementação:**
- Captura da imagem via `image_picker`.
- Cópia do arquivo para o diretório permanente (`getApplicationDocumentsDirectory`).
- Persistência da String do caminho final no banco de dados.

```dart
Future<String> salvarImagemLocal(XFile image) async {
  final directory = await getApplicationDocumentsDirectory();
  final name = basename(image.path);
  final imagePath = '${directory.path}/$name';
  final File localImage = await File(image.path).copy(imagePath);

  return localImage.path; // Caminho salvo na coluna 'cover_path'
}
```

2. **Exibição de Mídia**
```dart
Image.file(File(caminhoRecuperadoDoBanco))
```

---

## 🗄️ Arquitetura do Banco de Dados (sqflite)
O esquema foi projetado para garantir a integridade dos dados e o suporte a livros órfãos (sem tópico).

```sql
-- Tabela de Agrupadores
CREATE TABLE topics (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  icon_id TEXT,
  color_hex TEXT
);

-- Tabela de Livros (Skoob Style)
CREATE TABLE books (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  author TEXT,
  total_pages INTEGER,
  current_page INTEGER DEFAULT 0,
  status TEXT, -- Lendo, Lido, Relendo, Quero Ler, Abandonei
  cover_path TEXT,
  topic_id INTEGER NULL, -- Relacionamento Opcional
  FOREIGN KEY (topic_id) REFERENCES topics (id) ON DELETE SET NULL
);
```

---

## 🏗️ Arquitetura de Pastas

O projeto segue uma estrutura modular para facilitar a manutenção e escalabilidade:

```text
lib/
├── app/
│   ├── dashboard/
│   │   ├── cubit/
│   │   ├── pages/
│   │   ├── repository/
│   │   └── states/
│   ├── library/
│   │   ├── cubit/
│   │   ├── pages/
│   │   ├── repository/
│   │   └── states/
│   └── topics/
│       ├── cubit/
│       ├── pages/
│       ├── repository/
│       └── states/
└── core/
    ├── components/
    ├── db/
    ├── image_picker/
    ├── storage/
    └── themes/
```

---

## 🎯 Funcionalidades de Destaque (Diferenciais)
- **Tracker com Input Manual:** Além dos botões de incremento (+/-), o STODO possui um campo numérico digitável para atualizações rápidas de grandes volumes de página.
- **Status Automático:** O sistema monitora o progresso. Ao atingir a última página, o status transita automaticamente para LIDO.
- **Interface Dark Blue:** Design System focado em baixa fadiga visual com fundo `#0A0E14` e destaques em `#3A86FF`.
- **Onboarding Dinâmico:** Dashboard com tratamento de Empty States para guiar o usuário no primeiro acesso.

---

## 🛠️ Configuração do Projeto

### ⚓ Git Hooks e Padronização de Commits
Este projeto utiliza **Git Hooks** para garantir a qualidade do código e o versionamento semântico automático.

#### Como configurar:
1. No terminal, na raiz do projeto, execute o script de instalação:
   ```bash
   chmod +x scripts/install-hooks.sh
   ./scripts/install-hooks.sh
   ```

#### Regras de Commit:
- **Branch Protection:** Não é permitido fazer commits diretamente na branch `main`. Utilize branches de funcionalidade (ex: `feat/minha-feature`).
- **Conventional Commits:** As mensagens de commit devem seguir o padrão `<tipo>(escopo): <descrição>`.
  - `feat`: Nova funcionalidade (gera **Minor** version bump).
  - `fix`: Correção de bug (gera **Patch** version bump).
  - `chore`, `docs`, `style`, `refactor`, `perf`, `test`: Outras alterações (gera **Patch** version bump).
  - Adicione `!` após o tipo para **BREAKING CHANGES** (gera **Major** version bump).

---

## 📅 Planejamento de Sprints (Roadmap MVP)

### Sprint 1: Fundação & Estrutura (23/03 - 03/04)
- **Foco:** Design UI, Setup de Arquitetura e CRUD de Tópicos.
- **Story Points:** 13 SP.

### Sprint 2: Core & Tracking (06/04 - 17/04)
- **Foco:** Módulo de Livros (Skoob Style), Input Manual e Dashboard de Retomada.
- **Story Points:** 18 SP.
