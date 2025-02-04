declare type ItemType = "stone";

declare type IStone = {
	id: number;
};

declare type IEnemy = {
	id: number;
	setFollowPlayer(follow: boolean): void;
	attack(target: IStone): void;
	giveMe(type: ItemType, amount: number): void;
};

declare type EnemyEventMap = {
	spawned: (enemy: IEnemy) => void;
	clicked: (enemy: IEnemy) => void;
};

declare type StoneEventMap = {
	clicked: (stone: IStone) => void;
};

declare type GameSdkEntry<M> = {
	on: <T extends keyof M>(name: T, callback: M[T]) => void;
};

declare type GameSdk = {
	enemy: GameSdkEntry<EnemyEventMap>;
	stone: GameSdkEntry<StoneEventMap>;
};

declare const gameSdk: GameSdk;
