import SwiftUI

struct BubbleShape: Shape {
    let isUser: Bool

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        let r: CGFloat = 20

        if isUser {
            // User: Tail on right
            // Start top-left
            p.move(to: CGPoint(x: r, y: 0))

            // Top edge
            p.addLine(to: CGPoint(x: w - r, y: 0))

            // Top-right corner
            p.addArc(
                center: CGPoint(x: w - r, y: r), radius: r, startAngle: .degrees(-90),
                endAngle: .degrees(0), clockwise: false)

            // Right edge to tail start
            p.addLine(to: CGPoint(x: w, y: h - 20))

            // Tail
            p.addLine(to: CGPoint(x: w + 10, y: h - 10))
            p.addLine(to: CGPoint(x: w, y: h))

            // Bottom edge
            p.addLine(to: CGPoint(x: r, y: h))

            // Bottom-left corner
            p.addArc(
                center: CGPoint(x: r, y: h - r), radius: r, startAngle: .degrees(90),
                endAngle: .degrees(180), clockwise: false)

            // Left edge
            p.addLine(to: CGPoint(x: 0, y: r))

            // Top-left corner
            p.addArc(
                center: CGPoint(x: r, y: r), radius: r, startAngle: .degrees(180),
                endAngle: .degrees(270), clockwise: false)

        } else {
            // Assistant: Tail on left
            let r: CGFloat = 20

            // Start top-left
            p.move(to: CGPoint(x: r, y: 0))

            // Top edge
            p.addLine(to: CGPoint(x: w - r, y: 0))

            // Top-right corner
            p.addArc(
                center: CGPoint(x: w - r, y: r), radius: r, startAngle: .degrees(-90),
                endAngle: .degrees(0), clockwise: false)

            // Right edge
            p.addLine(to: CGPoint(x: w, y: h - r))

            // Bottom-right corner
            p.addArc(
                center: CGPoint(x: w - r, y: h - r), radius: r, startAngle: .degrees(0),
                endAngle: .degrees(90), clockwise: false)

            // Bottom edge
            p.addLine(to: CGPoint(x: r, y: h))

            // Bottom-left corner (with tail)
            p.addLine(to: CGPoint(x: 0, y: h))  // To corner
            p.addLine(to: CGPoint(x: -10, y: h - 10))  // Tail tip
            p.addLine(to: CGPoint(x: 0, y: h - 20))  // Back to side

            // Left edge
            p.addLine(to: CGPoint(x: 0, y: r))

            // Top-left corner
            p.addArc(
                center: CGPoint(x: r, y: r), radius: r, startAngle: .degrees(180),
                endAngle: .degrees(270), clockwise: false)
        }

        return p
    }
}
