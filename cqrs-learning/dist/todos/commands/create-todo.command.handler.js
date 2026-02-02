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
var CreateTodoCommandHandler_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.CreateTodoCommandHandler = void 0;
const cqrs_1 = require("@nestjs/cqrs");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const common_1 = require("@nestjs/common");
const create_todo_command_1 = require("./create-todo.command");
const todo_entity_1 = require("../models/todo.entity");
let CreateTodoCommandHandler = CreateTodoCommandHandler_1 = class CreateTodoCommandHandler {
    todoRepository;
    logger = new common_1.Logger(CreateTodoCommandHandler_1.name);
    constructor(todoRepository) {
        this.todoRepository = todoRepository;
    }
    async execute(command) {
        this.logger.log(`📝 Création d'un nouveau Todo: "${command.title}"`);
        const todo = this.todoRepository.create({
            title: command.title,
            description: command.description,
            completed: false,
            priority: command.priority || 'low',
        });
        const savedTodo = await this.todoRepository.save(todo);
        this.logger.log(`✅ Todo créé avec succès (ID: ${savedTodo.id})`);
        return savedTodo;
    }
};
exports.CreateTodoCommandHandler = CreateTodoCommandHandler;
exports.CreateTodoCommandHandler = CreateTodoCommandHandler = CreateTodoCommandHandler_1 = __decorate([
    (0, cqrs_1.CommandHandler)(create_todo_command_1.CreateTodoCommand),
    __param(0, (0, typeorm_1.InjectRepository)(todo_entity_1.Todo)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], CreateTodoCommandHandler);
//# sourceMappingURL=create-todo.command.handler.js.map