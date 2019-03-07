//
//  TutorialManager.swift
//  PBTutorialManager
//
//  Created by Paul Bancarel on 05/07/2016.
//  Copyright © 2016 TheFrenchTouchDeveloper. All rights reserved.
//

import Foundation
import AFCurvedArrowView


open class TutorialManager: NSObject {
    fileprivate      var targets:             [TutorialTarget] = [] // The targets to work with
    fileprivate weak var parent:              UIView!               // The window/view represents which contains all the targets
    private     weak var mask:                HoledView?
    private          var fadeInDelay:         TimeInterval?
    private          var tutorialComplete:    (() -> Void)?
    private          var removableConstraints = [NSLayoutConstraint]()
    
    public init(parent: UIView, fadeInDelay: TimeInterval? = nil, tutorialComplete: (() -> Void)? = nil) {
        self.fadeInDelay      = fadeInDelay
        self.parent           = parent
        self.tutorialComplete = tutorialComplete
        super.init()
    }
    
    /**
     Add a target
     
     - Parameters:
     - target: The target to add
     */
    open func addTarget(_ target: TutorialTarget) {
        targets.append(target)
    }
    
    open func addTargets(_ targets: [TutorialTarget]) {
        self.targets.append(contentsOf: targets)
    }
    
    /**
     Fire the targets, when you have finished to set-up and add all your targets
     */
    open func fireTargets() {
        guard parent != nil else {
            tutorialComplete?()
            return
        }
        
        if let currentTarget = targets.first {
            if let closure  = currentTarget.closure {
                closure()
            }
            showTarget(currentTarget)
        } else {
            tutorialComplete?()
        }
    }
    
    /**
     Called repeteadly for each target in targets
     
     - Parameters:
     - target: The target to show
     - onView: viewToDrawIn
     */
    fileprivate func showTarget(_ target: TutorialTarget) {
        let mask: HoledView
        
        /* Should we create a new mask or not */
        if let classMask = self.mask {
            // Reuse mask
            mask = classMask
        } else {
            // New mask and add it to the parentView
            mask             = HoledView(frame: parent.frame)
            self.mask        = mask
            mask.tapListener = tapped
            parent.addSubview(mask)
            
            // Fade in the holed view. Only fade in on the first display
            if let delay = fadeInDelay {
                fadeInDelay = nil
                mask.alpha  = 0
                UIView.animate(withDuration: delay) {
                    mask.alpha = 1
                }
            }
            
            // Fit the size of the mask to the size of the screen
            mask.translatesAutoresizingMaskIntoConstraints = false
            parent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mask]|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["mask":mask])) //Equal Width
            parent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mask]|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["mask":mask])) //Equal Height
        }
        
        /* Position the target on the view */
        if let view = target.view {
            // Check the type of the target
            switch target.shape {
            case .elipse?:
                mask.addElipse(view: view)
            case .rect?:
                mask.addRectHole(view: view)
            case .roundedRect?:
                mask.addRectHole(view: view, cornerRadius: 10)
            default:
                ()
            }
            
            // Get the properties of the target
            let label = UILabel()
            let arrow = target.position != .centre ? AFCurvedArrowView() : nil
            let arrowHeadX: NSLayoutConstraint.Attribute
            let arrowHeadY: NSLayoutConstraint.Attribute
            var constraints = [NSLayoutConstraint]()
        
            // Now setup the arrow direction
            if let arrow = arrow {
                switch target.arrowStartPosition ?? target.position {
                case .top:
                    arrow.arrowTail = CGPoint(x: 0.5, y: 0.05)
                    arrow.arrowHead = CGPoint(x: 0.5, y: 0.95)
                    arrow.controlPoint1 = CGPoint(x: 0.8, y: 0.4)
                    arrow.controlPoint2 = CGPoint(x: 0.2, y: 0.6)
                    arrowHeadX = .centerX
                    arrowHeadY = .bottom
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .centerX, relatedBy: .equal,
                                                          toItem: arrow, attribute: .centerX, multiplier: 1, constant: target.leftTextMargin - target.rightTextMargin))
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .bottom,  relatedBy: .equal,
                                                          toItem: arrow, attribute: .top,     multiplier: 1, constant: target.bottomTextMargin))
                    
                case .bottom:
                    arrow.arrowTail = CGPoint(x: 0.5, y: 0.95)
                    arrow.arrowHead = CGPoint(x: 0.5, y: 0.05)
                    arrow.controlPoint1 = CGPoint(x: 0.2, y: 0.6)
                    arrow.controlPoint2 = CGPoint(x: 0.8, y: 0.4)
                    arrowHeadX = .centerX
                    arrowHeadY = .top
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .centerX, relatedBy: .equal,
                                                          toItem: arrow, attribute: .centerX, multiplier: 1, constant: target.leftTextMargin - target.rightTextMargin))
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .top,     relatedBy: .equal,
                                                          toItem: arrow, attribute: .bottom,  multiplier: 1, constant: target.topTextMargin))
                    
                case .left:
                    arrow.arrowTail = CGPoint(x: 0.05, y: 0.5)
                    arrow.arrowHead = CGPoint(x: 0.95, y: 0.5)
                    arrow.controlPoint1 = CGPoint(x: 0.5, y: 1.0)
                    arrowHeadX = .right
                    arrowHeadY = .centerY
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .right,   relatedBy: .equal,
                                                          toItem: arrow, attribute: .left,    multiplier: 1, constant: target.rightTextMargin))
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .centerY, relatedBy: .equal,
                                                          toItem: arrow, attribute: .centerY, multiplier: 1, constant: target.topTextMargin - target.bottomTextMargin))
                    
                case .right:
                    arrow.arrowTail = CGPoint(x: 0.95, y: 0.5)
                    arrow.arrowHead = CGPoint(x: 0.05, y: 0.5)
                    arrow.controlPoint1 = CGPoint(x: 0.5, y: 0.0)
                    arrowHeadX = .left
                    arrowHeadY = .centerY
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .left,    relatedBy: .equal,
                                                          toItem: arrow, attribute: .right,   multiplier: 1, constant: target.leftTextMargin))
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .centerY, relatedBy: .equal,
                                                          toItem: arrow, attribute: .centerY, multiplier: 1, constant: target.topTextMargin - target.bottomTextMargin))
                    
                case .topLeft:
                    arrow.arrowTail = CGPoint(x: 0.05, y: 0.05)
                    arrow.arrowHead = CGPoint(x: 0.95, y: 0.95)
                    arrow.controlPoint1 = CGPoint(x: 0.8, y: 0.2)
                    arrowHeadX = .right
                    arrowHeadY = .bottom
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .right,  relatedBy: .equal,
                                                          toItem: arrow, attribute: .left,   multiplier: 1, constant: target.rightTextMargin))
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .bottom, relatedBy: .equal,
                                                          toItem: arrow, attribute: .top,    multiplier: 1, constant: target.bottomTextMargin))
                    
                case .topRight:
                    arrow.arrowTail = CGPoint(x: 0.95, y: 0.05)
                    arrow.arrowHead = CGPoint(x: 0.05, y: 0.95)
                    arrow.controlPoint1 = CGPoint(x: 0.2, y: 0.2)
                    arrowHeadX = .left
                    arrowHeadY = .bottom
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .left,   relatedBy: .equal,
                                                          toItem: arrow, attribute: .right,  multiplier: 1, constant: target.leftTextMargin))
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .bottom, relatedBy: .equal,
                                                          toItem: arrow, attribute: .top,    multiplier: 1, constant: target.bottomTextMargin))
                    
                case .bottomLeft:
                    arrow.arrowTail = CGPoint(x: 0.05, y: 0.95)
                    arrow.arrowHead = CGPoint(x: 0.95, y: 0.05)
                    arrow.controlPoint1 = CGPoint(x: 0.8, y: 0.8)
                    arrowHeadX = .right
                    arrowHeadY = .top
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .right,  relatedBy: .equal,
                                                          toItem: arrow, attribute: .left,   multiplier: 1, constant: target.leftTextMargin))
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .top,    relatedBy: .equal,
                                                          toItem: arrow, attribute: .bottom, multiplier: 1, constant: target.topTextMargin))
                    
                case .bottomRight:
                    arrow.arrowTail = CGPoint(x: 0.95, y: 0.95)
                    arrow.arrowHead = CGPoint(x: 0.05, y: 0.05)
                    arrow.controlPoint1 = CGPoint(x: 0.2, y: 0.8)
                    arrowHeadX = .left
                    arrowHeadY = .top
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .left,   relatedBy: .equal,
                                                          toItem: arrow, attribute: .right,  multiplier: 1, constant: target.leftTextMargin))
                    constraints.append(NSLayoutConstraint(item: label,   attribute: .top,    relatedBy: .equal,
                                                          toItem: arrow, attribute: .bottom, multiplier: 1, constant: target.topTextMargin))
                    
                case .centre:
                    assertionFailure("Centre possition isn't valid for the arrow start point")
                    arrowHeadX = .notAnAttribute
                    arrowHeadY = .notAnAttribute
                }
            } else {
                arrowHeadX = .notAnAttribute
                arrowHeadY = .notAnAttribute
            }
            
            switch target.position {
            case .top:
                /* Illustration
                 H:[view]-[arrowView]-[label]
                 V:[view]-topMargin-[arrowView]-bottomTextMargin-[label] */
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadX, relatedBy: .equal,
                                                      toItem: view, attribute: .centerX,   multiplier: 1, constant: target.leftMargin - target.rightMargin))
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadY, relatedBy: .equal,
                                                      toItem: view, attribute: .top,       multiplier: 1, constant: target.topMargin))
                
            case .bottom:
                /* Illustration
                 H:[view]-[arrowView]-[label]
                 V:[view]-bottomMargin-[arrowView]-topTextMargin-[label] */
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadX, relatedBy: .equal,
                                                      toItem: view, attribute: .centerX,   multiplier: 1, constant: target.leftMargin - target.rightMargin))
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadY, relatedBy: .equal,
                                                      toItem: view, attribute: .bottom,    multiplier: 1, constant: target.bottomMargin))
                
            case .left:
                /* Illustration
                 H:[label]-rightTextMargin-[arrowView]-leftMargin-[view]
                 V:[label]-[arrowView]-[view] */
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadX, relatedBy: .equal,
                                                      toItem: view, attribute: .left,      multiplier: 1, constant: target.leftMargin))
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadY, relatedBy: .equal,
                                                      toItem: view, attribute: .centerY,   multiplier: 1, constant: target.topMargin - target.bottomMargin))
                
            case .right:
                /* Illustration
                 H:[view]-rightMargin-[arrowView]-leftTextMargin-[label]
                 V:[view]-[arrowView]-[label] */
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadX, relatedBy: .equal,
                                                      toItem: view, attribute: .right,     multiplier: 1, constant: target.rightMargin))
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadY, relatedBy: .equal,
                                                      toItem: view, attribute: .centerY,   multiplier: 1, constant: target.topMargin - target.bottomMargin))
                
            case .topLeft:
                /* Illustration
                 H:[label]-rightTextMargin-[arrowView]-leftMargin-[view]
                 V:[view]-topMargin-[arrowView]-bottomTextMargin-[label] */
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadX, relatedBy: .equal,
                                                      toItem: view, attribute: .left,      multiplier: 1, constant: target.leftMargin))
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadY, relatedBy: .equal,
                                                      toItem: view, attribute: .top,       multiplier: 1, constant: target.topMargin))
                
            case .topRight:
                /* Illustration
                 H:[view]-rightMargin-[arrowView]-leftTextMargin-[label]
                 V:[view]-topMargin-[arrowView]-bottomTextMargin-[label] */
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadX, relatedBy: .equal,
                                                      toItem: view, attribute: .right,     multiplier: 1, constant: target.rightMargin))
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadY, relatedBy: .equal,
                                                      toItem: view, attribute: .top,       multiplier: 1, constant: target.topMargin))
                
            case .bottomLeft:
                /* Illustration
                 H:[label]-rightTextMargin-[arrowView]-leftMargin-[view]
                 V:[view]-bottomMargin-[arrowView]-topTextMargin-[label] */
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadX, relatedBy: .equal,
                                                      toItem: view, attribute: .left,      multiplier: 1, constant: target.leftMargin))
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadY, relatedBy: .equal,
                                                      toItem: view, attribute: .bottom,    multiplier: 1, constant: target.bottomMargin))
                
            case .bottomRight:
                /* Illustration
                 H:[view]-rightMargin-[arrowView]-leftTextMargin-[label]
                 V:[view]-bottomMargin-[arrowView]-topTextMargin-[label] */
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadX, relatedBy: .equal,
                                                      toItem: view, attribute: .right,     multiplier: 1, constant: target.rightMargin))
                constraints.append(NSLayoutConstraint(item: arrow!, attribute: arrowHeadY, relatedBy: .equal,
                                                      toItem: view, attribute: .bottom,    multiplier: 1, constant: target.bottomMargin))
                
            case .centre:
                constraints.append(NSLayoutConstraint(item: label,    attribute: .centerX, relatedBy: .equal,
                                                      toItem: view,   attribute: .centerX, multiplier: 1, constant: target.leftTextMargin - target.rightTextMargin))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .centerY, relatedBy: .equal,
                                                      toItem: view,   attribute: .centerY, multiplier: 1, constant: target.topTextMargin - target.bottomTextMargin))
            }
            
            
            // Setup the label attributes
            label.numberOfLines = 0
            label.textColor = UIColor.white
            label.font = target.font
            label.text = target.message
            label.textAlignment = target.textAlignement
            label.lineBreakMode = .byWordWrapping
            label.translatesAutoresizingMaskIntoConstraints = false
            // Add a max width constraint to the label. We leave the height unconstrained so it can
            // expand to fit the text as required
            constraints.append(NSLayoutConstraint(item: label, attribute: .width,          relatedBy:  .lessThanOrEqual,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: target.labelWidth))
            // Now make sure the label doesn't go outside the parent
            constraints.append(NSLayoutConstraint(item: label,     attribute: .leading,  relatedBy:  .greaterThanOrEqual,
                                                   toItem: parent, attribute: .leading,  multiplier: 1, constant: 0))
            constraints.append(NSLayoutConstraint(item: parent,    attribute: .trailing, relatedBy:  .greaterThanOrEqual,
                                                  toItem: label,   attribute: .trailing, multiplier: 1, constant: 0))

            // Add an arrow if the user as ask for one
            if target.withArrow, let arrowView = arrow {
                arrowView.arrowHeadHeight = target.arrowHeadSize
                arrowView.arrowHeadWidth = target.arrowHeadSize
                arrowView.curveType = .quadratic
                arrowView.translatesAutoresizingMaskIntoConstraints = false
                constraints.append(NSLayoutConstraint(item: arrowView, attribute: .height,         relatedBy: .equal,
                                                      toItem: nil,     attribute: .notAnAttribute, multiplier: 1, constant: target.heightArrow))
                constraints.append(NSLayoutConstraint(item: arrowView, attribute: .width,          relatedBy: .equal,
                                                      toItem: nil,     attribute: .notAnAttribute, multiplier: 1, constant: target.widthArrow))
                mask.addSubview(arrowView)
            }
            mask.addSubview(label)
            removableConstraints.append(contentsOf: constraints)
            parent.addConstraints(constraints)
            
            let handleNextTarget = {
                //If not persistent disappear before the next mask appear
                if target.persistant == false {
                    mask.removeHoles()
                    arrow?.isHidden = true
                    label.isHidden = true
                }
                self.targets.removeFirst()
                self.fireTargets()
            }
            
            if !target.breakPoint {
                if let duration = target.duration {
                    // Delay execution of my block for duration
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                        handleNextTarget()
                    }
                } else {
                    handleNextTarget()
                }
            }
        }
    }
    
    /**
     When a target's view is touched
     */
    private func tapped() {
        let removeMask = {
            self.mask?.removeFromSuperview()
            self.mask = nil
            self.parent.removeConstraints(self.removableConstraints)
            self.removableConstraints.removeAll()
        }
        if let target = targets.first, target.isTappable || target.breakPoint {
            removeMask()
            targets.removeFirst()
            fireTargets()
        }
        if targets.isEmpty {
            removeMask()
            fireTargets()
        }
    }
}

