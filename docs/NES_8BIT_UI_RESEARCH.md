# NES 8-Bit UI Research

## Design Language

- Resolution-led composition: surfaces should feel snapped to a coarse grid, with hard edges and no organic blob geometry.
- Border-first components: NES.css uses SVG border-image patterns rather than soft outlines. In Flutter, NES controls should use a pixel-frame painter with stepped corners, chunky 3-4px strokes, inner highlight/lowlight edges, and hard right-bottom shadows.
- Palette discipline: use a compact, high-contrast set of console-like colors. Mario red, sky blue, brick brown, pipe green, black, and white carry most semantic roles; coin/question-block yellow should stay as a small accent, not a dominant theme color.
- Typography: keep the playful density of console-era UI without forcing bitmap lettering. Rounded, thick, highly readable game typography is preferred so Chinese and mixed-language labels stay comfortable.
- Borders: controls need thick, readable outlines and dark drop shadows with zero blur. Shape identity comes from rectangles, not rounded pills.
- Icons: use blocky symbols and first-letter glyphs where the original Animal Island SVG assets would make the style read too modern.
- Texture: cards, buttons, badges, tabs, and inputs can use sparse checker/dot pixels or small block markers. Avoid gradients, blur, soft rounded pills, or Material-style check icons.

## Motion And Interaction

- Timing should feel stepped and immediate: 90-150 ms transitions, linear curves, no springy easing.
- Hover states should change color, inner edge depth, or whole-pixel offsets instead of soft scale/rotation.
- Pressed states should invert the bevel direction like NES.css button `::after` active shadows.
- Loading can use block stripes or blinking ASCII-like markers instead of smooth organic spinners where possible.
- Focus/active states should be very explicit: yellow focus, blue active, red error.

## Framework Check

- `nes_ui` on pub.dev is the strongest Flutter reference for NES-style widgets, with pixel buttons, containers, icons, dialogs, and forms.
- `pixelify_flutter` exists as a pixel-art UI/effect reference, but it is newer and less suitable as a foundation for a business component library.
- This package keeps its own API and implementation rather than depending on either package, so existing `Animal*` component APIs remain stable and theme switching stays centralized.

## Implementation Mapping

- `AnimalIslandGameStyle.nes8Bit` selects NES/platform-game palettes, square radii, thick pixel frames, rounded game typography, and stepped motion.
- Shared Flutter primitive: `NesPixelFrame` / `NesPixelFramePainter` in `lib/src/components/nes_pixel_frame.dart` should be preferred over ad hoc `BoxDecoration` borders for NES-specific component chrome.
- Existing components read style tokens from `context.animalIslandTheme`, so the same component calls support Animal Island and NES styles.
- New entry files are provided for future expansion:
  - `lib/animal_game_ui_flutter.dart`
  - `lib/nes_ui_flutter.dart`
  - `lib/src/components/nes_components.dart`
