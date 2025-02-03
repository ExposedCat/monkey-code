let editor = null

const commonConfig = {
	allowNonTsExtensions: true,
	strict: true,
	noImplicityAny: true,
	noSemanticValidation: false,
	noSyntaxValidation: false,
}

const tsConfig = {
	...commonConfig,
	target: "ESNext",
	moduleResolution: "NodeJS",
}

window.addEventListener('game-loaded', () => {
	window.MonacoEnvironment = {
		getWorkerUrl: (_moduleId, _label) => {
			return `data:text/javascript;charset=utf-8,${encodeURIComponent(`
        self.MonacoEnvironment = {
          baseUrl: 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.1/min/'
        };
        importScripts('https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.1/min/vs/base/worker/workerMain.js');
      `)}`;
		}
	};

	require.config({ paths: { vs: 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.34.1/min/vs' } });

	require(['vs/editor/editor.main'], () => {

		const monakoConfig = {
			...commonConfig,
			target: monaco.languages.typescript.ScriptTarget.ESNext,
			moduleResolution: monaco.languages.typescript.ModuleResolutionKind.NodeJs,
		}

		monaco.languages.typescript.typescriptDefaults.setCompilerOptions(monakoConfig);

		const gameSdkUri = 'ts:filename/game-sdk.d.ts';

		monaco.languages.typescript.javascriptDefaults.addExtraLib(gameSdkTypes, gameSdkUri);
		monaco.editor.createModel(gameSdkTypes, "typescript", monaco.Uri.parse(gameSdkUri));

		const editorElement = document.querySelector('#editor')
		editor = monaco.editor.create(editorElement, {
			value: '// Use global `gameSDK` to interact with the game\n\n\n',
			language: 'typescript',
			theme: 'vs-dark',
			minimap: { enabled: false },
			padding: { top: 10 },
			quickSuggestions: {
				other: true,
				comments: false,
				strings: true
			},
			suggestOnTriggerCharacters: true,
			suggest: {
				showWords: true,
				showSnippets: true,
				showClasses: true,
				showFunctions: true,
				showKeywords: true
			}
		});
	});
});

function setEditorVisible(visible) {
	const canvas = document.querySelector('#canvas')
	const envelope = document.querySelector('#envelope')
	envelope.style.display = visible ? 'flex' : 'none';
	if (visible) {
		editor?.layout();
	} else {
		canvas.focus();
	}
}

window.addEventListener('open-editor', () => setEditorVisible(true))
window.addEventListener('close-editor', () => setEditorVisible(false))

window.addEventListener('DOMContentLoaded', () => {
	const save = document.querySelector('#save')
	save.addEventListener('click', () => {
		const code = editor.getValue();
		const jsCode = window.ts.transpile(code, tsConfig);

		setEditorVisible(false);
		eval(jsCode)
	})
})
