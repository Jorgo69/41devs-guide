// src/todos/commands/update-todo.command.ts
// Command pour mettre à jour un Todo

export class UpdateTodoCommand {
  constructor(
    public readonly id: number,
    public readonly title?: string,
    public readonly description?: string,
    public readonly completed?: boolean,
    public readonly priority?: string,
  ) {}
}
