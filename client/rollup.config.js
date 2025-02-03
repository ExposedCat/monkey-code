import commonjs from "@rollup/plugin-commonjs";
import resolve from "@rollup/plugin-node-resolve";
import terser from "@rollup/plugin-terser";
import typescript from "@rollup/plugin-typescript";

export default {
	input: "./src/index.ts",
	output: {
		file: "dist/bundle.js",
		format: "cjs",
	},
	plugins: [typescript(), resolve(), commonjs(), terser()],
};
