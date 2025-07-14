# Funcionalidade de Edição de Tarefas com Rastreamento

## Resumo das Implementações

### 1. Modelo de Dados Atualizado

**Arquivo:** `lib/models/task.dart`

- **Novos campos adicionados ao modelo Task:**
  - `lastEditedBy`: ID do usuário que editou por último
  - `lastEditedAt`: Data/hora da última edição  
  - `isEdited`: Flag booleana indicando se a tarefa foi editada

- **Nova classe UpdateTaskWithEditTrackingRequest:**
  - Estende UpdateTaskRequest incluindo campos de rastreamento
  - Usado especificamente para edições que precisam ser rastreadas

### 2. Serviços de API

**Arquivo:** `lib/services/task_service.dart`

- **Novo método updateTaskWithEditTracking:**
  - Envia dados de edição junto com a atualização da tarefa
  - Inclui informações de quem editou e quando

### 3. Provider de Tarefas

**Arquivo:** `lib/providers/task_provider.dart`

- **Novo método editTask:**
  - Recebe o ID do usuário atual como parâmetro
  - Automaticamente define `isEdited = true`
  - Define `lastEditedAt` como data/hora atual
  - Define `lastEditedBy` como o usuário atual

### 4. Tela de Edição

**Arquivo:** `lib/screens/edit_task_screen.dart`

- **Funcionalidades:**
  - Exibe informações de última edição (se a tarefa foi editada)
  - Usa o novo método `editTask` do provider
  - Inclui ID do usuário atual automaticamente

### 5. Indicadores Visuais

**Arquivo:** `lib/widgets/task_summary_card.dart`

- **Indicador de "EDITADO":**
  - Badge laranja exibido quando `task.isEdited = true`
  - Posicionado antes do indicador de "ATRASADO"

- **Detalhes de edição no diálogo:**
  - Seção dedicada mostrando que a tarefa foi editada
  - Exibe data/hora da última edição
  - Design visual destacado com cores laranja

- **Navegação para edição:**
  - Botão "Editar" agora navega para EditTaskScreen
  - Recarrega lista após edição bem-sucedida

## Como Usar

### Para Editar uma Tarefa:

1. Na lista de tarefas, toque no menu (⋮) da tarefa desejada
2. Selecione "Editar"
3. Faça as alterações necessárias
4. Toque em "Salvar"

### Identificando Tarefas Editadas:

- **Na lista:** Badge laranja "EDITADO" aparece ao lado da tarefa
- **Nos detalhes:** Seção especial mostra informações de edição
- **Na tela de edição:** Header mostra quando foi editada pela última vez

## Fluxo de Dados

1. **Usuário edita tarefa** → EditTaskScreen
2. **Tela chama** → TaskProvider.editTask()
3. **Provider adiciona metadados** → lastEditedBy, lastEditedAt, isEdited
4. **Provider chama** → TaskService.updateTaskWithEditTracking()
5. **Serviço envia** → Dados para backend
6. **Backend atualiza** → Tarefa com informações de edição
7. **Frontend exibe** → Indicadores visuais de edição

## Próximos Passos

- [ ] Garantir que o backend aceita e persiste os novos campos
- [ ] Implementar histórico completo de edições (opcional)
- [ ] Adicionar informações do nome do usuário (não só ID)
- [ ] Testar em diferentes dispositivos e navegadores

## Campos de Backend Necessários

Certifique-se de que o backend aceita estes campos no endpoint de atualização de tarefas:

```json
{
  "lastEditedBy": "string (user ID)",
  "lastEditedAt": "string (ISO 8601 date)",
  "isEdited": "boolean"
}
```
