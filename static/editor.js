let editor = null

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
    monaco.languages.typescript.typescriptDefaults.setCompilerOptions({
      target: monaco.languages.typescript.ScriptTarget.ESNext,
      allowNonTsExtensions: true,
      strict: true,
      noImplicityAny: true,
      moduleResolution: monaco.languages.typescript.ModuleResolutionKind.NodeJs,
      noSemanticValidation: false,
      noSyntaxValidation: false,
    });

    const gameSdkUri = 'ts:filename/game-sdk.d.ts';
    const gameSdkTypes = /*ts*/`
      declare type GameEvent = 'slime-spawned';

      declare const gameSDK: {
        on: (event: GameEvent, cb: () => void) => void;
      };
    `

    monaco.languages.typescript.javascriptDefaults.addExtraLib(gameSdkTypes, gameSdkUri);
    monaco.editor.createModel(gameSdkTypes, "typescript", monaco.Uri.parse(gameSdkUri));

    const editorElement = document.querySelector('#editor')
    editor = monaco.editor.create(editorElement, {
      value: '// `gameSDK` object is globally available\n',
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
  save.addEventListener('click', () => setEditorVisible(false))
})