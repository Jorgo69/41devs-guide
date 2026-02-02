// src/todos/commands/delete-todo.command.ts
// Command pour supprimer un Todo

export class DeleteTodoCommand {
  constructor(public readonly id: number) {}
}
