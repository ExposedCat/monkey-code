declare class Engine {
	constructor(config: unknown);

	startGame(args: {
		canvas: HTMLCanvasElement;
		onProgress: (current: number, total: number) => void;
	}): void;
}

declare const GODOT_CONFIG: unknown;

export function setupGodot() {
	window.addEventListener("DOMContentLoaded", () => {
		const engine = new Engine(GODOT_CONFIG);

		const canvas = document.querySelector<HTMLCanvasElement>("#canvas");

		if (!canvas) {
			alert("Error: cannot load game source");
		} else {
			engine.startGame({
				canvas,
				onProgress: (current, total) => {
					if (current === total) {
						window.dispatchEvent(new CustomEvent("game-loaded"));
					}
				},
			});
		}
	});
}
