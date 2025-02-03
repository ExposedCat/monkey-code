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

function makeGameSdkEntry<T, N, M>(
	kind: string,
	Instance: new (id: number) => T,
): GameSdkEntry<N, M> {
	return {
		on: (event, callback) => {
			const listener = (event: CustomEvent<string>) => {
				const data = JSON.parse(event.detail);
				const instance = new Instance(data.id);
				(callback as (i: T) => void)(instance);
			};

			godotBridge.on(`${kind}:${event}`, listener);
			return () => godotBridge.off(`${kind}:${event}`, listener);
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
