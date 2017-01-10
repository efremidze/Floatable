//
//  Floatable.swift
//  Throwback
//
//  Created by Lasha Efremidze on 12/27/16.
//  Copyright © 2016 StubHubLabs. All rights reserved.
//

import UIKit

enum Direction {
    case top, left, bottom, right
}

protocol Floatable {}

extension Floatable where Self: UIView {
//    func float(direction: Direction, offset: CGFloat? = nil, size: CGSize, duration: TimeInterval, durationRange: TimeInterval, wavelength: CGFloat, wavelengthRange: CGFloat, amplitude: CGFloat, amplitudeRange: CGFloat) {
    func float(direction: Direction, offset: CGFloat? = nil, size: CGSize, duration: TimeInterval, rotation: CGFloat) {
        switch direction {
        case .top:
            self.center.y -= offset ?? self.frame.height / 2
            self.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        case .left:
            self.center.x -= offset ?? self.frame.width / 2
            self.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        case .bottom:
            self.center.y += offset ?? self.frame.height / 2
            self.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        case .right:
            self.center.x += offset ?? self.frame.width / 2
            self.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        }
        
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
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path(size: size, direction: direction, wavelength: 3 + random(-0.25..<0.25), amplitude: random(-0.4..<0.4)).cgPath
        animation.duration = duration
        self.layer.add(animation, forKey: "position")
    }
    
    private func path(size: CGSize, direction: Direction, wavelength: CGFloat, amplitude: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: center)
        for angle: CGFloat in stride(from: 5, through: 360, by: 5) {
            let percent = angle / 360
            var point = center
            switch direction {
            case .top:
                point.x -= sin(percent * (2 * .pi) * (1 / wavelength)) * size.width * amplitude
                point.y -= percent * size.height
            case .left:
                point.x -= percent * size.width
                point.y -= sin(percent * (2 * .pi) * (1 / wavelength)) * size.height * amplitude
            case .bottom:
                point.x += sin(percent * (2 * .pi) * (1 / wavelength)) * size.width * amplitude
                point.y += percent * size.height
            case .right:
                point.x += percent * size.width
                point.y += sin(percent * (2 * .pi) * (1 / wavelength)) * size.height * amplitude
            }
            path.addLine(to: point)
        }
        return path
    }
}

extension UIView: Floatable {}

private func random(_ range: Range<CGFloat>) -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * (range.upperBound - range.lowerBound) + range.lowerBound
}

extension UIView {
    
    func earned(points: Int, color: UIColor, direction: Direction) {
        let label = UILabel()
        label.text = "+\(points)pts"
        label.textColor = color
        label.font = UIFont.AvenirNext.DemiBold.size(17)
        label.layer.addDropShadow()
        self.superview!.addSubview(label)
        label.sizeToFit()
        label.center = self.center
        label.float(direction: direction, size: CGSize(width: 50, height: 150), duration: 4, rotation: random(-0.1..<0.1) * .pi)
    }
    
}
