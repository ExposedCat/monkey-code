import type TS from "typescript";

declare global {
	const ts: typeof TS;
}

const MAIN_FILE = "main.in-mem.ts";
const LIB_FILE = "lib.in-mem.d.ts";

export const commonTsConfig = {
	allowNonTsExtensions: true,
	strict: true,
	noImplicityAny: true,
	noSemanticValidation: false,
	noSyntaxValidation: false,
};

const tsConfig = {
	...commonTsConfig,
	target: ts.ScriptTarget.ESNext,
	moduleResolution: ts.ModuleResolutionKind.NodeNext,
};

export async function compileTs({
	code,
	lib,
}: { code: string; lib: string }): Promise<string | null> {
	return new Promise((resolve) => {
		const compilerHost = {
			fileExists: () => true,
			getDefaultLibFileName: () => LIB_FILE,
			getCurrentDirectory: () => "/",
			getCanonicalFileName: (fileName: string) => fileName,
			getNewLine: () => "\n",
			getSourceFile: (fileName: string) => {
				if (fileName === MAIN_FILE) {
					return ts.createSourceFile(fileName, code, ts.ScriptTarget.ES5, true);
				}
				if (fileName === LIB_FILE) {
					return ts.createSourceFile(fileName, lib, ts.ScriptTarget.ES5, true);
				}
				return undefined;
			},
			writeFile: (_fileName: string, data: string) => resolve(data),
			readFile: () => code,
			useCaseSensitiveFileNames: () => true,
		};

		const program = ts.createProgram([MAIN_FILE], tsConfig, compilerHost);

		const semanticDiagnostics = program.getSemanticDiagnostics();
		const syntacticDiagnostics = program.getSyntacticDiagnostics();

		if (semanticDiagnostics.length > 0 || syntacticDiagnostics.length > 0) {
			return resolve(null);
		}

		program.emit();
	});
}
