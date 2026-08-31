import AppKit
import CoreGraphics
import Foundation

// Word Unlocked app icon: an open book, drawn so the two pages read as separate
// surfaces (visible centre gutter + text rules) rather than one gold blob.
let S: CGFloat = 1024
let cs = CGColorSpaceCreateDeviceRGB()
guard let ctx = CGContext(data: nil, width: Int(S), height: Int(S), bitsPerComponent: 8,
                          bytesPerRow: 0, space: cs,
                          bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else { exit(1) }

func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> CGColor {
    CGColor(colorSpace: cs, components: [r/255, g/255, b/255, 1])!
}
let navyTop  = rgb(31, 48, 102)
let navyBot  = rgb(10, 18, 46)
let gold     = rgb(232, 180, 74)
let goldDeep = rgb(198, 146, 52)

// Background: vertical gradient, full bleed, fully opaque.
let grad = CGGradient(colorsSpace: cs, colors: [navyTop, navyBot] as CFArray, locations: [0, 1])!
ctx.drawLinearGradient(grad, start: CGPoint(x: 0, y: S), end: CGPoint(x: 0, y: 0), options: [])

// Geometry. CoreGraphics origin is bottom-left; the book sits slightly low so the
// optical centre lands where the eye expects it.
let cx: CGFloat = S/2
let spineTop: CGFloat = 726      // gutter top
let spineBot: CGFloat = 306      // gutter bottom
let outerX: CGFloat = 190        // distance from centre to a page's outer edge
let gutter: CGFloat = 26         // half-width of the dark valley between pages

// One page as a closed path. `dir` = -1 for the left page, +1 for the right.
func page(_ dir: CGFloat) -> CGPath {
    let p = CGMutablePath()
    let inner = cx + dir * gutter
    let outer = cx + dir * (gutter + outerX * 2)
    p.move(to: CGPoint(x: inner, y: spineTop))
    // Top edge: sweeps out and down from the gutter.
    p.addQuadCurve(to: CGPoint(x: outer, y: spineTop - 96),
                   control: CGPoint(x: cx + dir * (gutter + outerX), y: spineTop - 8))
    // Outer edge down.
    p.addLine(to: CGPoint(x: outer, y: spineBot - 34))
    // Bottom edge: mirrors the top so the page reads as a curved sheet.
    p.addQuadCurve(to: CGPoint(x: inner, y: spineBot),
                   control: CGPoint(x: cx + dir * (gutter + outerX), y: spineBot - 118))
    p.closeSubpath()
    return p
}

for dir in [CGFloat(-1), CGFloat(1)] {
    ctx.addPath(page(dir)); ctx.setFillColor(gold); ctx.fillPath()
}

// Text rules — the detail that makes this read as a book at 60pt.
ctx.setStrokeColor(navyBot)
ctx.setLineCap(.round)
ctx.setLineWidth(26)
for dir in [CGFloat(-1), CGFloat(1)] {
    let inner = cx + dir * (gutter + 54)
    for i in 0..<4 {
        let y = spineTop - 150 - CGFloat(i) * 82
        let shrink = CGFloat(i) * 12
        let outer = cx + dir * (gutter + outerX * 2 - 62 - shrink)
        ctx.move(to: CGPoint(x: inner, y: y - CGFloat(dir == 1 ? 0 : 0)))
        ctx.addLine(to: CGPoint(x: outer, y: y - 18))
        ctx.strokePath()
    }
}

// Centre spine: a slim deeper-gold column so the two pages stay joined.
ctx.setFillColor(goldDeep)
let spine = CGMutablePath()
spine.move(to: CGPoint(x: cx - gutter, y: spineTop))
spine.addLine(to: CGPoint(x: cx + gutter, y: spineTop))
spine.addLine(to: CGPoint(x: cx + gutter, y: spineBot))
spine.addLine(to: CGPoint(x: cx - gutter, y: spineBot))
spine.closeSubpath()
ctx.addPath(spine); ctx.fillPath()

guard let img = ctx.makeImage() else { exit(1) }
let out = URL(fileURLWithPath: CommandLine.arguments[1])
let rep = NSBitmapImageRep(cgImage: img)
rep.size = NSSize(width: S, height: S)
try! rep.representation(using: .png, properties: [:])!.write(to: out)
print("wrote \(out.path)")
