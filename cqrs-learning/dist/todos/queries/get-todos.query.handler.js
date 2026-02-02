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
var GetTodosQueryHandler_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.GetTodosQueryHandler = void 0;
const cqrs_1 = require("@nestjs/cqrs");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const common_1 = require("@nestjs/common");
const get_todos_query_1 = require("./get-todos.query");
const todo_entity_1 = require("../models/todo.entity");
let GetTodosQueryHandler = GetTodosQueryHandler_1 = class GetTodosQueryHandler {
    todoRepository;
    logger = new common_1.Logger(GetTodosQueryHandler_1.name);
    constructor(todoRepository) {
        this.todoRepository = todoRepository;
    }
    async execute(query) {
        this.logger.log('📋 Récupération de la liste des Todos');
        const queryBuilder = this.todoRepository.createQueryBuilder('todo');
        if (query.completed !== undefined) {
            queryBuilder.where('todo.completed = :completed', {
                completed: query.completed,
            });
        }
        queryBuilder.orderBy('todo.createdAt', 'DESC');
        const todos = await queryBuilder.getMany();
        this.logger.log(`✅ ${todos.length} Todos trouvés`);
        return todos;
    }
};
exports.GetTodosQueryHandler = GetTodosQueryHandler;
exports.GetTodosQueryHandler = GetTodosQueryHandler = GetTodosQueryHandler_1 = __decorate([
    (0, cqrs_1.QueryHandler)(get_todos_query_1.GetTodosQuery),
    __param(0, (0, typeorm_1.InjectRepository)(todo_entity_1.Todo)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], GetTodosQueryHandler);
//# sourceMappingURL=get-todos.query.handler.js.map