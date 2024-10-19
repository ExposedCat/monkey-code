const gameSdkTypes = /*ts*/`
  declare type Enemy = {
    id: number;
    followPlayer(follow: boolean): void;
  }

  declare type EnemyEventMap = {
    spawned: (enemy: Enemy) => void;
  };

  declare type EnemyEventName = keyof EnemyEventMap;

  declare const gameSdk: {
    enemy: {
      on: <N extends EnemyEventName>(name: N, callback: EnemyEventMap[N]) => void
    };
  };
`

class Enemy {
  constructor(id) {
    this.id = id;
  }

  followPlayer(follow) {
    godotBridge.dispatch('enemy:follow', [this.id, follow])
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
  }
}