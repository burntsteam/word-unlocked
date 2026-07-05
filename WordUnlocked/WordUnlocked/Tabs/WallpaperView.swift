import SwiftUI
import Photos

// MARK: - Set as Wallpaper

/// Renders the current verse into a full-resolution wallpaper image with the
/// text anchored to the lower "safe zone" of the Lock Screen, well clear of the
/// system clock. iOS controls where Lock Screen *widgets* sit (which is why a
/// widget can visually collide with the clock); a wallpaper we compose ourselves
/// is the only surface where the app fully controls the verse's position.
struct WallpaperExportView: View {
    let ref: String
    let text: String
    let translation: String
    let theme: WidgetTheme

    @State private var background: WallpaperBackground
    @State private var saveState: SaveState = .idle

    init(ref: String, text: String, translation: String, theme: WidgetTheme) {
        self.ref = ref
        self.text = text
        self.translation = translation
        self.theme = theme
        _background = State(initialValue: WallpaperBackground.presets.first!)
    }

    enum SaveState: Equatable {
        case idle
        case saving
        case saved
        case error(String)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                previewCard
                stylePicker
                saveButton
                statusBanner
                instructions
            }
            .padding()
        }
        .navigationTitle("Set as Wallpaper")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Preview

    // The preview overlays a ghosted clock/date where iOS renders them, so the
    // user can confirm the verse sits safely below — directly demonstrating the
    // fix to the clock/verse overlap. The clock overlay is preview-only and is
    // never part of the exported image.
    private var previewCard: some View {
        VStack(spacing: 10) {
            WallpaperCanvas(
                ref: ref,
                text: text,
                translation: translation,
                background: background,
                fontDesign: theme.fontDesign
            )
            .aspectRatio(WallpaperCanvas.aspect, contentMode: .fit)
            .frame(maxWidth: 280)
            .overlay { clockGuide }
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(.white.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.25), radius: 14, x: 0, y: 8)

            Text("Live preview — the clock is shown for reference only")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var clockGuide: some View {
        GeometryReader { geo in
            let h = geo.size.height
            VStack(spacing: h * 0.01) {
                Text(Date.now, format: .dateTime.weekday(.abbreviated).month(.abbreviated).day())
                    .font(.system(size: h * 0.022, weight: .semibold))
                Text(Date.now, format: .dateTime.hour().minute())
                    .font(.system(size: h * 0.12, weight: .light))
                    .monospacedDigit()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.top, h * 0.06)
            .foregroundStyle(.white.opacity(0.35))
        }
        .allowsHitTesting(false)
    }

    // MARK: Style picker

    private var stylePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Background")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(WallpaperBackground.presets) { preset in
                        Button {
                            background = preset
                        } label: {
                            VStack(spacing: 6) {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(preset.gradient)
                                    .frame(width: 54, height: 78)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .stroke(background == preset ? Color.accentColor : .clear, lineWidth: 3)
                                    )
                                Text(preset.name)
                                    .font(.caption2)
                                    .foregroundStyle(background == preset ? .primary : .secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 2)
            }
        }
    }

    // MARK: Actions

    private var saveButton: some View {
        Button {
            saveToPhotos()
        } label: {
            HStack {
                if saveState == .saving {
                    ProgressView().tint(.white)
                } else {
                    Image(systemName: "square.and.arrow.down")
                }
                Text(saveState == .saved ? "Saved to Photos" : "Save to Photos")
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(saveState == .saving)
    }

    @ViewBuilder
    private var statusBanner: some View {
        switch saveState {
        case .saved:
            Label("Saved. Set it below.", systemImage: "checkmark.circle.fill")
                .font(.footnote.weight(.medium))
                .foregroundStyle(.green)
        case .error(let message):
            Label(message, systemImage: "exclamationmark.triangle.fill")
                .font(.footnote)
                .foregroundStyle(.orange)
                .multilineTextAlignment(.leading)
        case .idle, .saving:
            EmptyView()
        }
    }

    private var instructions: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How to use it")
                .font(.subheadline.weight(.semibold))
            Text("iOS doesn't let apps set the wallpaper directly. After saving:")
                .font(.footnote)
                .foregroundStyle(.secondary)
            Group {
                stepRow(1, "Open Settings → Wallpaper → Add New Wallpaper.")
                stepRow(2, "Choose Photos and pick the image you just saved.")
                stepRow(3, "Position it, tap Add, then Set as Wallpaper Pair.")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func stepRow(_ number: Int, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("\(number).")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tint)
            Text(text)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: Rendering & saving

    @MainActor
    private func renderWallpaper() -> UIImage? {
        // Render at a large point size (iPhone Pro Max logical size) at 3x so the
        // result is crisp on every device; iOS scales/crops wallpapers to fit.
        let pointSize = CGSize(width: 430, height: 430 / WallpaperCanvas.aspect)
        let canvas = WallpaperCanvas(
            ref: ref,
            text: text,
            translation: translation,
            background: background,
            fontDesign: theme.fontDesign
        )
        .frame(width: pointSize.width, height: pointSize.height)

        let renderer = ImageRenderer(content: canvas)
        renderer.scale = 3
        renderer.isOpaque = true
        return renderer.uiImage
    }

    @MainActor
    private func saveToPhotos() {
        guard let image = renderWallpaper() else {
            saveState = .error("Couldn't render the wallpaper. Please try again.")
            return
        }
        saveState = .saving
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            switch status {
            case .authorized, .limited:
                PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                } completionHandler: { success, error in
                    DispatchQueue.main.async {
                        saveState = success
                            ? .saved
                            : .error(error?.localizedDescription ?? "Couldn't save to Photos.")
                    }
                }
            default:
                DispatchQueue.main.async {
                    saveState = .error("Photos access is off. Enable it in Settings to save wallpapers.")
                }
            }
        }
    }
}

// MARK: - Wallpaper canvas

/// The composited wallpaper content. Fully resolution-independent: every size is
/// derived from the rendered height, so the small on-screen preview and the
/// large exported image look identical. The verse block is pinned to the lower
/// portion of the frame, keeping it clear of the Lock Screen clock (top third).
struct WallpaperCanvas: View {
    /// Portrait aspect (width / height) matching modern iPhones (~9:19.5).
    static let aspect: CGFloat = 9.0 / 19.5

    /// Longest verse rendered before word-aware excerpting. Generous vs. the
    /// widget (132) — a full screen has far more room — but still bounded so the
    /// verse block can never grow tall enough to reach the clock zone.
    static let maxChars = 240

    let ref: String
    let text: String
    let translation: String
    let background: WallpaperBackground
    let fontDesign: Font.Design

    /// Verse text clamped for the wallpaper. Long verses are excerpted on word
    /// boundaries (matching how the widget path handles overflow), so a very long
    /// verse can't force the block upward into the clock.
    private var fittedText: String {
        LongVerseService.excerpt(from: text, maxChars: Self.maxChars)
    }

    var body: some View {
        GeometryReader { geo in
            let h = geo.size.height
            let w = geo.size.width

            ZStack(alignment: .bottom) {
                background.gradient

                // Bottom scrim guarantees legible white text over any gradient.
                LinearGradient(
                    colors: [.clear, .black.opacity(0.5)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                // The verse occupies a band anchored to the lower screen, capped
                // at 0.42h tall with a 0.17h bottom inset. Its top edge therefore
                // can never rise above ~0.41h — comfortably below the Lock Screen
                // clock (top third) — so the text cannot grow up into the clock no
                // matter how long the verse is. Any overflow is absorbed downward
                // by lineLimit + minimumScaleFactor, never upward.
                VStack(spacing: h * 0.02) {
                    Text(ref.uppercased())
                        .font(.system(size: h * 0.019, weight: .semibold, design: fontDesign))
                        .tracking(h * 0.004)
                        .foregroundStyle(.white.opacity(0.85))

                    Text("\u{201C}\(fittedText)\u{201D}")
                        .font(.system(size: h * 0.032, weight: .regular, design: fontDesign))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(h * 0.009)
                        .lineLimit(10)
                        .minimumScaleFactor(0.5)

                    if !translation.isEmpty {
                        Text(translation)
                            .font(.system(size: h * 0.015, weight: .medium, design: fontDesign))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
                .shadow(color: .black.opacity(0.35), radius: h * 0.006, x: 0, y: 1)
                .padding(.horizontal, w * 0.1)
                .frame(maxWidth: .infinity, maxHeight: h * 0.42)
                .padding(.bottom, h * 0.17) // clear of the bottom Lock Screen controls
            }
            .frame(width: w, height: h)
        }
    }
}

// MARK: - Background presets

/// Curated rich gradients that keep white verse text legible. "Dusk" is first
/// (and the default) because it matches the app's Lock Screen aesthetic.
struct WallpaperBackground: Identifiable, Equatable {
    let id: String
    let name: String
    let colors: [Color]

    var gradient: LinearGradient {
        LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    static func == (lhs: WallpaperBackground, rhs: WallpaperBackground) -> Bool {
        lhs.id == rhs.id
    }

    static let presets: [WallpaperBackground] = [
        WallpaperBackground(id: "dusk", name: "Dusk", colors: [Color(hex: "#3A2E6B"), Color(hex: "#5B4B8A"), Color(hex: "#9384B8")]),
        WallpaperBackground(id: "night", name: "Night", colors: [Color(hex: "#0B1220"), Color(hex: "#1E293B")]),
        WallpaperBackground(id: "dawn", name: "Dawn", colors: [Color(hex: "#7A3B2E"), Color(hex: "#C86548"), Color(hex: "#E4A17C")]),
        WallpaperBackground(id: "forest", name: "Forest", colors: [Color(hex: "#12261C"), Color(hex: "#2E4636")]),
        WallpaperBackground(id: "slate", name: "Slate", colors: [Color(hex: "#1B2733"), Color(hex: "#3C4A57")]),
        WallpaperBackground(id: "ink", name: "Ink", colors: [Color(hex: "#0A0A0C"), Color(hex: "#232327")])
    ]
}
