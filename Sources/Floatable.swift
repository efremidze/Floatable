//
//  Floatable.swift
//  Throwback
//
//  Created by Lasha Efremidze on 12/27/16.
//  Copyright © 2016 StubHubLabs. All rights reserved.
//

import UIKit

protocol Floatable {}

extension Floatable where Self: UIView {
    
//    func float(offset: CGFloat, anchor: CGPoint, size: CGSize, duration: TimeInterval, wavelength: CGFloat, amplitude: CGFloat, angle: CGFloat, spin: CGFloat) {
    func float(offset: CGFloat, anchor: CGPoint, size: CGSize, duration: TimeInterval, wavelength: CGFloat, amplitude: CGFloat, spin: CGFloat) {
        let path = self.path(size: size, wavelength: wavelength, amplitude: amplitude)
        
        self.center.y -= offset
        self.layer.anchorPoint = anchor
        
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
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).rotated(by: spin)
                self.alpha = 0
            }, completion: { [unowned self] _ in
                self.removeFromSuperview()
            })
        })
    }
    
    func path(size: CGSize, wavelength: CGFloat, amplitude: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: center)
        for angle: CGFloat in stride(from: 5, through: 360, by: 5) {
            let percent = angle / 360
            var point = center
            point.x -= sin(percent * (2 * .pi) * (1 / wavelength)) * size.width * amplitude
            point.y -= percent * size.height
            path.addLine(to: point)
        }
        return path
    }
    
}

extension UIView: Floatable {
    
    open func animate(customView: UIView) {
        self.superview!.addSubview(customView)
        customView.sizeToFit()
        customView.center = self.center
        customView.float(offset: self.frame.height / 2, anchor: CGPoint(x: 0.5, y: 1), size: CGSize(width: 50, height: 250), duration: 4, wavelength: 2 + random(-0.5..<0.5), amplitude: random(-0.4..<0.4), spin: random(-0.1..<0.1) * .pi)
    }
    
}

private func random(_ range: Range<CGFloat>) -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * (range.upperBound - range.lowerBound) + range.lowerBound
}
