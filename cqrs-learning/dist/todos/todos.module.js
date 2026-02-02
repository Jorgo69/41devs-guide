"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TodosModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const cqrs_1 = require("@nestjs/cqrs");
const todo_entity_1 = require("./models/todo.entity");
const todos_controller_1 = require("./todos.controller");
const create_todo_command_handler_1 = require("./commands/create-todo.command.handler");
const update_todo_command_handler_1 = require("./commands/update-todo.command.handler");
const delete_todo_command_handler_1 = require("./commands/delete-todo.command.handler");
const get_todos_query_handler_1 = require("./queries/get-todos.query.handler");
const get_todo_by_id_query_handler_1 = require("./queries/get-todo-by-id.query.handler");
const CommandHandlers = [
    create_todo_command_handler_1.CreateTodoCommandHandler,
    update_todo_command_handler_1.UpdateTodoCommandHandler,
    delete_todo_command_handler_1.DeleteTodoCommandHandler,
];
const QueryHandlers = [
    get_todos_query_handler_1.GetTodosQueryHandler,
    get_todo_by_id_query_handler_1.GetTodoByIdQueryHandler,
];
let TodosModule = class TodosModule {
};
exports.TodosModule = TodosModule;
exports.TodosModule = TodosModule = __decorate([
    (0, common_1.Module)({
        imports: [
            typeorm_1.TypeOrmModule.forFeature([todo_entity_1.Todo]),
            cqrs_1.CqrsModule,
        ],
        controllers: [todos_controller_1.TodosController],
        providers: [
            ...CommandHandlers,
            ...QueryHandlers,
        ],
    })
], TodosModule);
//# sourceMappingURL=todos.module.js.map