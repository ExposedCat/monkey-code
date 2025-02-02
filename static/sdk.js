const gameSdkTypes = /*ts*/`
  declare type Stone = {
    id: number;
  }

  declare type Enemy = {
    id: number;
    followPlayer(follow: boolean): void;
    attack(target: Stone): void;
    giveMe(type: 'stone', amount: number): void;
  }

  declare type EnemyEventMap = {
	  spawned: (enemy: Enemy) => void;
	  clicked: (enemy: Enemy) => void;
  };
  declare type EnemyEventName = keyof EnemyEventMap;

  declare type StoneEventMap = {
	  clicked: (stone: Stone) => void;
  };
  declare type StoneEventName = keyof StoneEventMap;

  declare const gameSdk: {
    enemy: {
      on: <N extends EnemyEventName>(name: N, callback: EnemyEventMap[N]) => void
    };
    stone: {
      on: <N extends StoneEventName>(name: N, callback: StoneEventMap[N]) => void
    };
  };
`

class Stone {
	constructor(id) {
		this.id = id;
	}
}

class Enemy {
	constructor(id) {
		this.id = id;
	}

	followPlayer(follow) {
		godotBridge.dispatch('enemy:follow', [this.id, follow])
	}

	attack(target) {
		godotBridge.dispatch('enemy:attack', [this.id, target.id])
	}

	giveMe(type, amount) {
		godotBridge.dispatch('enemy:give', [this.id, type, amount])
	}
}

var gameSdk = {
	enemy: {
		on: (event, cb) => {
			const listener = event => {
				const data = JSON.parse(event.detail);
				const enemy = new Enemy(data.id);
				cb(enemy);
			}

			godotBridge.on(`enemy:${event}`, listener)
			return () => godotBridge.off(`enemy:${event}`, listener)
		},
	},
	stone: {
		on: (event, cb) => {
			const listener = event => {
				const data = JSON.parse(event.detail);
				const stone = new Stone(data.id);
				cb(stone);
			}

			godotBridge.on(`stone:${event}`, listener)
			return () => godotBridge.off(`stone:${event}`, listener)
		},
	}
}
