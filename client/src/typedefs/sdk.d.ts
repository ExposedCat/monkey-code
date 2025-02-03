declare type ItemType = "stone";

declare type IStone = {
	id: number;
};

declare type IEnemy = {
	id: number;
	setFollowPlayer(follow: boolean): void;
	attack(target: Stone): void;
	giveMe(type: ItemType, amount: number): void;
};

declare type EnemyEventMap = {
	spawned: (enemy: Enemy) => void;
	clicked: (enemy: Enemy) => void;
};
declare type EnemyEventName = keyof EnemyEventMap;

declare type StoneEventMap = {
	clicked: (stone: Stone) => void;
};
declare type StoneEventName = keyof StoneEventMap;

declare type GameSdkEntry<N, M> = {
	on: <T extends N>(name: T, callback: M[T]) => void;
};

declare type GameSdk = {
	enemy: GameSdkEntry<EnemyEventName, EnemyEventMap>;
	stone: GameSdkEntry<StoneEventName, StoneEventMap>;
};

declare global {
	const gameSdk: GameSdk;
}
