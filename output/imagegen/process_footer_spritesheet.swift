import AppKit
import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

struct Pixel {
  var r: UInt8
  var g: UInt8
  var b: UInt8
  var a: UInt8
}

func fail(_ message: String) -> Never {
  FileHandle.standardError.write(Data((message + "\n").utf8))
  exit(1)
}

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let input = root.appendingPathComponent("output/imagegen/theme-footer-2x3-spritesheet.png")
guard let nsImage = NSImage(contentsOf: input),
      let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
else {
  fail("Unable to load \(input.path)")
}

let width = cgImage.width
let height = cgImage.height
let bytesPerPixel = 4
let bytesPerRow = width * bytesPerPixel
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

func offset(_ x: Int, _ y: Int) -> Int {
  y * bytesPerRow + x * bytesPerPixel
}

func isEdgeGreen(_ x: Int, _ y: Int) -> Bool {
  let i = offset(x, y)
  let r = Int(pixels[i])
  let g = Int(pixels[i + 1])
  let b = Int(pixels[i + 2])
  let a = Int(pixels[i + 3])
  if a == 0 { return true }
  return g > 145 && g > Int(Double(r) * 1.75) && g > Int(Double(b) * 1.75) && (g - max(r, b)) > 55
}

func isChromaSpill(_ i: Int) -> Bool {
  let r = Int(pixels[i])
  let g = Int(pixels[i + 1])
  let b = Int(pixels[i + 2])
  return g > 175 && r < 90 && b < 90 && (g - max(r, b)) > 105
}


var visited = [Bool](repeating: false, count: width * height)
var queue = [(Int, Int)]()
queue.reserveCapacity(width * height / 2)

func push(_ x: Int, _ y: Int) {
  guard x >= 0, x < width, y >= 0, y < height else { return }
  let idx = y * width + x
  guard !visited[idx] else { return }
  visited[idx] = true
  if isEdgeGreen(x, y) {
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
  let i = offset(x, y)
  let r = Int(pixels[i])
  let g = Int(pixels[i + 1])
  let b = Int(pixels[i + 2])
  let a = Int(pixels[i + 3])
  let strength = min(1.0, max(0.0, Double(g - max(r, b) - 45) / 120.0))
  pixels[i + 3] = UInt8(max(0, min(255, Int(Double(a) * (1.0 - strength)))))
  push(x - 1, y)
  push(x + 1, y)
  push(x, y - 1)
  push(x, y + 1)
}

let panels: [(name: String, startX: Int, endX: Int, startY: Int, endY: Int, out: String)] = [
  ("nes-tree", 0, 682, 0, 576, "assets/animal_island/src/img/nes/footer/tree.png"),
  ("westworld-tree", 682, 1365, 0, 576, "assets/animal_island/src/img/westworld/footer/tree.png"),
  ("guofeng-tree", 1365, 2048, 0, 576, "assets/animal_island/src/img/guofeng/footer/tree.png"),
  ("nes-sea", 0, 682, 576, 1152, "assets/animal_island/src/img/nes/footer/sea.png"),
  ("westworld-sea", 682, 1365, 576, 1152, "assets/animal_island/src/img/westworld/footer/sea.png"),
  ("guofeng-sea", 1365, 2048, 576, 1152, "assets/animal_island/src/img/guofeng/footer/sea.png"),
]

func writePng(_ data: [UInt8], width: Int, height: Int, to url: URL) {
  FileManager.default.createFile(atPath: url.deletingLastPathComponent().path, contents: nil)
  try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
  let mutableData = data
  guard let provider = CGDataProvider(data: Data(mutableData) as CFData),
        let image = CGImage(
          width: width,
          height: height,
          bitsPerComponent: 8,
          bitsPerPixel: 32,
          bytesPerRow: width * bytesPerPixel,
          space: CGColorSpaceCreateDeviceRGB(),
          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
          provider: provider,
          decode: nil,
          shouldInterpolate: true,
          intent: .defaultIntent
        ),
        let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)
  else {
    fail("Unable to write \(url.path)")
  }
  CGImageDestinationAddImage(destination, image, nil)
  guard CGImageDestinationFinalize(destination) else {
    fail("Unable to finalize \(url.path)")
  }
}

for panel in panels {
  var minX = panel.endX
  var minY = panel.endY
  var maxX = panel.startX
  var maxY = panel.startY
  for y in panel.startY..<panel.endY {
    for x in panel.startX..<panel.endX {
      if pixels[offset(x, y) + 3] > 12 {
        minX = min(minX, x)
        minY = min(minY, y)
        maxX = max(maxX, x)
        maxY = max(maxY, y)
      }
    }
  }
  guard minX <= maxX, minY <= maxY else {
    fail("No visible pixels for \(panel.name)")
  }

  let padX = 10
  let padTop = 22
  let padBottom = 4
  let cropX0 = max(panel.startX, minX - padX)
  let cropX1 = min(panel.endX - 1, maxX + padX)
  let cropY0 = max(panel.startY, minY - padTop)
  let cropY1 = min(panel.endY - 1, maxY + padBottom)
  let cropW = cropX1 - cropX0 + 1
  let cropH = cropY1 - cropY0 + 1
  var outPixels = [UInt8](repeating: 0, count: cropW * cropH * bytesPerPixel)
  for y in 0..<cropH {
    let src = offset(cropX0, cropY0 + y)
    let dst = y * cropW * bytesPerPixel
    pixels.withUnsafeBufferPointer { srcBuffer in
      outPixels.withUnsafeMutableBufferPointer { dstBuffer in
        dstBuffer.baseAddress!.advanced(by: dst).update(
          from: srcBuffer.baseAddress!.advanced(by: src),
          count: cropW * bytesPerPixel
        )
      }
    }
  }
  for y in 0..<cropH {
    for x in 0..<cropW {
      let i = y * cropW * bytesPerPixel + x * bytesPerPixel
      let r = Int(outPixels[i])
      let g = Int(outPixels[i + 1])
      let b = Int(outPixels[i + 2])
      let maxOther = max(r, b)
      let isNes = panel.name.hasPrefix("nes")
      let isWestworld = panel.name.hasPrefix("westworld")
      let isGuofeng = panel.name.hasPrefix("guofeng")
      let isChroma = isNes
        ? (g > 205 && r < 70 && b < 95 && (g - maxOther) > 135)
        : isWestworld
          ? (g > 48 && (g - maxOther) > 10)
          : (g > 104 && g > Int(Double(r) * 1.18) && g > Int(Double(b) * 1.18) && (g - maxOther) > 26)
      if isChroma {
        outPixels[i + 3] = 0
      } else if isGuofeng && g > 64 && (g - maxOther) > 16 {
        let ink = UInt8(max(18, min(72, (r + g + b) / 5)))
        outPixels[i] = ink
        outPixels[i + 1] = UInt8(min(82, Int(ink) + 12))
        outPixels[i + 2] = ink
      }
    }
  }
  let outUrl = root.appendingPathComponent(panel.out)
  writePng(outPixels, width: cropW, height: cropH, to: outUrl)
  print("\(panel.name): \(cropW)x\(cropH) -> \(panel.out)")
}
