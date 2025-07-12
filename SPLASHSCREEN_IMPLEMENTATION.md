# Splashscreen Dinâmico - Time Management App

## Visão Geral
Implementação de um splashscreen dinâmico e moderno para o app de gestão de tempo, com animações fluidas e mensagens rotativas sobre as funcionalidades do aplicativo.

## Características Implementadas

### 🎨 Design Visual
- **Gradient Background**: Fundo com gradiente usando as cores do tema
- **Logo Animado**: Ícone principal com animações de fade e escala
- **Cards Flutuantes**: Mensagens com efeito glassmorphism
- **Partículas Flutuantes**: Efeito visual com partículas animadas em movimento
- **Barra de Progresso**: Indicador visual do carregamento
- **Indicadores**: Pontos que mostram a mensagem atual
- **Design Responsivo**: Adaptação automática para diferentes tamanhos de tela

### ⚡ Animações
- **Fade In**: Entrada suave dos elementos
- **Scale Animation**: Animação elástica do logo
- **Progress Animation**: Barra de progresso linear
- **Message Transition**: Transição suave entre mensagens
- **Floating Particles**: Partículas com movimento contínuo e suave

### 📱 Responsividade
- **Detecção de Tela**: Adaptação automática para telas pequenas (< 600px altura ou < 360px largura)
- **Tamanhos Adaptativos**: Logo, texto e espaçamentos ajustados automaticamente
- **Layout Flexível**: Uso de Expanded e Flexible para adaptação dinâmica

### 📱 Mensagens Dinâmicas
1. **Organização**: "Organize suas tarefas com prioridades"
2. **Rastreamento**: "Rastreie seu tempo com precisão"
3. **Analytics**: "Analise sua produtividade"
4. **Notificações**: "Receba alertas e lembretes"
5. **Relatórios**: "Visualize relatórios detalhados"
6. **Eficiência**: "Maximize sua eficiência"

### 🔧 Funcionalidades Técnicas
- **Timer-based Rotation**: Mensagens mudam a cada 2 segundos
- **Navigation Timing**: Transição para AuthWrapper após 14 segundos
- **Memory Management**: Disposição adequada dos controllers
- **Responsive Design**: Adaptação a diferentes tamanhos de tela
- **Sync Timing**: Saída sincronizada após exibir todas as mensagens

## Arquitetura

### Estrutura do Widget
```
SplashScreen (StatefulWidget)
├── AnimationControllers (fade, scale, progress)
├── Timer (message rotation)
├── Navigation Logic
└── UI Components
    ├── Logo Section
    ├── Dynamic Messages
    └── Progress Indicators
```

### Animações Utilizadas
- **FadeTransition**: Para entrada suave
- **ScaleTransition**: Para efeito elástico do logo
- **AnimatedSwitcher**: Para transição entre mensagens
- **SlideTransition**: Para movimento vertical das mensagens

## Configuração

### Dependências
- `flutter/material.dart`
- `dart:async`
- `dart:math` (para partículas)

### Widgets Personalizados
- `SplashScreen`: Widget principal do splash
- `FloatingParticles`: Widget de partículas animadas
- `ParticlesPainter`: CustomPainter para renderização das partículas

### Integração
O splashscreen é configurado como tela inicial no `main.dart`:
```dart
home: const SplashScreen(),
```

### Duração
- **Tempo total**: 14 segundos
- **Rotação de mensagens**: 2 segundos por mensagem
- **Ciclo completo**: 6 mensagens × 2s = 12 segundos + 2s de buffer
- **Animação de entrada**: 800ms (fade) + 1200ms (scale)
- **Progresso**: 14 segundos (linear, sincronizado com a saída)

## Personalização

### Cores
As cores são automaticamente adaptadas ao tema do app:
- Primary, Secondary, Tertiary colors
- Transparências para efeito glassmorphism

### Mensagens
Facilmente modificáveis no array `_messages`:
```dart
final List<Map<String, dynamic>> _messages = [
  {
    'text': 'Sua mensagem aqui',
    'icon': Icons.seu_icone,
    'color': Colors.sua_cor,
  },
];
```

### Timing
Configurável através das constantes:
- `Duration(seconds: 14)`: Tempo total de exibição
- `Duration(seconds: 2)`: Rotação de mensagens
- `Duration(milliseconds: 800)`: Fade animation
- `Duration(milliseconds: 1200)`: Scale animation

## Benefícios

### UX (Experiência do Usuário)
- **Primeira Impressão**: Visual moderno e profissional
- **Engajamento**: Mensagens sobre funcionalidades geram interesse
- **Feedback Visual**: Progress bar informa o status do carregamento
- **Transição Suave**: Navigation com fade transition

### Performance
- **Lazy Loading**: Permite inicialização em background
- **Memory Efficient**: Adequada disposição de resources
- **Smooth Animations**: 60fps com animações otimizadas

### Branding
- **Identidade Visual**: Cores e estilo consistentes com o app
- **Funcionalidades**: Apresenta as principais features
- **Profissionalismo**: Demonstra qualidade e atenção aos detalhes

## Melhorias Futuras
- [x] ~~Adicionar animações de partículas~~ ✅ Implementado
- [ ] Implementar splash personalizado por horário do dia
- [ ] Adicionar sons/haptic feedback
- [ ] Carregar dados em background durante o splash
- [ ] Personalização baseada no perfil do usuário
- [ ] Permitir pular o splash com toque/tap

## Arquivos Modificados
- `/lib/screens/splash_screen.dart` (novo)
- `/lib/widgets/floating_particles.dart` (novo)
- `/lib/main.dart` (atualizado)

## Exemplo de Uso
O splashscreen é automaticamente exibido ao iniciar o app e redireciona para `AuthWrapper` após 3 segundos com uma transição suave.

### Configuração de Partículas
```dart
FloatingParticles(
  particleCount: 15,        // Número de partículas
  color: Colors.white,      // Cor das partículas
  minSize: 1.5,            // Tamanho mínimo
  maxSize: 4.0,            // Tamanho máximo
)
```

### Responsividade Automática
```dart
final isSmallScreen = screenHeight < 600 || screenWidth < 360;
// Ajustes automáticos de tamanho baseados na detecção
```

## 🕐 Timing Otimizado para UX

O splashscreen foi cuidadosamente cronometrado para proporcionar a melhor experiência do usuário:

### Sequência de Mensagens
- **Mensagem 1** (0-2s): "Organize suas tarefas com prioridades"
- **Mensagem 2** (2-4s): "Rastreie seu tempo com precisão"  
- **Mensagem 3** (4-6s): "Analise sua produtividade"
- **Mensagem 4** (6-8s): "Receba alertas e lembretes"
- **Mensagem 5** (8-10s): "Visualize relatórios detalhados"
- **Mensagem 6** (10-12s): "Maximize sua eficiência"
- **Buffer** (12-14s): Transição suave para o app

### Benefícios do Timing Estendido
- ⏰ **2 segundos por mensagem**: Tempo suficiente para ler e absorver
- 🔄 **Ciclo completo**: Usuário vê todas as funcionalidades
- 🎯 **Sincronização**: Saída após mostrar todas as features
- 📱 **Não intrusivo**: Tempo adequado sem ser excessivo
- 🎨 **Progressão visual**: Barra de progresso acompanha o timing
