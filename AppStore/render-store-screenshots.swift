import AppKit

// Compose store posters from unchanged production screen captures. No UI values
// or controls are retouched; only the whole capture is scaled into a frame.
let root = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
let output = root.appendingPathComponent("StoreScreenshots", isDirectory: true)
try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)
let slides: [(String, String, String)] = [
    ("01-Pourtime-Live-Pace.png", "See your pace\nchange over time", "Follow your logged intake\nas the session unfolds."),
    ("02-Pourtime-Timestamp-Entry.png", "Log drinks when\nyou had them", "Choose the actual time,\neven when you log later."),
    ("04-Pourtime-Session-Details.png", "Your night,\ndrink by drink", "Review recorded times,\nserving sizes, and ABV."),
    ("03-Pourtime-Session-History.png", "Save sessions\nfor later", "Keep your drink journal\nand review past sessions."),
    ("05-Pourtime-Metric-Help.png", "Understand what\nyou logged", "Clear definitions for pace\nand US standard drinks.")
]
let width = 1320, height = 2868
func color(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> NSColor {
    NSColor(srgbRed: r / 255, green: g / 255, blue: b / 255, alpha: 1)
}
func text(_ value: String, top: CGFloat, size: CGFloat, weight: NSFont.Weight, tint: NSColor, boxHeight: CGFloat) {
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    style.lineSpacing = size * 0.08
    (value as NSString).draw(in: NSRect(x: 80, y: CGFloat(height) - top - boxHeight, width: 1160, height: boxHeight), withAttributes: [.font: NSFont.systemFont(ofSize: size, weight: weight), .foregroundColor: tint, .paragraphStyle: style])
}
for (index, slide) in slides.enumerated() {
    let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
    let context = NSGraphicsContext.current!
    context.imageInterpolation = .high
    color(245, 248, 248).setFill()
    NSRect(x: 0, y: 0, width: width, height: height).fill()
    text("POURTIME", top: 76, size: 38, weight: .bold, tint: color(0, 166, 178), boxHeight: 60)
    text(slide.1, top: 160, size: 88, weight: .bold, tint: color(20, 37, 40), boxHeight: 240)
    text(slide.2, top: 403, size: 40, weight: .regular, tint: color(69, 91, 95), boxHeight: 120)
    let frame = NSRect(x: 142, y: 56, width: 1036, height: 2232)
    let outer = NSBezierPath(roundedRect: frame, xRadius: 100, yRadius: 100)
    color(20, 37, 40).setFill()
    outer.fill()
    let screenRect = NSRect(x: 154, y: 68, width: 1012, height: 2198.8)
    NSGraphicsContext.saveGraphicsState()
    NSBezierPath(roundedRect: screenRect, xRadius: 89, yRadius: 89).addClip()
    let screen = NSImage(contentsOf: root.appendingPathComponent("Screenshots").appendingPathComponent(slide.0))!
    screen.draw(in: screenRect, from: .zero, operation: .copy, fraction: 1)
    NSGraphicsContext.restoreGraphicsState()
    NSGraphicsContext.restoreGraphicsState()
    let filename = String(format: "%02d-Pourtime.jpg", index + 1)
    try bitmap.representation(using: .jpeg, properties: [.compressionFactor: 1.0])!.write(to: output.appendingPathComponent(filename))
}
