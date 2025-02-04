class Stone implements IStone {
	constructor(public id: number) {}
}

class Enemy implements IEnemy {
	constructor(public id: number) {}

	setFollowPlayer(follow: boolean) {
		godotBridge.dispatch("enemy:follow", [this.id, follow]);
	}

	attack(target: Stone) {
		godotBridge.dispatch("enemy:attack", [this.id, target.id]);
	}

	giveMe(type: ItemType, amount: number) {
		godotBridge.dispatch("enemy:give", [this.id, type, amount]);
	}
}

function makeGameSdkEntry<T, M>(
	kind: string,
	Instance: new (id: number) => T,
): GameSdkEntry<M> {
	return {
		on: (event, callback) => {
			const listener = (event: CustomEvent<string>) => {
				const data = JSON.parse(event.detail);
				const instance = new Instance(data.id);
				(callback as (i: T) => void)(instance);
			};

			godotBridge.on(`${kind}:${event as string}`, listener);
			return () => godotBridge.off(`${kind}:${event as string}`, listener);
		},
	};
}

export function setupGameSdk() {
	// @ts-ignore
	window.gameSdk = {
		enemy: makeGameSdkEntry("enemy", Enemy),
		stone: makeGameSdkEntry("stone", Stone),
	} as GameSdk;
}
