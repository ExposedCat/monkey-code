import type TS from "typescript";

declare global {
	const ts: typeof TS;
}

const MAIN_FILE = "main.in-mem.ts";
const LIB_FILE = "lib.in-mem.ts";

export const commonTsConfig: TS.CompilerOptions = {
	allowNonTsExtensions: true,
	strict: true,
	noImplicityAny: true,
	noSemanticValidation: false,
	noSyntaxValidation: false,
	lib: ["dom", "es6"],
};

const tsConfig: TS.CompilerOptions = {
	...commonTsConfig,
	target: ts.ScriptTarget.Latest,
	moduleResolution: ts.ModuleResolutionKind.NodeNext,
};

export async function compileTs({
	code,
	lib,
}: { code: string; lib: string }): Promise<{ ok: boolean; data: string }> {
	return new Promise((resolve) => {
		const compilerHost = {
			fileExists: () => true,
			getDefaultLibFileName: () => LIB_FILE,
			getCurrentDirectory: () => "/",
			getCanonicalFileName: (fileName: string) => fileName,
			getNewLine: () => "\n",
			getSourceFile: (fileName: string) => {
				if (fileName === MAIN_FILE) {
					return ts.createSourceFile(
						fileName,
						`${lib}\n\n${code}`,
						ts.ScriptTarget.ES5,
						true,
					);
				}
				return undefined;
			},
			writeFile: (_fileName: string, data: string) =>
				resolve({ ok: true, data }),
			readFile: () => code,
			useCaseSensitiveFileNames: () => true,
		};

		const program = ts.createProgram([MAIN_FILE], tsConfig, compilerHost);

		const semanticDiagnostics = program.getSemanticDiagnostics();
		const syntacticDiagnostics = program.getSyntacticDiagnostics();

		if (semanticDiagnostics.length > 0 || syntacticDiagnostics.length > 0) {
			return resolve({
				ok: false,
				data:
					semanticDiagnostics[0]?.messageText.toString() ??
					syntacticDiagnostics[0]?.messageText.toString() ??
					"Unknown Error",
			});
		}

		program.emit();
	});
}
