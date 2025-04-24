declare type ItemType = "stone";

declare type IStone = {
	id: number;
};

declare type IMonkey = {
	id: number;
	setFollowPlayer(follow: boolean): void;
	attack(target: IStone): void;
	giveMe(type: ItemType, amount: number): void;
};

declare type MonkeyEventMap = {
	spawned: (monkey: IMonkey) => void;
	clicked: (monkey: IMonkey) => void;
};

declare type StoneEventMap = {
	clicked: (stone: IStone) => void;
};

declare type GameSdkEntry<M> = {
	on: <T extends keyof M>(name: T, callback: M[T]) => void;
};

declare type GameSdk = {
	monkey: GameSdkEntry<MonkeyEventMap>;
	stone: GameSdkEntry<StoneEventMap>;
};

declare const gameSdk: GameSdk;
