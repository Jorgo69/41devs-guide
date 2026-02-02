// src/categories/commands/create-category.command.ts

/**
 * Command pour creer un Category
 * Transporte les donnees necessaires pour l'operation de creation
 */
export class CreateCategoryCommand {
  constructor(
    public readonly name: string,
    public readonly description?: string,
  ) {}
}
