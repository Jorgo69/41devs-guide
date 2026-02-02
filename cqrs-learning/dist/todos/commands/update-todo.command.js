"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UpdateTodoCommand = void 0;
class UpdateTodoCommand {
    id;
    title;
    description;
    completed;
    priority;
    constructor(id, title, description, completed, priority) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.completed = completed;
        this.priority = priority;
    }
}
exports.UpdateTodoCommand = UpdateTodoCommand;
//# sourceMappingURL=update-todo.command.js.map