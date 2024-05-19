import UIKit

class CrosshairView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let lineWidth: CGFloat = 2.0
        let circleRadius: CGFloat = 14.0

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let circleRect = CGRect(
            x: center.x - circleRadius,
            y: center.y - circleRadius,
            width: circleRadius * 2,
            height: circleRadius * 2
        )

        context.setLineWidth(lineWidth)
        context.setStrokeColor(UIColor.cyan.cgColor)
        context.strokeEllipse(in: circleRect)
    }
}
