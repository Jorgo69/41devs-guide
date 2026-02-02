export declare class UpdateTodoCommand {
    readonly id: number;
    readonly title?: string | undefined;
    readonly description?: string | undefined;
    readonly completed?: boolean | undefined;
    readonly priority?: string | undefined;
    constructor(id: number, title?: string | undefined, description?: string | undefined, completed?: boolean | undefined, priority?: string | undefined);
}
