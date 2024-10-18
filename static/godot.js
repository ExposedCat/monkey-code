window.addEventListener('DOMContentLoaded', () => {
  const engine = new Engine(GODOT_CONFIG);

  const canvas = document.querySelector('#canvas');

  engine.startGame({
    canvas,
    onProgress: (current, total) => {
      if (current === total) {
        window.dispatchEvent(new CustomEvent('game-loaded'))
      }
    }
  });
});