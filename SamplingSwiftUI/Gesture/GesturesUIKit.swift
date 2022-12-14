//
//  GesturesUIKit.swift
//  SamplingSwiftUI
//
//  Created by Karun Pant on 14/12/22.
//

import UIKit

class GestureVC: UIViewController {
    
    let rect = UIView(frame: .init(origin: .init(x: 16, y: 16),
                                   size: .init(width: 200, height: 200)))
    
    override func viewDidLoad() {
        setupView()
        setupTapGesture()
        setupSwipeGesture()
        setupDragGesture()
    }
    
    private func setupView() {
        rect.backgroundColor = .cyan
        rect.center = view.center
        view.addSubview(rect)
    }
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap(gestureRecognizer:)))
        rect.addGestureRecognizer(tapGesture)
    }
    
    private func setupSwipeGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self,
                                                    action: #selector(onSwipe(gestureRecognizer:)))
        swipeGesture.direction = .right
        rect.addGestureRecognizer(swipeGesture)
    }
    
    private func setupDragGesture() {
        let dragGesture = UIPanGestureRecognizer(target: self,
                                                 action: #selector(onDrag(gestureRecognizer:)))
        rect.addGestureRecognizer(dragGesture)
    }
    
}

// MARK: - Gesture Handlers
extension GestureVC {
    
    @objc private func onTap(gestureRecognizer: UITapGestureRecognizer) {
        gestureRecognizer.view?.backgroundColor = randomColor
    }
    
    @objc private func onSwipe(gestureRecognizer: UISwipeGestureRecognizer) {
        gestureRecognizer.view?.backgroundColor = randomColor
    }
    
    private var randomColor: UIColor {
        let red = CGFloat(arc4random_uniform(256))/255.0
        let green = CGFloat(arc4random_uniform(256))/255.0
        let blue = CGFloat(arc4random_uniform(256))/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    @objc private func onDrag(gestureRecognizer gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: gesture.view)
            let xTranslated = (gesture.view?.center.x ?? 0) + translation.x
            let yTranslated = (gesture.view?.center.y ?? 0) + translation.y
            gesture.view?.center = CGPoint(x: xTranslated, y: yTranslated)
            gesture.setTranslation(.zero, in: gesture.view)
            gesture.view?.backgroundColor = randomColor
        }
        if gesture.state == .ended || gesture.state == .failed {
            // drop to floor
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.2) {
                gesture.view?.center = .init(x: self.view.center.x, y: self.view.center.y)
            }
        }
    }
}
