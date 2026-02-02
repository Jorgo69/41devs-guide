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
var TodosController_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.TodosController = void 0;
const common_1 = require("@nestjs/common");
const cqrs_1 = require("@nestjs/cqrs");
const create_todo_dto_1 = require("./dto/create-todo.dto");
const update_todo_dto_1 = require("./dto/update-todo.dto");
const create_todo_command_1 = require("./commands/create-todo.command");
const update_todo_command_1 = require("./commands/update-todo.command");
const delete_todo_command_1 = require("./commands/delete-todo.command");
const get_todos_query_1 = require("./queries/get-todos.query");
const get_todo_by_id_query_1 = require("./queries/get-todo-by-id.query");
let TodosController = TodosController_1 = class TodosController {
    commandBus;
    queryBus;
    logger = new common_1.Logger(TodosController_1.name);
    constructor(commandBus, queryBus) {
        this.commandBus = commandBus;
        this.queryBus = queryBus;
    }
    async findAll(completed) {
        this.logger.log('GET /todos - Demande de liste');
        return this.queryBus.execute(new get_todos_query_1.GetTodosQuery(completed));
    }
    async findOne(id) {
        this.logger.log(`GET /todos/${id} - Demande de détail`);
        return this.queryBus.execute(new get_todo_by_id_query_1.GetTodoByIdQuery(id));
    }
    async create(dto) {
        this.logger.log('POST /todos - Création');
        return this.commandBus.execute(new create_todo_command_1.CreateTodoCommand(dto.title, dto.description, dto.priority));
    }
    async update(id, dto) {
        this.logger.log(`PATCH /todos/${id} - Mise à jour`);
        return this.commandBus.execute(new update_todo_command_1.UpdateTodoCommand(id, dto.title, dto.description, dto.completed, dto.priority));
    }
    async remove(id) {
        this.logger.log(`DELETE /todos/${id} - Suppression`);
        await this.commandBus.execute(new delete_todo_command_1.DeleteTodoCommand(id));
        return { message: `Todo ${id} supprimé avec succès` };
    }
};
exports.TodosController = TodosController;
__decorate([
    (0, common_1.Get)(),
    __param(0, (0, common_1.Query)('completed', new common_1.ParseBoolPipe({ optional: true }))),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Boolean]),
    __metadata("design:returntype", Promise)
], TodosController.prototype, "findAll", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], TodosController.prototype, "findOne", null);
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_todo_dto_1.CreateTodoDto]),
    __metadata("design:returntype", Promise)
], TodosController.prototype, "create", null);
__decorate([
    (0, common_1.Patch)(':id'),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number, update_todo_dto_1.UpdateTodoDto]),
    __metadata("design:returntype", Promise)
], TodosController.prototype, "update", null);
__decorate([
    (0, common_1.Delete)(':id'),
    __param(0, (0, common_1.Param)('id', common_1.ParseIntPipe)),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Number]),
    __metadata("design:returntype", Promise)
], TodosController.prototype, "remove", null);
exports.TodosController = TodosController = TodosController_1 = __decorate([
    (0, common_1.Controller)('todos'),
    __metadata("design:paramtypes", [cqrs_1.CommandBus,
        cqrs_1.QueryBus])
], TodosController);
//# sourceMappingURL=todos.controller.js.map