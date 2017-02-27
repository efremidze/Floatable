//
//  Floatable.swift
//  Throwback
//
//  Created by Lasha Efremidze on 12/27/16.
//  Copyright © 2016 StubHubLabs. All rights reserved.
//

import UIKit

public enum Direction {
    case top, left, bottom, right, angle(CGFloat)
    
    var angle: CGFloat {
        switch self {
        case .top:
            return -90
        case .left:
            return 180
        case .bottom:
            return 90
        case .right:
            return 0
        case let .angle(angle):
            return angle
        }
    }
}

protocol Floatable {}

extension Floatable where Self: UIView {
//    func float(direction: Direction, offset: CGFloat? = nil, size: CGSize, duration: TimeInterval, durationRange: TimeInterval, wavelength: CGFloat, wavelengthRange: CGFloat, amplitude: CGFloat, amplitudeRange: CGFloat) {
    func float(direction: Direction, offset: CGFloat? = nil, size: CGSize, duration: TimeInterval, rotation: CGFloat) {
        let path = self.path(size: size, direction: direction, wavelength: 3 + random(-0.25..<0.25), amplitude: random(-0.4..<0.4))
        
//        self.center.x += offset ?? self.frame.width / 2
//        self.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = duration
        self.layer.add(animation, forKey: "position")
        
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [.curveEaseOut], animations: { [unowned self] in
            self.transform = CGAffineTransform.identity
            self.alpha = 1
        }, completion: { [unowned self] _ in
            UIView.animate(withDuration: duration - 0.5, delay: 0, options: [.curveLinear], animations: { [unowned self] in
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).rotated(by: rotation)
                self.alpha = 0
            }, completion: { [unowned self] _ in
                self.removeFromSuperview()
            })
        })
    }
    
    private func path(size: CGSize, direction: Direction, wavelength: CGFloat, amplitude: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: center)
        for angle: CGFloat in stride(from: 5, through: 360, by: 5) {
            let percent = angle / 360
            var point = center
            point.x += percent * size.width
            point.y += sin(percent * (2 * .pi) * (1 / wavelength)) * size.height * amplitude
            path.addLine(to: point)
        }
        
        let bounds = path.cgPath.boundingBox
        
        let toOrigin = CGAffineTransform(translationX: -bounds.midX, y: -bounds.midY)
        path.apply(toOrigin)
        
        let rotation = CGAffineTransform(rotationAngle: direction.angle.degreesToRadians)
        path.apply(rotation)
        
        let fromOrigin = CGAffineTransform(translationX: bounds.midX, y: bounds.midY)
        path.apply(fromOrigin)
        
        return path
    }
}

private func random(_ range: Range<CGFloat>) -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * (range.upperBound - range.lowerBound) + range.lowerBound
}

private extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
}

extension UIView: Floatable {
    
    func animate() { // temp
        let label = UILabel()
        label.text = "+10pts"
        label.textColor = .red
        label.font = .boldSystemFont(ofSize: 17)
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowRadius = 0.1
        label.layer.shadowOpacity = 0.1
        animate(label, direction: .top)
    }
    
    public func animate(_ image: UIImage?, direction: Direction) {
        animate(UIImageView(image: image), direction: direction)
    }
    
    func animate(_ customView: UIView, direction: Direction) {
        self.superview!.addSubview(customView)
        customView.sizeToFit()
        customView.center = self.center
        customView.float(direction: direction, size: CGSize(width: 200, height: 50), duration: 4, rotation: random(-0.1..<0.1) * .pi)
    }
    
}

//class Floatable2: CALayer {
//
//    open var emitterPosition: CGPoint
//    open var emitterSize: CGSize
////    open var duration: TimeInterval
////    open var speed: Float
//    open var amplitude: Float
//    open var wavelength: Float
//    open var angle: Float
//    open var spin: Float
//    open var animating: ((TimeInterval) -> Void)?
//
//    func run() {
//        let emitter = CAEmitterLayer()
//
//        emitter.emitterPosition = superview.convertPoint(imageView.center, toView: superview)
//        emitter.emitterSize = CGSize(width: animationRadius, height: animationRadius)
//        emitter.seed = (arc4random() % 1000) + 1
//        superview.layer.addSublayer(emitter)
//
//        let star = CAEmitterCell()
//        star.contents = UIImage(named: "stars")!.CGImage
//        star.color = UIColor.applicationCornflowerColor().colorWithAlphaComponent(0.6).CGColor
//        star.birthRate = 20
//        star.lifetime = 0.5
//        star.scale = 0.04
//        emitter.emitterCells = [star]
//
//        emitter.birthRate = 0
//    }
//
//}
