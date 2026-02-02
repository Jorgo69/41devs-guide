export declare class CreateTodoCommand {
    readonly title: string;
    readonly description?: string | undefined;
    readonly priority?: string | undefined;
    constructor(title: string, description?: string | undefined, priority?: string | undefined);
}
