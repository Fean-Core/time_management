# Implementação de Fundo Global e Transparência

## Mudanças Implementadas

### 1. AppWrapper (`lib/widgets/app_wrapper.dart`)
- Widget que aplica um fundo global ao app inteiro
- Gradiente suave: cinza claro para azul muito claro
- Padrão geométrico sutil com linhas e círculos
- Transparência muito baixa (3%) para não interferir na leitura

### 2. Aplicação Global (`lib/main.dart`)
- Adicionado `builder` no MaterialApp para aplicar o AppWrapper globalmente
- Todas as telas agora têm o fundo automaticamente

### 3. TimerWidget (`lib/widgets/timer_widget.dart`)
- AlertDialog com transparência de 95% para melhor integração visual
- Timer já possui fundo semi-transparente (20% de opacidade)

### 4. TransparentCard (`lib/widgets/background_container.dart`)
- Widget auxiliar para criar cards com transparência
- Pode ser usado para aplicar transparência a widgets específicos

## Como Reverter para Layout Anterior

### Opção 1: Desabilitar Globalmente
```dart
// No main.dart, remover ou comentar o builder
return MaterialApp(
  title: 'Gestão de Tempo',
  // builder: (context, child) {
  //   return AppWrapper(child: child ?? Container());
  // },
  theme: ThemeData(
    // ... resto da configuração
  ),
);
```

### Opção 2: Desabilitar por Componente
```dart
// No AppWrapper, usar o parâmetro enableBackground
AppWrapper(
  enableBackground: false, // Desabilita o fundo
  child: child ?? Container(),
)
```

### Opção 3: Remoção Completa
1. Remover `widgets/app_wrapper.dart`
2. Remover o builder do MaterialApp no `main.dart`
3. Reverter qualquer transparência específica no TimerWidget

## Benefícios da Implementação

✅ **Fácil Reversão**: Mudanças modulares e isoladas
✅ **Não Intrusivo**: Não altera a estrutura existente das telas
✅ **Sutil**: Padrão muito leve que não atrapalha a leitura
✅ **Profissional**: Visual moderno e clean
✅ **Performance**: Usa CustomPainter eficiente

## Personalização

### Alterar Cores do Gradiente
```dart
// No AppWrapper
gradient: LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFF8F9FA), // Cor inicial
    Color(0xFFE8F4FD), // Cor final
  ],
),
```

### Alterar Intensidade do Padrão
```dart
// No AppWrapper, linha do Opacity
Opacity(
  opacity: 0.03, // Aumentar para padrão mais visível
  child: CustomPaint(
    painter: GeometricPatternPainter(),
  ),
),
```

### Alterar Transparência dos Cards
```dart
// Usar TransparentCard em qualquer widget
TransparentCard(
  opacity: 0.85, // Ajustar transparência (0.0 a 1.0)
  child: YourWidget(),
)
```

## Status do Projeto

- ✅ Fundo global implementado
- ✅ Transparência sutil aplicada
- ✅ Timer mantém visual gamificado
- ✅ Facilidade de reversão garantida
- ✅ Performance otimizada
- ✅ Documentação completa
