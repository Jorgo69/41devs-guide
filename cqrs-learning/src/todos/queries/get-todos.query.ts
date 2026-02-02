// src/todos/queries/get-todos.query.ts
// ═══════════════════════════════════════════════════════════════════════════
// 🎯 QUERY = Intention de lecture (GET)
// Une Query transporte les paramètres de recherche/filtrage
// ═══════════════════════════════════════════════════════════════════════════

export class GetTodosQuery {
  constructor(
    public readonly completed?: boolean, // Filtre optionnel: seulement les complétés ou non
  ) {}
}
