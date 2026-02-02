// src/categories/queries/get-category-by-id.query.ts

/**
 * Query pour recuperer un Category par son ID
 */
export class GetCategoryByIdQuery {
  constructor(public readonly id: number) {}
}
