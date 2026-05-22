# NES 8-Bit UI Research

## Design Language

- Resolution-led composition: surfaces should feel snapped to a coarse grid, with hard edges and no organic blob geometry.
- Palette discipline: use a compact, high-contrast set of console-like colors. Blue, black, white, red, yellow, green, and cyan carry most semantic roles.
- Typography: prefer monospaced or bitmap-style lettering. Press Start 2P is used in Flutter through `google_fonts` as the packaged fallback.
- Borders: controls need thick, readable outlines and dark drop shadows with zero blur. Shape identity comes from rectangles, not rounded pills.
- Icons: use blocky symbols and first-letter glyphs where the original Animal Island SVG assets would make the style read too modern.

## Motion And Interaction

- Timing should feel stepped and immediate: 90-150 ms transitions, linear curves, no springy easing.
- Hover states should change color or offset by whole-pixel values instead of soft scale/rotation.
- Loading can use block stripes or blinking ASCII-like markers instead of smooth organic spinners where possible.
- Focus/active states should be very explicit: yellow focus, blue active, red error.

## Framework Check

- `nes_ui` on pub.dev is the strongest Flutter reference for NES-style widgets, with pixel buttons, containers, icons, dialogs, and forms.
- `pixelify_flutter` exists as a pixel-art UI/effect reference, but it is newer and less suitable as a foundation for a business component library.
- This package keeps its own API and implementation rather than depending on either package, so existing `Animal*` component APIs remain stable and theme switching stays centralized.

## Implementation Mapping

- `AnimalIslandGameStyle.nes8Bit` selects NES palettes, square radii, thick borders, bitmap typography, and stepped motion.
- Existing components read style tokens from `context.animalIslandTheme`, so the same component calls support Animal Island and NES styles.
- New entry files are provided for future expansion:
  - `lib/animal_game_ui_flutter.dart`
  - `lib/nes_ui_flutter.dart`
  - `lib/src/components/nes_components.dart`
