# Time Management App

Um aplicativo Flutter completo para gestão de tempo e produtividade, com backend em Spring Boot e banco MongoDB Atlas.

## 🚀 Funcionalidades

### ✅ Implementadas
- **Autenticação de Usuário**
  - Tela de login e registro
  - Gestão de sessão com tokens JWT
  - Logout automático em caso de token expirado
  - Interface de usuário com drawer personalizado

- **Rastreamento de Tempo**
  - Cronômetro com start/stop/pause
  - Categorização de atividades
  - Histórico de sessões de trabalho

- **Gestão de Tarefas**
  - Criar, editar e excluir tarefas
  - Definir prioridades (baixa, média, alta, urgente)
  - Definir prazos com alertas
  - Marcar tarefas como concluídas

- **Dashboard Analytics**
  - Visualização de estatísticas de produtividade
  - Gráficos de tempo por categoria
  - Resumo de tarefas pendentes e concluídas
  - Relatórios personalizáveis por período

- **Interface Moderna**
  - Material Design 3
  - Tema responsivo e intuitivo
  - Navegação por bottom tabs e drawer
  - Animações fluidas

### � Em Desenvolvimento
- Backend Spring Boot (API REST)
- Integração com MongoDB Atlas
- Notificações push
- Sincronização offline

## 🛠️ Tecnologias

### Frontend (Flutter)
- **Framework**: Flutter 3.x
- **Linguagem**: Dart
- **Gerenciamento de Estado**: Provider
- **HTTP Client**: Dio
- **Charts**: FL Chart
- **Notificações**: Flutter Local Notifications
- **Armazenamento Local**: SharedPreferences

### Backend (Planejado)
- **Framework**: Spring Boot
- **Banco de Dados**: MongoDB Atlas
- **Autenticação**: JWT
- **API**: REST

## 📱 Instalação e Execução

### Pré-requisitos
- Flutter SDK (3.0+)
- Android Studio / VS Code
- Git

### Passos
1. **Clone o repositório**
   ```bash
   git clone <repository-url>
   cd time_management
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo**
   ```bash
   flutter run
   ```

## 🔐 Autenticação

O aplicativo possui um sistema completo de autenticação:

### Login
- Acesse com email e senha
- Validação de campos em tempo real
- Tratamento de erros de conexão
- Token JWT salvo automaticamente

### Registro
- Criação de nova conta
- Validação de email único
- Confirmação de senha
- Interface intuitiva

### Sessão
- Token automaticamente incluído nas requisições
- Logout automático em caso de token expirado
- Opção de logout manual
- Verificação de autenticação ao inicializar

## � Estrutura do Projeto

```
lib/
├── main.dart                 # Entrada da aplicação
├── models/                   # Modelos de dados
│   ├── user.dart
│   ├── task.dart
│   ├── time_entry.dart
│   └── category.dart
├── providers/                # Gerenciamento de estado
│   ├── auth_provider.dart
│   ├── task_provider.dart
│   └── time_tracking_provider.dart
├── services/                 # Serviços e APIs
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── task_service.dart
│   └── time_entry_service.dart
├── screens/                  # Telas da aplicação
│   ├── auth_wrapper.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── dashboard_screen.dart
│   ├── tasks_screen.dart
│   ├── time_tracking_screen.dart
│   └── analytics_screen.dart
├── widgets/                  # Componentes reutilizáveis
│   ├── timer_widget.dart
│   └── task_summary_card.dart
└── utils/                    # Utilitários
    └── helpers.dart
```

## 🔧 Configuração

### API Configuration
1. Edite `lib/services/api_service.dart`
2. Altere a `baseUrl` para seu servidor backend:
   ```dart
   static const String baseUrl = 'https://your-api-url.com/api';
   ```

### Autenticação
O aplicativo está configurado para trabalhar com um backend que forneça:
- `POST /auth/login` - Login com email/senha
- `POST /auth/register` - Registro de usuário  
- `GET /auth/me` - Dados do usuário atual
- `POST /auth/logout` - Logout

## 🚀 Como Usar

### Primeiro Acesso
1. **Criar Conta**: Clique em "Registre-se" na tela de login
2. **Preencher Dados**: Nome, email e senha
3. **Confirmar**: Aguarde o login automático

### Login
1. **Email e Senha**: Insira suas credenciais
2. **Entrar**: Clique no botão ou pressione Enter
3. **Dashboard**: Será redirecionado automaticamente

### Navegação
- **Bottom Navigation**: Acesso rápido às seções principais
- **Drawer**: Menu lateral com opções de usuário
- **AppBar**: Acesso ao menu de logout

### Funcionalidades
- **Dashboard**: Visão geral da produtividade
- **Tarefas**: Gerenciar lista de tarefas
- **Cronômetro**: Rastrear tempo de atividades
- **Relatórios**: Analisar dados de produtividade

## 🐛 Problemas Conhecidos

- Backend ainda não implementado (dados mock)
- Notificações em desenvolvimento
- Sincronização offline pendente

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📝 Próximos Passos

1. **Backend Development**
   - Implementar API Spring Boot
   - Configurar MongoDB Atlas
   - Endpoints de autenticação

2. **Features Avançadas**
   - Notificações inteligentes
   - Relatórios avançados
   - Integração com calendário

3. **Melhorias UX**
   - Modo escuro
   - Personalização de temas
   - Tutorial inicial

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

---
*Desenvolvido com ❤️ usando Flutter*

```
lib/
├── models/          # Modelos de dados
├── services/        # Comunicação com API
├── providers/       # Gerenciamento de estado
├── screens/         # Telas do aplicativo
├── widgets/         # Widgets reutilizáveis
└── utils/           # Utilitários e helpers
```

## Instalação e Configuração

### Pré-requisitos
- Flutter SDK 3.8.1 ou superior
- Dart 3.0 ou superior
- Android Studio / VS Code com extensões Flutter
- Backend Spring Boot configurado

### Passos de Instalação

1. Clone o repositório:
```bash
git clone <repository-url>
cd time_management
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Configure a URL da API:
- Edite o arquivo `lib/services/api_service.dart`
- Altere a `baseUrl` para a URL do seu backend

4. Execute o aplicativo:
```bash
flutter run
```

## Configuração do Backend

O aplicativo requer um backend Spring Boot com as seguintes funcionalidades:

### Endpoints Principais
- `GET /api/tasks` - Listar tarefas
- `POST /api/tasks` - Criar tarefa
- `PUT /api/tasks/{id}` - Atualizar tarefa
- `DELETE /api/tasks/{id}` - Excluir tarefa
- `GET /api/time-entries` - Listar registros de tempo
- `POST /api/time-entries/start` - Iniciar cronômetro
- `POST /api/time-entries/{id}/stop` - Parar cronômetro

### Banco de Dados
O aplicativo usa MongoDB Atlas com as seguintes coleções:
- `tasks` - Armazenamento de tarefas
- `time_entries` - Registros de tempo
- `categories` - Categorias de tarefas
- `users` - Informações de usuários

## Funcionalidades Detalhadas

### Dashboard
- Resumo de tarefas pendentes e concluídas
- Cronômetro principal sempre visível
- Lista de tarefas urgentes
- Estatísticas rápidas

### Gerenciamento de Tarefas
- Criação com título, descrição e prioridade
- Definição de prazos
- Marcação como concluída
- Filtros por status e prioridade

### Rastreamento de Tempo
- Cronômetro com descrição da atividade
- Histórico de todos os registros
- Edição e exclusão de registros
- Integração com tarefas

### Relatórios e Analytics
- Gráficos de produtividade
- Distribuição de tarefas por prioridade
- Tempo médio por tarefa
- Análise de tendências

## Próximas Funcionalidades

- [ ] Sincronização offline
- [ ] Temas personalizáveis
- [ ] Exportação de relatórios
- [ ] Integração com calendário
- [ ] Modo colaborativo
- [ ] Backup automático
- [ ] Widgets para tela inicial

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## Suporte

Para suporte, envie um email para [seu-email@example.com] ou abra uma issue no GitHub.t_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 📚 Documentação

Toda a documentação técnica, guias de correção e notas de desenvolvimento estão organizadas na pasta [`docs/`](docs/).

### 📋 Principais Documentos
- [**Índice da Documentação**](docs/README.md) - Visão geral de todos os documentos
- [**Rastreamento de Edições**](docs/TASK_EDIT_TRACKING.md) - Funcionalidade de edição de tarefas
- [**Correção UTF-8**](docs/UTF8_ERROR_FIX.md) - Solução para problemas de codificação
- [**Cálculo de Tempo**](docs/TEMPO_TOTAL_TAREFA_FIX.md) - Correção dos cálculos de tempo
- [**Guia CORS**](docs/CORS_SOLUTION_GUIDE.md) - Solução para problemas CORS
- [**Build APK**](docs/APK_BUILD_GUIDE.md) - Guia para gerar APK

## 🛠️ Tecnologias

### Frontend (Flutter)
- **Framework**: Flutter 3.x
- **Linguagem**: Dart
- **Gerenciamento de Estado**: Provider
- **HTTP Client**: Dio
- **Charts**: FL Chart
- **Notificações**: Flutter Local Notifications
- **Armazenamento Local**: SharedPreferences

### Backend (Planejado)
- **Framework**: Spring Boot
- **Banco de Dados**: MongoDB Atlas
- **Autenticação**: JWT
- **API**: REST

## 📱 Instalação e Execução

### Pré-requisitos
- Flutter SDK (3.0+)
- Android Studio / VS Code
- Git

### Passos
1. **Clone o repositório**
   ```bash
   git clone <repository-url>
   cd time_management
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo**
   ```bash
   flutter run
   ```

## 🔐 Autenticação

O aplicativo possui um sistema completo de autenticação:

### Login
- Acesse com email e senha
- Validação de campos em tempo real
- Tratamento de erros de conexão
- Token JWT salvo automaticamente

### Registro
- Criação de nova conta
- Validação de email único
- Confirmação de senha
- Interface intuitiva

### Sessão
- Token automaticamente incluído nas requisições
- Logout automático em caso de token expirado
- Opção de logout manual
- Verificação de autenticação ao inicializar

## � Estrutura do Projeto

```
lib/
├── main.dart                 # Entrada da aplicação
├── models/                   # Modelos de dados
│   ├── user.dart
│   ├── task.dart
│   ├── time_entry.dart
│   └── category.dart
├── providers/                # Gerenciamento de estado
│   ├── auth_provider.dart
│   ├── task_provider.dart
│   └── time_tracking_provider.dart
├── services/                 # Serviços e APIs
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── task_service.dart
│   └── time_entry_service.dart
├── screens/                  # Telas da aplicação
│   ├── auth_wrapper.dart
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── dashboard_screen.dart
│   ├── tasks_screen.dart
│   ├── time_tracking_screen.dart
│   └── analytics_screen.dart
├── widgets/                  # Componentes reutilizáveis
│   ├── timer_widget.dart
│   └── task_summary_card.dart
└── utils/                    # Utilitários
    └── helpers.dart
```

## 🔧 Configuração

### API Configuration
1. Edite `lib/services/api_service.dart`
2. Altere a `baseUrl` para seu servidor backend:
   ```dart
   static const String baseUrl = 'https://your-api-url.com/api';
   ```

### Autenticação
O aplicativo está configurado para trabalhar com um backend que forneça:
- `POST /auth/login` - Login com email/senha
- `POST /auth/register` - Registro de usuário  
- `GET /auth/me` - Dados do usuário atual
- `POST /auth/logout` - Logout

## 🚀 Como Usar

### Primeiro Acesso
1. **Criar Conta**: Clique em "Registre-se" na tela de login
2. **Preencher Dados**: Nome, email e senha
3. **Confirmar**: Aguarde o login automático

### Login
1. **Email e Senha**: Insira suas credenciais
2. **Entrar**: Clique no botão ou pressione Enter
3. **Dashboard**: Será redirecionado automaticamente

### Navegação
- **Bottom Navigation**: Acesso rápido às seções principais
- **Drawer**: Menu lateral com opções de usuário
- **AppBar**: Acesso ao menu de logout

### Funcionalidades
- **Dashboard**: Visão geral da produtividade
- **Tarefas**: Gerenciar lista de tarefas
- **Cronômetro**: Rastrear tempo de atividades
- **Relatórios**: Analisar dados de produtividade

## 🐛 Problemas Conhecidos

- Backend ainda não implementado (dados mock)
- Notificações em desenvolvimento
- Sincronização offline pendente

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📝 Próximos Passos

1. **Backend Development**
   - Implementar API Spring Boot
   - Configurar MongoDB Atlas
   - Endpoints de autenticação

2. **Features Avançadas**
   - Notificações inteligentes
   - Relatórios avançados
   - Integração com calendário

3. **Melhorias UX**
   - Modo escuro
   - Personalização de temas
   - Tutorial inicial

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

---
*Desenvolvido com ❤️ usando Flutter*

```
lib/
├── models/          # Modelos de dados
├── services/        # Comunicação com API
├── providers/       # Gerenciamento de estado
├── screens/         # Telas do aplicativo
├── widgets/         # Widgets reutilizáveis
└── utils/           # Utilitários e helpers
```

## Instalação e Configuração

### Pré-requisitos
- Flutter SDK 3.8.1 ou superior
- Dart 3.0 ou superior
- Android Studio / VS Code com extensões Flutter
- Backend Spring Boot configurado

### Passos de Instalação

1. Clone o repositório:
```bash
git clone <repository-url>
cd time_management
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Configure a URL da API:
- Edite o arquivo `lib/services/api_service.dart`
- Altere a `baseUrl` para a URL do seu backend

4. Execute o aplicativo:
```bash
flutter run
```

## Configuração do Backend

O aplicativo requer um backend Spring Boot com as seguintes funcionalidades:

### Endpoints Principais
- `GET /api/tasks` - Listar tarefas
- `POST /api/tasks` - Criar tarefa
- `PUT /api/tasks/{id}` - Atualizar tarefa
- `DELETE /api/tasks/{id}` - Excluir tarefa
- `GET /api/time-entries` - Listar registros de tempo
- `POST /api/time-entries/start` - Iniciar cronômetro
- `POST /api/time-entries/{id}/stop` - Parar cronômetro

### Banco de Dados
O aplicativo usa MongoDB Atlas com as seguintes coleções:
- `tasks` - Armazenamento de tarefas
- `time_entries` - Registros de tempo
- `categories` - Categorias de tarefas
- `users` - Informações de usuários

## Funcionalidades Detalhadas

### Dashboard
- Resumo de tarefas pendentes e concluídas
- Cronômetro principal sempre visível
- Lista de tarefas urgentes
- Estatísticas rápidas

### Gerenciamento de Tarefas
- Criação com título, descrição e prioridade
- Definição de prazos
- Marcação como concluída
- Filtros por status e prioridade

### Rastreamento de Tempo
- Cronômetro com descrição da atividade
- Histórico de todos os registros
- Edição e exclusão de registros
- Integração com tarefas

### Relatórios e Analytics
- Gráficos de produtividade
- Distribuição de tarefas por prioridade
- Tempo médio por tarefa
- Análise de tendências

## Próximas Funcionalidades

- [ ] Sincronização offline
- [ ] Temas personalizáveis
- [ ] Exportação de relatórios
- [ ] Integração com calendário
- [ ] Modo colaborativo
- [ ] Backup automático
- [ ] Widgets para tela inicial

## Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## Suporte

Para suporte, envie um email para [seu-email@example.com] ou abra uma issue no GitHub.t_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 📚 Documentação

Toda a documentação técnica, guias de correção e notas de desenvolvimento estão organizadas na pasta [`docs/`](docs/).

### 📋 Principais Documentos
- [**Índice da Documentação**](docs/README.md) - Visão geral de todos os documentos
- [**Rastreamento de Edições**](docs/TASK_EDIT_TRACKING.md) - Funcionalidade de edição de tarefas
- [**Correção UTF-8**](docs/UTF8_ERROR_FIX.md) - Solução para problemas de codificação
- [**Cálculo de Tempo**](docs/TEMPO_TOTAL_TAREFA_FIX.md) - Correção dos cálculos de tempo
- [**Guia CORS**](docs/CORS_SOLUTION_GUIDE.md) - Solução para problemas CORS
- [**Build APK**](docs/APK_BUILD_GUIDE.md) - Guia para gerar APK
