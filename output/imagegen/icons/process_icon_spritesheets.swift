import AppKit
import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

let iconNames = [
  "home", "search", "settings", "person", "favorite", "star", "notifications", "mail", "phone", "chat",
  "camera_alt", "photo", "image", "music_note", "play_arrow", "pause", "stop", "volume_up", "mic", "videocam",
  "calendar_today", "access_time", "alarm", "location_on", "map", "navigation", "directions_car", "flight", "train", "directions_bike",
  "shopping_cart", "store", "local_offer", "credit_card", "account_balance", "work", "school", "restaurant", "local_cafe", "local_hospital",
  "check", "close", "add", "remove", "edit", "delete", "download", "upload", "share", "refresh",
  "arrow_back", "arrow_forward", "expand_more", "menu", "more_vert", "filter_list", "sort", "visibility", "lock", "key",
  "wifi", "bluetooth", "battery_full", "cloud", "cloud_upload", "computer", "smartphone", "tablet", "watch", "print",
  "build", "construction", "brush", "palette", "code", "bug_report", "lightbulb", "science", "analytics", "bar_chart",
  "pets", "park", "eco", "water_drop", "beach_access", "forest", "terrain", "sailing", "anchor", "waves",
  "help", "info", "warning", "error", "security", "shield", "verified", "bookmark", "flag", "category",
]

struct ThemeSheet {
  let name: String
  let input: String
  let outputDir: String
}

let sheets = [
  ThemeSheet(
    name: "animal",
    input: "output/imagegen/icons/animal-icons-10x10.png",
    outputDir: "assets/animal_island/src/img/icons/animal"
  ),
  ThemeSheet(
    name: "nes",
    input: "output/imagegen/icons/nes-icons-10x10.png",
    outputDir: "assets/animal_island/src/img/icons/nes"
  ),
  ThemeSheet(
    name: "westworld",
    input: "output/imagegen/icons/westworld-icons-10x10.png",
    outputDir: "assets/animal_island/src/img/icons/westworld"
  ),
  ThemeSheet(
    name: "guofeng",
    input: "output/imagegen/icons/guofeng-icons-10x10.png",
    outputDir: "assets/animal_island/src/img/icons/guofeng"
  ),
]

func fail(_ message: String) -> Never {
  FileHandle.standardError.write(Data((message + "\n").utf8))
  exit(1)
}

func offset(_ x: Int, _ y: Int, _ bytesPerRow: Int) -> Int {
  y * bytesPerRow + x * 4
}

func isChromaMagenta(r: Int, g: Int, b: Int, a: Int) -> Bool {
  if a == 0 { return true }
  return r > 145 &&
    b > 120 &&
    g < 115 &&
    r > Int(Double(g) * 1.55) &&
    b > Int(Double(g) * 1.30) &&
    abs(r - b) < 120
}

func isMagentaFringe(r: Int, g: Int, b: Int, a: Int) -> Bool {
  if a == 0 { return true }
  return r > 72 &&
    b > 58 &&
    g < 150 &&
    min(r, b) > g + 10 &&
    b > Int(Double(r) * 0.48) &&
    abs(r - b) < 135
}

func isPinkSpill(r: Int, g: Int, b: Int, a: Int) -> Bool {
  if a == 0 { return true }
  let minRB = min(r, b)
  return minRB > g + 7 &&
    abs(r - b) < 150 &&
    r > 55 &&
    b > 45
}

func isExteriorChroma(_ pixels: [UInt8], _ x: Int, _ y: Int, _ bytesPerRow: Int) -> Bool {
  let i = offset(x, y, bytesPerRow)
  let r = Int(pixels[i])
  let g = Int(pixels[i + 1])
  let b = Int(pixels[i + 2])
  let a = Int(pixels[i + 3])
  return isChromaMagenta(r: r, g: g, b: b, a: a)
}

func loadPixels(from url: URL) -> (pixels: [UInt8], width: Int, height: Int, bytesPerRow: Int) {
  guard let nsImage = NSImage(contentsOf: url),
        let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
  else {
    fail("Unable to load \(url.path)")
  }

  let width = cgImage.width
  let height = cgImage.height
  let bytesPerRow = width * 4
  var pixels = [UInt8](repeating: 0, count: height * bytesPerRow)
  guard let context = CGContext(
    data: &pixels,
    width: width,
    height: height,
    bitsPerComponent: 8,
    bytesPerRow: bytesPerRow,
    space: CGColorSpaceCreateDeviceRGB(),
    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
  ) else {
    fail("Unable to create bitmap context")
  }
  context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
  return (pixels, width, height, bytesPerRow)
}

func removeExteriorChroma(_ pixels: inout [UInt8], width: Int, height: Int, bytesPerRow: Int) {
  var visited = [Bool](repeating: false, count: width * height)
  var queue = [(Int, Int)]()
  queue.reserveCapacity(width * height / 2)

  func push(_ x: Int, _ y: Int) {
    guard x >= 0, x < width, y >= 0, y < height else { return }
    let idx = y * width + x
    guard !visited[idx] else { return }
    visited[idx] = true
    if isExteriorChroma(pixels, x, y, bytesPerRow) {
      queue.append((x, y))
    }
  }

  for x in 0..<width {
    push(x, 0)
    push(x, height - 1)
  }
  for y in 0..<height {
    push(0, y)
    push(width - 1, y)
  }

  var head = 0
  while head < queue.count {
    let (x, y) = queue[head]
    head += 1
    let i = offset(x, y, bytesPerRow)
    let r = Int(pixels[i])
    let g = Int(pixels[i + 1])
    let b = Int(pixels[i + 2])
    let a = Int(pixels[i + 3])
    let magenta = min(r, b) - g
    let strength = min(1.0, max(0.0, Double(magenta - 24) / 120.0))
    pixels[i + 3] = UInt8(max(0, min(255, Int(Double(a) * (1.0 - strength)))))
    push(x - 1, y)
    push(x + 1, y)
    push(x, y - 1)
    push(x, y + 1)
  }
}

func writePng(_ data: [UInt8], width: Int, height: Int, to url: URL, interpolate: Bool) {
  try? FileManager.default.createDirectory(
    at: url.deletingLastPathComponent(),
    withIntermediateDirectories: true
  )
  guard let provider = CGDataProvider(data: Data(data) as CFData),
        let image = CGImage(
          width: width,
          height: height,
          bitsPerComponent: 8,
          bitsPerPixel: 32,
          bytesPerRow: width * 4,
          space: CGColorSpaceCreateDeviceRGB(),
          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
          provider: provider,
          decode: nil,
          shouldInterpolate: interpolate,
          intent: .defaultIntent
        ),
        let destination = CGImageDestinationCreateWithURL(
          url as CFURL,
          UTType.png.identifier as CFString,
          1,
          nil
        )
  else {
    fail("Unable to write \(url.path)")
  }
  CGImageDestinationAddImage(destination, image, nil)
  guard CGImageDestinationFinalize(destination) else {
    fail("Unable to finalize \(url.path)")
  }
}

func copyCropToCanvas(
  pixels: [UInt8],
  width: Int,
  height: Int,
  bytesPerRow: Int,
  crop: (x0: Int, y0: Int, x1: Int, y1: Int),
  canvasSize: Int
) -> [UInt8] {
  let cropWidth = crop.x1 - crop.x0 + 1
  let cropHeight = crop.y1 - crop.y0 + 1
  if cropWidth > canvasSize || cropHeight > canvasSize {
    fail("Icon crop \(cropWidth)x\(cropHeight) exceeds \(canvasSize)x\(canvasSize)")
  }
  var canvas = [UInt8](repeating: 0, count: canvasSize * canvasSize * 4)
  let dstX = (canvasSize - cropWidth) / 2
  let dstY = (canvasSize - cropHeight) / 2

  for y in 0..<cropHeight {
    let src = offset(crop.x0, crop.y0 + y, bytesPerRow)
    let dst = ((dstY + y) * canvasSize + dstX) * 4
    pixels.withUnsafeBufferPointer { srcBuffer in
      canvas.withUnsafeMutableBufferPointer { dstBuffer in
        dstBuffer.baseAddress!.advanced(by: dst).update(
          from: srcBuffer.baseAddress!.advanced(by: src),
          count: cropWidth * 4
        )
      }
    }
  }
  return canvas
}

func isCellChroma(_ data: [UInt8], _ index: Int, _ theme: String) -> Bool {
  let r = Int(data[index])
  let g = Int(data[index + 1])
  let b = Int(data[index + 2])
  let a = Int(data[index + 3])
  if a == 0 { return true }
  return isChromaMagenta(r: r, g: g, b: b, a: a)
}

func cleanCellSpill(_ data: inout [UInt8], size: Int, theme: String) {
  var visited = [Bool](repeating: false, count: size * size)
  var queue = [(Int, Int)]()
  queue.reserveCapacity(size * size / 2)

  func index(_ x: Int, _ y: Int) -> Int {
    (y * size + x) * 4
  }

  func push(_ x: Int, _ y: Int) {
    guard x >= 0, x < size, y >= 0, y < size else { return }
    let position = y * size + x
    guard !visited[position] else { return }
    visited[position] = true
    let i = index(x, y)
    if data[i + 3] == 0 || isCellChroma(data, i, theme) {
      queue.append((x, y))
    }
  }

  for x in 0..<size {
    push(x, 0)
    push(x, size - 1)
  }
  for y in 0..<size {
    push(0, y)
    push(size - 1, y)
  }

  var head = 0
  while head < queue.count {
    let (x, y) = queue[head]
    head += 1
    let i = index(x, y)
    if isCellChroma(data, i, theme) {
      data[i + 3] = 0
    }
    push(x - 1, y)
    push(x + 1, y)
    push(x, y - 1)
    push(x, y + 1)
  }

  for i in stride(from: 0, to: data.count, by: 4) {
    if isCellChroma(data, i, theme) {
      data[i + 3] = 0
    }
  }
}

func removeMagentaFringe(_ data: inout [UInt8], size: Int, theme: String) {
  let original = data

  func index(_ x: Int, _ y: Int) -> Int {
    (y * size + x) * 4
  }

  func nearTransparent(_ x: Int, _ y: Int, radius: Int) -> Bool {
    for yy in max(0, y - radius)...min(size - 1, y + radius) {
      for xx in max(0, x - radius)...min(size - 1, x + radius) {
        if original[index(xx, yy) + 3] < 20 {
          return true
        }
      }
    }
    return false
  }

  for y in 0..<size {
    for x in 0..<size {
      let i = index(x, y)
      let r = Int(original[i])
      let g = Int(original[i + 1])
      let b = Int(original[i + 2])
      let a = Int(original[i + 3])
      guard a > 0 else { continue }

      if isPinkSpill(r: r, g: g, b: b, a: a) && nearTransparent(x, y, radius: 3) {
        let minRB = min(r, b)
        let magentaStrength = minRB - g
        let brightness = (r + g + b) / 3
        let neutral = UInt8(max(0, min(255, (g * 2 + minRB) / 3)))

        if brightness > 150 && magentaStrength > 10 {
          data[i + 3] = 0
        } else if magentaStrength > 22 && brightness > 92 {
          data[i + 3] = UInt8(max(0, min(255, Int(Double(a) * 0.25))))
          data[i] = neutral
          data[i + 1] = neutral
          data[i + 2] = neutral
        } else {
          data[i] = neutral
          data[i + 1] = neutral
          data[i + 2] = neutral
        }
      } else if a > 0 && nearTransparent(x, y, radius: 1) && isMagentaFringe(r: r, g: g, b: b, a: a) {
        let neutral = UInt8(max(0, min(255, (g * 2 + min(r, b)) / 3)))
        data[i] = neutral
        data[i + 1] = neutral
        data[i + 2] = neutral
      }
    }
  }
}

func centeredOnVisibleBounds(_ data: [UInt8], size: Int) -> [UInt8] {
  var minX = size
  var minY = size
  var maxX = 0
  var maxY = 0

  func index(_ x: Int, _ y: Int) -> Int {
    (y * size + x) * 4
  }

  for y in 0..<size {
    for x in 0..<size {
      if data[index(x, y) + 3] > 18 {
        minX = min(minX, x)
        minY = min(minY, y)
        maxX = max(maxX, x)
        maxY = max(maxY, y)
      }
    }
  }

  guard minX <= maxX, minY <= maxY else {
    return data
  }

  let width = maxX - minX + 1
  let height = maxY - minY + 1
  let dstX = (size - width) / 2
  let dstY = (size - height) / 2
  var centered = [UInt8](repeating: 0, count: size * size * 4)

  for y in 0..<height {
    let src = index(minX, minY + y)
    let dst = index(dstX, dstY + y)
    data.withUnsafeBufferPointer { srcBuffer in
      centered.withUnsafeMutableBufferPointer { dstBuffer in
        dstBuffer.baseAddress!.advanced(by: dst).update(
          from: srcBuffer.baseAddress!.advanced(by: src),
          count: width * 4
        )
      }
    }
  }
  return centered
}

func visibleBounds(
  pixels: [UInt8],
  bytesPerRow: Int,
  xRange: (Int, Int),
  yRange: (Int, Int)
) -> (minX: Int, minY: Int, maxX: Int, maxY: Int)? {
  var minX = xRange.1
  var minY = yRange.1
  var maxX = xRange.0
  var maxY = yRange.0

  for y in yRange.0...yRange.1 {
    for x in xRange.0...xRange.1 {
      if pixels[offset(x, y, bytesPerRow) + 3] > 10 {
        minX = min(minX, x)
        minY = min(minY, y)
        maxX = max(maxX, x)
        maxY = max(maxY, y)
      }
    }
  }

  guard minX <= maxX, minY <= maxY else {
    return nil
  }
  return (minX, minY, maxX, maxY)
}

func fixedGridBand(length: Int, index: Int, count: Int) -> (Int, Int) {
  let start = Int((Double(index) * Double(length) / Double(count)).rounded(.down))
  let end = Int((Double(index + 1) * Double(length) / Double(count)).rounded(.down)) - 1
  return (start, end)
}

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)

for sheet in sheets {
  let inputUrl = root.appendingPathComponent(sheet.input)
  var (pixels, width, height, bytesPerRow) = loadPixels(from: inputUrl)
  removeExteriorChroma(&pixels, width: width, height: height, bytesPerRow: bytesPerRow)

  let keyedUrl = root.appendingPathComponent("output/imagegen/icons/\(sheet.name)-icons-10x10-keyed.png")
  writePng(pixels, width: width, height: height, to: keyedUrl, interpolate: sheet.name != "nes")

  let outputDir = root.appendingPathComponent(sheet.outputDir)
  try? FileManager.default.removeItem(at: outputDir)
  try? FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)

  let pad = sheet.name == "westworld" ? 28 : 30
  let canvasSize = 256

  for row in 0..<10 {
    for col in 0..<10 {
      let index = row * 10 + col
      let xBand = fixedGridBand(length: width, index: col, count: 10)
      let yBand = fixedGridBand(length: height, index: row, count: 10)
      guard let cellBounds = visibleBounds(
        pixels: pixels,
        bytesPerRow: bytesPerRow,
        xRange: xBand,
        yRange: yBand
      ) else {
        fail("No visible pixels in \(sheet.name) cell \(row),\(col)")
      }
      let crop = (
        x0: max(xBand.0, cellBounds.minX - pad),
        y0: max(yBand.0, cellBounds.minY - pad),
        x1: min(xBand.1, cellBounds.maxX + pad),
        y1: min(yBand.1, cellBounds.maxY + pad)
      )
      var cell = copyCropToCanvas(
        pixels: pixels,
        width: width,
        height: height,
        bytesPerRow: bytesPerRow,
        crop: crop,
        canvasSize: canvasSize
      )
      cleanCellSpill(&cell, size: canvasSize, theme: sheet.name)
      removeMagentaFringe(&cell, size: canvasSize, theme: sheet.name)
      cell = centeredOnVisibleBounds(cell, size: canvasSize)
      let outputUrl = outputDir.appendingPathComponent("\(iconNames[index]).png")
      writePng(cell, width: canvasSize, height: canvasSize, to: outputUrl, interpolate: sheet.name != "nes")
    }
  }
  print("\(sheet.name): \(width)x\(height), fixed 10x10 grid -> \(sheet.outputDir)")
}
