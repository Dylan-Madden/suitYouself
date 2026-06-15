# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Building and Running

This is a native iOS app built with Xcode. There is no CLI build system — open `clothingMatcher/clothingMatcher.xcodeproj` in Xcode, select a simulator or device, and hit Run (⌘R).

**Dev mode:** In `OpenAIWork.swift`, set `let devMode = true` to skip all OpenAI API calls and return a mock response. Always use dev mode during UI testing to avoid unnecessary API costs.

## Architecture

The app is a SwiftUI navigation stack rooted at `ContentView → StyleSelectionView → [SuitView | CasualView | LoungeView]`.

**Suit builder (`SuitView`):** The core feature works by stacking multiple PNG images in a `ZStack`, each rendered as a template (`.renderingMode(.template)`) so they can be tinted with SwiftUI's `.foregroundColor()`. A separate layer of invisible `Rectangle` tap zones sits on top of the images at hardcoded coordinates — tapping one sets `selectedType`, which triggers a `.sheet` presenting `ColorSelectionView`. The user's color choices are stored in `[ClothingType: Color]` and applied back to the images.

**AI feedback flow:** `SuitView` converts the `[ClothingType: Color]` dictionary to a hex-based text description via `generateOutfitDescription()`, then passes it to `getOutfitFeedback()` in `OpenAIWork.swift`. That function calls GPT-3.5-turbo and returns a formatted two-section string ("What Works" / "What Could Improve"), which is displayed in an overlay `ZStack` sheet within `SuitView`.

**Color system:** App-wide gradient colors (`gradientStart`, `gradientEnd`, `suitViewStart`, `suitViewEnd`) are defined as named color sets in `Assets.xcassets` and referenced as `Color.gradientStart` etc. in SwiftUI. Button colors are set inline in each view.

**Adding a new clothing type:** Add a case to `ClothingType` in `ClothingItem.swift`, add the corresponding layered PNG assets to `Assets.xcassets`, add `Image` layers in `SuitView`, and add a `tapZone(for:x:y:width:height:)` call with calibrated coordinates.

`CasualView` and `LoungeView` are currently placeholder stubs.

## Security Note

The OpenAI API key is stored directly in `clothingMatcher/clothingMatcher/Info.plist`. This means it is embedded in the app bundle and accessible to anyone who inspects the binary. Consider moving it to a backend proxy before distributing the app publicly.
