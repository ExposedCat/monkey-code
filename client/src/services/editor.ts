import { commonTsConfig, compileTs } from "./typescript";

declare global {
	// biome-ignore lint/suspicious/noExplicitAny: Injected via HTML
	const require: any;
	// biome-ignore lint/suspicious/noExplicitAny: Injected via HTML
	const monaco: any;

	const gameSdkTypes: string;

	interface Window {
		MonacoEnvironment: {
			getWorkerUrl: () => string;
		};
	}
}

type Editor = {
	layout: () => void;
	getValue: () => string;
};

let editor: Editor | null = null;

function setEditorVisible(visible: boolean) {
	const canvas = document.querySelector<HTMLCanvasElement>("#canvas");
	const envelope = document.querySelector<HTMLDivElement>("#envelope");
	if (canvas && envelope) {
		envelope.style.display = visible ? "flex" : "none";
		if (visible) {
			editor?.layout();
		} else {
			canvas.focus();
		}
	}
}

export function setupEditor() {
	window.addEventListener("game-loaded", () => {
		window.MonacoEnvironment = {
			getWorkerUrl: () => {
				return `data:text/javascript;charset=utf-8,${encodeURIComponent(`
        self.MonacoEnvironment = {
          baseUrl: 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.1/min/'
        };
        importScripts('https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.1/min/vs/base/worker/workerMain.js');
      `)}`;
			},
		};

		require.config({
			paths: {
				vs: "https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.1/min/vs",
			},
		});

		require(["vs/editor/editor.main"], () => {
			const monakoConfig = {
				...commonTsConfig,
				target: monaco.languages.typescript.ScriptTarget.ESNext,
				moduleResolution:
					monaco.languages.typescript.ModuleResolutionKind.NodeJs,
			};

			monaco.languages.typescript.typescriptDefaults.setCompilerOptions(
				monakoConfig,
			);

			const gameSdkUri = "ts:filename/game-sdk.d.ts";

			monaco.languages.typescript.javascriptDefaults.addExtraLib(
				gameSdkTypes,
				gameSdkUri,
			);
			monaco.editor.createModel(
				gameSdkTypes,
				"typescript",
				monaco.Uri.parse(gameSdkUri),
			);

			const editorElement = document.querySelector("#editor");
			editor = monaco.editor.create(editorElement, {
				value: "// Use global `gameSDK` to interact with the game\n\n\n",
				language: "typescript",
				theme: "vs-dark",
				minimap: { enabled: false },
				padding: { top: 10 },
				quickSuggestions: {
					other: true,
					comments: false,
					strings: true,
				},
				suggestOnTriggerCharacters: true,
				suggest: {
					showWords: true,
					showSnippets: true,
					showClasses: true,
					showFunctions: true,
					showKeywords: true,
				},
			});
		});
	});

	window.addEventListener("open-editor", () => setEditorVisible(true));
	window.addEventListener("close-editor", () => setEditorVisible(false));

	window.addEventListener("DOMContentLoaded", () => {
		const save = document.querySelector<HTMLInputElement>("#save");
		if (save) {
			save.addEventListener("click", async () => {
				const code = editor?.getValue();
				if (!code) {
					alert("Failed to execute: no code provided");
				} else {
					const { ok, data } = await compileTs({
						code,
						lib: gameSdkTypes,
					});

					if (ok) {
						setEditorVisible(false);
						// FIXME: Sandbox this
						// biome-ignore lint/security/noGlobalEval: Need by design
						eval(data);
					} else {
						alert(`Failed to execute: ${data}`);
					}
				}
			});
		}
	});
}
