import { setupEditor } from "./services/editor.js";
import { setupGodot } from "./services/godot.js";
import { setupGameSdk } from "./services/sdk.js";

setupGodot();
setupGameSdk();
setupEditor();
