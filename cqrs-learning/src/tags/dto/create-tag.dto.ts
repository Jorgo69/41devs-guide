import { IsNotEmpty, IsOptional, IsString, Matches, MaxLength } from "class-validator";

export class CreateTagDto {
    @IsString()
    @MaxLength(50)
    @IsNotEmpty()
    name: string;

    @IsString()
    @Matches(/^#[0-9a-fA-F]{6}$/)
    @IsOptional()
    color?: string;
}