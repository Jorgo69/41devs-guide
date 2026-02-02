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
var TagsController_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.TagsController = void 0;
const common_1 = require("@nestjs/common");
const cqrs_1 = require("@nestjs/cqrs");
const common_2 = require("@nestjs/common");
const create_tag_command_1 = require("./commands/create-tag.command");
const create_tag_dto_1 = require("./dto/create-tag.dto");
let TagsController = TagsController_1 = class TagsController {
    commandBus;
    queryBus;
    logger = new common_2.Logger(TagsController_1.name);
    constructor(commandBus, queryBus) {
        this.commandBus = commandBus;
        this.queryBus = queryBus;
    }
    async create(dto) {
        this.logger.log(`POST / tag - Creation du tag ${dto.name}`);
        return this.commandBus.execute(new create_tag_command_1.CreateTagCommand(dto.name, dto.color));
    }
};
exports.TagsController = TagsController;
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_tag_dto_1.CreateTagDto]),
    __metadata("design:returntype", Promise)
], TagsController.prototype, "create", null);
exports.TagsController = TagsController = TagsController_1 = __decorate([
    (0, common_1.Controller)('tags'),
    __metadata("design:paramtypes", [cqrs_1.CommandBus,
        cqrs_1.QueryBus])
], TagsController);
//# sourceMappingURL=tags.controller.js.map