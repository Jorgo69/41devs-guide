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
var CreateTagCommandHandler_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.CreateTagCommandHandler = void 0;
const cqrs_1 = require("@nestjs/cqrs");
const create_tag_command_1 = require("./create-tag.command");
const typeorm_1 = require("@nestjs/typeorm");
const tag_entity_1 = require("../models/tag.entity");
const typeorm_2 = require("typeorm");
const common_1 = require("@nestjs/common");
let CreateTagCommandHandler = CreateTagCommandHandler_1 = class CreateTagCommandHandler {
    tagRepository;
    logger = new common_1.Logger(CreateTagCommandHandler_1.name);
    constructor(tagRepository) {
        this.tagRepository = tagRepository;
    }
    async execute(command) {
        this.logger.log(`Creation d'un nouveau : ${command.name}`);
        const tag = this.tagRepository.create({
            name: command.name,
            color: command.color,
        });
        const saveTag = await this.tagRepository.save(tag);
        this.logger.log(`Tag ${saveTag.name} a été créé avec succès`);
        return saveTag;
    }
};
exports.CreateTagCommandHandler = CreateTagCommandHandler;
exports.CreateTagCommandHandler = CreateTagCommandHandler = CreateTagCommandHandler_1 = __decorate([
    (0, cqrs_1.CommandHandler)(create_tag_command_1.CreateTagCommand),
    __param(0, (0, typeorm_1.InjectRepository)(tag_entity_1.Tag)),
    __metadata("design:paramtypes", [typeorm_2.Repository])
], CreateTagCommandHandler);
//# sourceMappingURL=create-tag.command.handler.js.map