engine.startGame({
  onProgress: (current, total) => {
    if (current === total) {
      window.dispatchEvent(new CustomEvent('game-loaded'))
    }
  }
});