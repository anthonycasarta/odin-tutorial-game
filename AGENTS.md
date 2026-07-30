# Repository Guide

## Learning Approach

- This project is used to learn Odin and game development.
- Unless explicitly requested, do not provide code examples or ready-to-paste implementations.
- For questions, default to explaining the cause, relevant concepts, and ordered implementation steps.
- When reviewing code, identify the specific problem and explain why each suggested step fixes it.
- If the user explicitly asks for a file or code change, make the requested change and explain the result concisely.

## Commands

- Run commands from the repository root because runtime level paths are relative.
- Run the game with `odin run src`.
- Use `odin check src` for compile-only verification.
- Build with `odin build src -out:build/odin_tutorial_game`; `build/` is ignored.
- Raylib is imported through Odin's bundled `vendor:raylib`; there is no dependency installation step.
- There are no automated tests, CI workflows, or formatter configuration.

## Architecture

- All files under `src/` belong to the single `odin_tutorial_game` package.
- `main.odin` owns Raylib window lifetime, the frame loop, and per-frame temporary allocator cleanup.
- `game.odin` coordinates the player, active level, camera, and level editor.
- `player.odin` owns player state, movement, collision response, and drawing.
- `level.odin` owns platform storage, rendering, JSON persistence, and cleanup.
- `level_editor.odin` handles editor input and platform placement or removal.
- `game_camera.odin` wraps Raylib's `Camera2D` and updates it to follow the player.

## Level Data

- Level files live under `assets/levels/`.
- Runtime paths such as `assets/levels/level.json` only resolve correctly when running from the repository root.
- Press `F2` to toggle the level editor. Left-click adds a platform and right-click removes one.
- Normal shutdown saves the active level. Closing through forced termination may skip deferred saving and cleanup.
- Running or manually testing the editor can modify tracked level JSON files; inspect those changes before committing.

## Memory Ownership

- `Level.platforms` is a dynamic array. Use `append(&level.platforms, value)` because `append` may update its backing storage.
- Procedures receive `^Level`; JSON serialization must marshal `level^`, not the pointer itself.
- Save a level before calling `level_destroy`, which frees its platform array.
- Temporary allocations are cleared at the end of every frame and must not escape the frame.

## Known Limitation

- `game_level_change` has not been tested and may be buggy or require refactoring.
- `level_paths` currently contains only one level, so level transitions do not have meaningful coverage.
