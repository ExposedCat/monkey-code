export type GodotBridge = {
	// biome-ignore lint/suspicious/noExplicitAny: Any type
	dispatch: (event: string, args: any[]) => void;
	on: (event: string, listener: (args: CustomEvent<string>) => void) => void;
	off: (event: string, listener: (args: CustomEvent<string>) => void) => void;
};

declare global {
	const godotBridge: GodotBridge;
}
