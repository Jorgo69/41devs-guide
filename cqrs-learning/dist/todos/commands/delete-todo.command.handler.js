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
var DeleteTodoCommandHandler_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.DeleteTodoCommandHandler = void 0;
const cqrs_1 = require("@nestjs/cqrs");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const common_1 = require("@nestjs/common");
const delete_todo_command_1 = require("./delete-todo.command");
const todo_entity_1 = require("../models/todo.entity");
let DeleteTodoCommandHandler = DeleteTodoCommandHandler_1 = class DeleteTodoCommandHandler {
    todoRepository;
    logger = new common_1.Logger(DeleteTodoCommandHandler_1.name);
    constructor(todoRepository) {
        this.todoRepository = todoRepository;
    }
    async execute(command) {
        this.logger.log(`🗑️ Suppression du Todo ID: ${command.id}`);
        const todo = await this.todoRepository.findOne({
            where: { id: command.id },
        });
        if (!todo) {
            throw new common_1.NotFoundException(`Todo avec l'ID ${command.id} non trouvé`);
        }
        await this.todoRepository.remove(todo);
        this.logger.log(`✅ Todo ${command.id} supprimé avec succès`);
    }
};
exports.DeleteTodoCommandHandler = DeleteTodoCommandHandler;
exports.DeleteTodoCommandHandler = DeleteTodoCommandHandler = DeleteTodoCommandHandler_1 = __decorate([
    (0, cqrs_1.CommandHandler)(delete_todo_command_1.DeleteTodoCommand),
    __param(0, (0, typeorm_1.InjectRepository)(todo_entity_1.Todo)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], DeleteTodoCommandHandler);
//# sourceMappingURL=delete-todo.command.handler.js.map