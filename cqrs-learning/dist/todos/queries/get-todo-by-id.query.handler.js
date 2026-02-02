"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
var GetTodoByIdQueryHandler_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetTodoByIdQueryHandler = void 0;
const cqrs_1 = require("@nestjs/cqrs");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const common_1 = require("@nestjs/common");
const get_todo_by_id_query_1 = require("./get-todo-by-id.query");
const todo_entity_1 = require("../models/todo.entity");
let GetTodoByIdQueryHandler = GetTodoByIdQueryHandler_1 = class GetTodoByIdQueryHandler {
    todoRepository;
    logger = new common_1.Logger(GetTodoByIdQueryHandler_1.name);
    constructor(todoRepository) {
        this.todoRepository = todoRepository;
    }
    async execute(query) {
        this.logger.log(`🔍 Recherche du Todo ID: ${query.id}`);
        const todo = await this.todoRepository.findOne({
            where: { id: query.id },
        });
        if (!todo) {
            throw new common_1.NotFoundException(`Todo avec l'ID ${query.id} non trouvé`);
        }
        this.logger.log(`✅ Todo ${query.id} trouvé`);
        return todo;
    }
};
exports.GetTodoByIdQueryHandler = GetTodoByIdQueryHandler;
exports.GetTodoByIdQueryHandler = GetTodoByIdQueryHandler = GetTodoByIdQueryHandler_1 = __decorate([
    (0, cqrs_1.QueryHandler)(get_todo_by_id_query_1.GetTodoByIdQuery),
    __param(0, (0, typeorm_1.InjectRepository)(todo_entity_1.Todo)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], GetTodoByIdQueryHandler);
//# sourceMappingURL=get-todo-by-id.query.handler.js.map