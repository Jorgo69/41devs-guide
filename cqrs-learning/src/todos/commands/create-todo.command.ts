// src/todos/commands/create-todo.command.ts
// ═══════════════════════════════════════════════════════════════════════════
// 🎯 COMMAND = Intention d'écriture (POST/PUT/DELETE)
// Une Command transporte les données nécessaires pour effectuer une action
// Elle ne contient PAS de logique, juste des données
// ═══════════════════════════════════════════════════════════════════════════

export class CreateTodoCommand {
  constructor(
    public readonly title: string,
    public readonly description?: string,
    public readonly priority?: string,
  ) {}
}
