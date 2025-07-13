# Diálogo de Detalhes de Registro de Tempo

## Visão Geral
Implementado um diálogo estilizado para mostrar detalhes dos registros de tempo no histórico, inspirado no design de conclusão de lições de apps educacionais.

## Funcionalidade

### Como Acessar
1. **Navegar para**: Rastreamento de Tempo → Histórico de Tempo
2. **Clicar**: Em qualquer registro de tempo na lista
3. **Resultado**: Abre diálogo modal com detalhes completos

### Design do Diálogo

#### Estilo Visual
- **Background**: Gradiente azul (#1E3A8A → #3B82F6)
- **Formato**: Modal centralizado com bordas arredondadas
- **Cores**: Esquema azul/laranja (#F59E0B) para destaque
- **Ícones**: Estrelas e círculos para gamificação

#### Elementos Principais

1. **Cabeçalho**
   - Título: "Detalhes do Registro"
   - Subtítulo: Descrição do time_entry

2. **Círculo Central**
   - **Porcentagem**: Calculada baseada na duração
   - **Duração**: Tempo total formatado (ex: "2h 30m 15s")
   - **Estrela decorativa**: Elemento visual de recompensa

3. **Seção de Tempo Registrado**
   - **Ícone**: Estrela laranja
   - **Label**: "Tempo Registrado"
   - **Valor**: Duração formatada
   - **Pontos**: Sistema de gamificação (+pontos)

4. **Seção de Período**
   - **Ícone**: Relógio azul
   - **Label**: "Período"
   - **Valor**: Data/hora início - fim (ou "Em andamento")
   - **Pontos**: Pontos adicionais por tempo

5. **Botão de Ação**
   - **Cor**: Laranja (#F59E0B)
   - **Texto**: "Continuar"
   - **Ação**: Fecha o diálogo

### Mapeamento de Dados

#### Campos do TimeEntry → Diálogo
```dart
// Título principal
"Detalhes do Registro" (fixo)

// Subtítulo
entry.description ?? 'Sem descrição'

// Círculo central - Porcentagem
_getDurationPercentage(entry) // baseado na duração

// Círculo central - Duração
entry.formattedDuration // ex: "2h 30m 15s"

// Tempo Registrado
entry.formattedDuration

// Período
"${_formatDateTime(entry.startTime)} - ${_formatDateTime(entry.endTime!)}"
// ou "${_formatDateTime(entry.startTime)} (Em andamento)" se em execução

// Pontos (gamificação)
_getDurationPoints(entry) // baseado nos minutos
_getTimePoints(entry)     // baseado nas horas
```

### Lógica de Cálculo

#### Porcentagem
```dart
String _getDurationPercentage(dynamic entry) {
  final hours = entry.elapsedTime.inHours;
  final minutes = entry.elapsedTime.inMinutes;
  
  if (hours > 0) {
    return '${(hours * 25).clamp(0, 100)}%'; // 25% por hora
  } else if (minutes > 0) {
    return '${(minutes * 2).clamp(0, 100)}%'; // 2% por minuto
  } else {
    return '10%'; // mínimo 10%
  }
}
```

#### Sistema de Pontos
```dart
// Pontos por duração (0.5 pontos por minuto)
String _getDurationPoints(dynamic entry) {
  final minutes = entry.elapsedTime.inMinutes;
  return '${(minutes * 0.5).round()}';
}

// Pontos por tempo registrado (10 pontos por hora + 20 base)
String _getTimePoints(dynamic entry) {
  final hours = entry.elapsedTime.inHours;
  return '${(hours * 10 + 20).round()}';
}
```

## Arquivos Modificados

### `/lib/screens/time_tracking_screen.dart`
- ✅ Adicionado `onTap` nos ListTile do histórico
- ✅ Criado método `_showTimeEntryDetails()`
- ✅ Implementado diálogo personalizado
- ✅ Adicionados métodos de cálculo de pontos/porcentagem

## Características Técnicas

### Responsividade
- **Width**: 85% da largura da tela
- **Height**: Ajuste automático ao conteúdo
- **Padding**: 24px em todas as direções

### Animação
- **Transition**: Fade padrão do Dialog
- **Dismissible**: Toque fora fecha o diálogo
- **Duration**: Animação suave de abertura/fechamento

### Acessibilidade
- **Contraste**: Alto contraste (branco sobre azul escuro)
- **Tamanhos**: Texto legível (14-28px)
- **Touch targets**: Botões com área mínima adequada

## Estados Suportados

### Registro Ativo (Em Andamento)
- **Indicação**: "(Em andamento)" no período
- **Cálculo**: Duração baseada em tempo atual
- **Porcentagem**: Atualização em tempo real

### Registro Finalizado
- **Período completo**: Início - Fim
- **Duração fixa**: Tempo total registrado
- **Dados estáticos**: Valores finais

## Melhorias Futuras

### Funcionalidades
- [ ] **Nome da Tarefa**: Buscar e exibir nome da task associada
- [ ] **Categorias**: Mostrar categoria da tarefa
- [ ] **Edição**: Permitir editar descrição/horários
- [ ] **Compartilhamento**: Exportar/compartilhar registro

### Design
- [ ] **Animações**: Transições mais elaboradas
- [ ] **Temas**: Suporte a modo escuro
- [ ] **Personalização**: Cores baseadas na categoria
- [ ] **Gráficos**: Mini gráfico de produtividade

### Gamificação
- [ ] **Conquistas**: Sistema de badges
- [ ] **Streaks**: Sequências de dias produtivos
- [ ] **Leaderboard**: Ranking de tempo registrado
- [ ] **Metas**: Comparação com objetivos

## Status
✅ **Implementado e funcional**
✅ **Design fiel ao mockup fornecido**
✅ **Responsivo e acessível**
✅ **Integrado ao fluxo existente**

## Resultado
O diálogo agora proporciona uma experiência visual rica e gamificada para visualizar detalhes dos registros de tempo, incentivando o uso contínuo da funcionalidade de rastreamento.
