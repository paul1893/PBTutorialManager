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
    fileprivate weak var parentView:          UIView!               // The parentView represents the view wich contains all the targets
    private     weak var mask:                HoledView?
    private          var removableConstraints = [NSLayoutConstraint]()
    
    public init(parentView: UIView) {
        super.init()
        self.parentView = parentView
    }
    
    /**
     Add a target
     
     - Parameters:
     - target: The target to add
     */
    open func addTarget(_ target: TutorialTarget) {
        targets.append(target)
    }
    
    /**
     Fire the targets, when you have finished to set-up and add all your targets
     */
    open func fireTargets() {
        assert(parentView != nil, "TutorialManager: You must init TutorialManager with a parent view")
        
        if let currentTarget = targets.first {
            if let closure  = currentTarget.closure {
                closure()
            }
            showTarget(currentTarget)
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
            mask             = HoledView(frame: parentView.frame)
            self.mask        = mask
            mask.tapListener = tapped
            parentView.addSubview(mask)
            
            // Fit the size of the mask to the size of the screen
            mask.translatesAutoresizingMaskIntoConstraints = false
            parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mask]|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["mask":mask])) //Equal Width
            parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mask]|", options: [.alignAllCenterX, .alignAllCenterY], metrics: nil, views: ["mask":mask])) //Equal Height
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
            var arrow:AFCurvedArrowView?
            var constraints = [NSLayoutConstraint]()
        
            switch target.position {
            case .top:
                /* Illustration
                 H:[view]-[arrowView]-[label]
                 V:[view]-topMargin-[arrowView]-bottomTextMargin-[label] */
                arrow = AFCurvedArrowView()
                arrow!.arrowTail = CGPoint(x: 0.5, y: 0.05)
                arrow!.arrowHead = CGPoint(x: 0.5, y: 0.95)
                arrow!.controlPoint1 = CGPoint(x: 0.8, y: 0.4)
                arrow!.controlPoint2 = CGPoint(x: 0.2, y: 0.6)
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .centerX, relatedBy: .equal,
                                                      toItem: view,   attribute: .centerX, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .bottom,  relatedBy: .equal,
                                                      toItem: view,   attribute: .top,     multiplier: 1, constant: target.topMargin))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .centerX, relatedBy: .equal,
                                                      toItem: arrow!, attribute: .centerX, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .bottom,  relatedBy: .equal,
                                                      toItem: arrow!, attribute: .top,     multiplier: 1, constant: target.bottomTextMargin))
                
            case .bottom:
                /* Illustration
                 H:[view]-[arrowView]-[label]
                 V:[view]-bottomMargin-[arrowView]-topTextMargin-[label] */
                arrow = AFCurvedArrowView()
                arrow!.arrowTail = CGPoint(x: 0.5, y: 0.95)
                arrow!.arrowHead = CGPoint(x: 0.5, y: 0.05)
                arrow!.controlPoint1 = CGPoint(x: 0.2, y: 0.6)
                arrow!.controlPoint2 = CGPoint(x: 0.8, y: 0.4)
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .centerX, relatedBy: .equal,
                                                      toItem: view,   attribute: .centerX, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .top,     relatedBy: .equal,
                                                      toItem: view,   attribute: .bottom,  multiplier: 1, constant: target.bottomMargin))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .centerX, relatedBy: .equal,
                                                      toItem: arrow!, attribute: .centerX, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .top,     relatedBy: .equal,
                                                      toItem: arrow!, attribute: .bottom,  multiplier: 1, constant: target.topTextMargin))
                
            case .left:
                /* Illustration
                 H:[label]-rightTextMargin-[arrowView]-leftMargin-[view]
                 V:[label]-[arrowView]-[view] */
                arrow = AFCurvedArrowView()
                arrow!.arrowTail = CGPoint(x: 0.05, y: 0.5)
                arrow!.arrowHead = CGPoint(x: 0.95, y: 0.5)
                arrow!.controlPoint1 = CGPoint(x: 0.5, y: 1.0)
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .centerY, relatedBy: .equal,
                                                      toItem: view,   attribute: .centerY, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .right,   relatedBy: .equal,
                                                      toItem: view,   attribute: .left,    multiplier: 1, constant: target.leftMargin))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .centerY, relatedBy: .equal,
                                                      toItem: arrow!, attribute: .centerY, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .right,   relatedBy: .equal,
                                                      toItem: arrow!, attribute: .left,    multiplier: 1, constant: target.rightTextMargin))
                
            case .right:
                /* Illustration
                 H:[view]-rightMargin-[arrowView]-leftTextMargin-[label]
                 V:[view]-[arrowView]-[label] */
                arrow = AFCurvedArrowView()
                arrow!.arrowTail = CGPoint(x: 0.95, y: 0.5)
                arrow!.arrowHead = CGPoint(x: 0.05, y: 0.5)
                arrow!.controlPoint1 = CGPoint(x: 0.5, y: 0.0)
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .centerY, relatedBy: .equal,
                                                      toItem: view,   attribute: .centerY, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .left,    relatedBy: .equal,
                                                      toItem: view,   attribute: .right,   multiplier: 1, constant: target.rightMargin))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .centerY, relatedBy: .equal,
                                                      toItem: arrow!, attribute: .centerY, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .left,    relatedBy: .equal,
                                                      toItem: arrow!, attribute: .right,   multiplier: 1, constant: target.leftTextMargin))
                
            case .topLeft:
                /* Illustration
                 H:[label]-rightTextMargin-[arrowView]-leftMargin-[view]
                 V:[view]-topMargin-[arrowView]-bottomTextMargin-[label] */
                arrow = AFCurvedArrowView()
                arrow!.arrowTail = CGPoint(x: 0.05, y: 0.05)
                arrow!.arrowHead = CGPoint(x: 0.95, y: 0.95)
                arrow!.controlPoint1 = CGPoint(x: 0.8, y: 0.2)
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .bottom, relatedBy: .equal,
                                                      toItem: view,   attribute: .top,    multiplier: 1, constant: target.topMargin))
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .right,  relatedBy: .equal,
                                                      toItem: view,   attribute: .left,   multiplier: 1, constant: target.leftMargin))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .bottom, relatedBy: .equal,
                                                      toItem: arrow!, attribute: .top,    multiplier: 1, constant: target.bottomTextMargin))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .right,  relatedBy: .equal,
                                                      toItem: arrow,  attribute: .left,   multiplier: 1, constant: target.rightTextMargin))
                
            case .topRight:
                /* Illustration
                 H:[view]-rightMargin-[arrowView]-leftTextMargin-[label]
                 V:[view]-topMargin-[arrowView]-bottomTextMargin-[label] */
                arrow = AFCurvedArrowView()
                arrow!.arrowTail = CGPoint(x: 0.95, y: 0.05)
                arrow!.arrowHead = CGPoint(x: 0.05, y: 0.95)
                arrow!.controlPoint1 = CGPoint(x: 0.2, y: 0.2)
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .bottom, relatedBy: .equal,
                                                      toItem: view,   attribute: .top,    multiplier: 1, constant: target.topMargin))
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .left,   relatedBy: .equal,
                                                      toItem: view,   attribute: .right,  multiplier: 1, constant: target.rightMargin))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .bottom, relatedBy: .equal,
                                                      toItem: arrow!, attribute: .top,    multiplier: 1, constant: target.bottomTextMargin))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .left,   relatedBy: .equal,
                                                      toItem: arrow!, attribute: .right,  multiplier: 1, constant: target.leftTextMargin))
                
            case .bottomLeft:
                /* Illustration
                 H:[label]-rightTextMargin-[arrowView]-leftMargin-[view]
                 V:[view]-bottomMargin-[arrowView]-topTextMargin-[label] */
                arrow = AFCurvedArrowView()
                arrow!.arrowTail = CGPoint(x: 0.05, y: 0.95)
                arrow!.arrowHead = CGPoint(x: 0.95, y: 0.05)
                arrow!.controlPoint1 = CGPoint(x: 0.8, y: 0.8)
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .top,    relatedBy: .equal,
                                                      toItem: view,   attribute: .bottom, multiplier: 1, constant: target.bottomMargin))
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .right,  relatedBy: .equal,
                                                      toItem: view,   attribute: .left,   multiplier: 1, constant: target.leftMargin))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .top,    relatedBy: .equal,
                                                      toItem: arrow!, attribute: .bottom, multiplier: 1, constant: target.topTextMargin))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .right,  relatedBy: .equal,
                                                      toItem: arrow!, attribute: .left,   multiplier: 1, constant: target.leftTextMargin))
                
            case .bottomRight:
                /* Illustration
                 H:[view]-rightMargin-[arrowView]-leftTextMargin-[label]
                 V:[view]-bottomMargin-[arrowView]-topTextMargin-[label] */
                arrow = AFCurvedArrowView()
                arrow!.arrowTail = CGPoint(x: 0.95, y: 0.95)
                arrow!.arrowHead = CGPoint(x: 0.05, y: 0.05)
                arrow!.controlPoint1 = CGPoint(x: 0.2, y: 0.8)
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .top,    relatedBy: .equal,
                                                      toItem: view,   attribute: .bottom, multiplier: 1, constant: target.bottomMargin))
                constraints.append(NSLayoutConstraint(item: arrow!,   attribute: .left,   relatedBy: .equal,
                                                      toItem: view,   attribute: .right,  multiplier: 1, constant: target.rightMargin))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .top,    relatedBy: .equal,
                                                      toItem: arrow!, attribute: .bottom, multiplier: 1, constant: target.topTextMargin))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .left,   relatedBy: .equal,
                                                      toItem: arrow!, attribute: .right,  multiplier: 1, constant: target.leftTextMargin))
                
            case .centre:
                constraints.append(NSLayoutConstraint(item: label,    attribute: .centerX, relatedBy: .equal,
                                                      toItem: view,   attribute: .centerX, multiplier: 1, constant: 0))
                constraints.append(NSLayoutConstraint(item: label,    attribute: .centerY, relatedBy: .equal,
                                                      toItem: view,   attribute: .centerY, multiplier: 1, constant: 0))
            }
            
            // Setup the label attributes
            label.numberOfLines = 0
            label.textColor = UIColor.white
            label.font = target.font
            label.text = target.message
            label.textAlignment = target.textAlignement
            label.translatesAutoresizingMaskIntoConstraints = false
            let labelHeight = target.message.heightWithConstrainedWidth(target.labelWidth, font: target.font) /* iOS 7*/
            constraints.append(NSLayoutConstraint(item: label, attribute: .height,         relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: labelHeight))
            constraints.append(NSLayoutConstraint(item: label, attribute: .width,          relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: target.labelWidth))
            
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
            parentView.addConstraints(constraints)
            
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
        parentView.removeConstraints(removableConstraints)
        removableConstraints.removeAll()
        if let target = targets.first, target.isTappable || target.breakPoint {
            mask?.removeFromSuperview()
            mask = nil
            targets.removeFirst()
            fireTargets()
        }
        if targets.isEmpty {
            mask?.removeFromSuperview()
        }
    }
}


fileprivate extension String {
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return boundingBox.height
    }
}
