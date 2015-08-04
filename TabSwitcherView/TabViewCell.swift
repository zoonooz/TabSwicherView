//
//  TabViewCell.swift
//  TabSwitcherViewDemo
//
//  Created by Amornchai Kanokpullwad on 7/26/2558 BE.
//  Copyright (c) 2558 zoonref. All rights reserved.
//

import UIKit

class TabViewCell: UICollectionViewCell {

    let displayView: UIView
    let gradientView: UIView
    
    private var currentTransform: CATransform3D?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        displayView = UIView(frame: CGRectMake(0, 0,
            UIScreen.mainScreen().bounds.size.width,
            UIScreen.mainScreen().bounds.size.height))
        gradientView = UIView(frame: displayView.bounds)
        
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor.clearColor()
        
        displayView.backgroundColor = UIColor.whiteColor()
        layer.rasterizationScale = UIScreen.mainScreen().scale
        layer.shouldRasterize = true
        displayView.layer.frame = displayView.bounds
        
        contentView.addSubview(displayView)
        setAnchorPoint(CGPointMake(0.5, 0), forView: displayView)
        
        // test button
        let button = UIButton(frame: CGRectMake(200, 50, 100, 50))
        button.setTitle("test", forState: .Normal)
        button.addTarget(self, action: "test", forControlEvents: UIControlEvents.TouchUpInside)
        displayView.addSubview(button)
        
        // setup gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = displayView.bounds
        gradientLayer.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
        gradientView.layer.addSublayer(gradientLayer)
        displayView.addSubview(gradientView)
        
        // add motion effect
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "layer.transform",
            type: .TiltAlongVerticalAxis)
        
        var tranformMinRelative = CATransform3DIdentity
        tranformMinRelative = CATransform3DRotate(tranformMinRelative, CGFloat(M_PI / 10), 1, 0, 0);
        
        var tranformMaxRelative = CATransform3DIdentity
        tranformMaxRelative = CATransform3DRotate(tranformMaxRelative, CGFloat(-M_PI / 10), 1, 0, 0);
        
        verticalMotionEffect.minimumRelativeValue = NSValue(CATransform3D: tranformMinRelative)
        verticalMotionEffect.maximumRelativeValue = NSValue(CATransform3D: tranformMaxRelative)
        
        displayView.addMotionEffect(verticalMotionEffect)
        
        // add pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        gesture.delegate = self
        displayView.addGestureRecognizer(gesture)
    }
    
    func test() {
        print("test")
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .Changed:
            let translation = recognizer.translationInView(displayView)
            let transform = displayView.layer.transform
            displayView.layer.transform = CATransform3DTranslate(transform, translation.x, 0, 0)
            recognizer.setTranslation(CGPointZero, inView: displayView)
            
        case .Cancelled, .Ended:
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if let transform = self.currentTransform {
                    self.displayView.layer.transform = transform
                }
            })
        default: break
        }
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        if let attr = layoutAttributes as? TabSwitcherLayoutAttributes {
            displayView.layer.transform = attr.displayTransform
            currentTransform = attr.displayTransform
        }
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
            view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
            view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
}

extension TabViewCell: UIGestureRecognizerDelegate {
    
    // fix hard to scroll vertically
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = pan.velocityInView(displayView)
            return fabs(velocity.x) > fabs(velocity.y);
        }
        return true
    }
    
}
