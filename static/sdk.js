const gameSdkTypes = /*ts*/`
  declare type GameEvent = 'spawned';

  declare const gameSDK: {
    // TODO:
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