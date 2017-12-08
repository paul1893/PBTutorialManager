//
//  TutorialManager.swift
//  PBTutorialManager
//
//  Created by Paul Bancarel on 05/07/2016.
//  Copyright © 2016 TheFrenchTouchDeveloper. All rights reserved.
//

import Foundation
import JMHoledView

open class TutorialManager:NSObject, JMHoledViewDelegate{
    
    fileprivate var targets:[Target]? = []          // The targets to work with
    fileprivate weak var parentView:UIView!              // The parentView represents the view wich contains all the targets
    fileprivate weak var delegate:JMHoledViewDelegate?   // A delegate for the callbacks during the tutorial
    
    public init(parentView:UIView) {
        super.init()
        self.parentView = parentView
        self.delegate = self
    }
    
    /**
     Add a target
     
     - Parameters:
     - target: The target to add
     */
    open func addTarget(_ target:Target){
        targets?.append(target)
    }
    
    /**
     Fire the targets, when you have finished to set-up and add all your targets
     */
    open func fireTargets(){
        fireTargets(nil)
    }
    
    /**
     Private version of fireTargets to handle overlay of targets
     
     - Parameters:
     - onView
     */
    fileprivate func fireTargets(_ onView:UIView?){
        assert(parentView != nil, "TutorialManager: You must init TutorialManager with a parent view")
        
        if let currentTarget = targets?.first {
            if let closure  = currentTarget.closure{
                closure()
            }
            showTarget(currentTarget, onView:onView)
        }
    }
    
    /**
     Called repeteadly for each target in targets
     
     - Parameters:
     - target: The target to show
     - onView: viewToDrawIn
     */
    fileprivate func showTarget(_ target:Target, onView:UIView?){
        let mask:JMHoledView
        
        /* Should we create a new mask or not */
        if onView == nil{
            // New mask
            mask = JMHoledView(frame: self.parentView.frame)
            mask.dimingColor = UIColor.black.withAlphaComponent(0.7)
            mask.holeViewDelegate = delegate
            // Add the mask to the parentView
            parentView.addSubview(mask)
            
            // Fit the size of the mask to the size of the screen
            mask.translatesAutoresizingMaskIntoConstraints = false
            parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mask]|", options: [NSLayoutFormatOptions.alignAllCenterX, NSLayoutFormatOptions.alignAllCenterY], metrics: nil, views: ["mask":mask])) //Equal Width
            parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mask]|", options: [NSLayoutFormatOptions.alignAllCenterX, NSLayoutFormatOptions.alignAllCenterY], metrics: nil, views: ["mask":mask])) //Equal Height
            
        }else{
            // Reuse mask
            mask = onView as! JMHoledView
        }
        
        /* Position the target on the view */
        if let view = target.view{
            let holeWidth = view.frame.size.width       // With of the target
            let holeHeight = view.frame.size.height     // Height of the target
            let holeOriginX = view.frame.origin.x       // X origin of the target
            let holeOriginY = view.frame.origin.y       // Y origin of the target
            let viewCenter:CGPoint = CGPoint(x: view.frame.origin.x + parentView.frame.origin.x ,y: view.frame.origin.y + parentView.frame.origin.y)
            //let viewCenter:CGPoint = CGPointMake(view.frame.origin.x + parentView.frame.origin.x ,view.frame.origin.y + parentView.frame.origin.y + 64) /* +64 the navbar */
            let viewSize:CGSize = view.frame.size
            
            // Check the type of the target
            switch (target.shape.hashValue){
                case JMHoleType.cirle.hashValue:
                    mask.addHoleCircleCentered(onPosition: CGPoint(x: viewCenter.x+(viewSize.width/2), y: viewCenter.y+(viewSize.height/2)), diameter: holeWidth)
                    break
                case JMHoleType.rect.hashValue:
                    mask.addHoleRect(on: CGRect(x: viewCenter.x, y: viewCenter.y, width: viewSize.width, height: viewSize.height))
                    break
                case JMHoleType.roundedRect.hashValue:
                    mask.addHoleRoundedRect(on: CGRect(x: viewCenter.x, y: viewCenter.y, width: viewSize.width, height: viewSize.height), cornerRadius: 10.0)
                    break
                default:
                    break
            }
            
            // Get the properties of the target
            var label:UILabel
            let labelWidth:CGFloat = 75
            let labelHeight:CGFloat = target.message.heightWithConstrainedWidth(labelWidth, font: target.font) /* iOS 7*/
            
            var imageView:UIImageView! = UIImageView()
            
            switch (target.position.hashValue){
                case Target.TargetPosition.top.hashValue:
                    /* Illustration
                     H:[view]-[imageView]-[label]
                     V:[view]-topMargin-[imageView]-bottomTextMargin-[label] */
                    imageView = UIImageView(frame: CGRect(x: holeOriginX+(holeWidth/2)-(target.widthArrow/2), y: holeOriginY - target.heightArrow - target.topMargin, width: target.widthArrow, height: target.heightArrow))
                    imageView.image = (target.withArrow) ? loadImageFromPBTutorialBundle(name: "arrow_vertical_up"):UIImage()
                    imageView.contentMode = .scaleAspectFit
                    
                    label = UILabel(frame: CGRect(x: imageView.center.x - (labelWidth/2), y: imageView.frame.origin.y-target.bottomTextMargin-labelHeight, width: labelWidth, height: labelHeight))
                    label.textAlignment = target.textAlignement
                    break
                    
                case Target.TargetPosition.bottom.hashValue:
                    /* Illustration
                     H:[view]-[imageView]-[label]
                     V:[view]-bottomMargin-[imageView]-topTextMargin-[label] */
                    imageView = UIImageView(frame: CGRect(x: holeOriginX+(holeWidth/2)-(target.widthArrow/2), y: holeOriginY+holeHeight+target.bottomMargin, width: target.widthArrow, height: target.heightArrow))
                    imageView.image = (target.withArrow) ? loadImageFromPBTutorialBundle( name: "arrow_vertical_down"):UIImage()
                    imageView!.contentMode = .scaleAspectFit
                    
                    label = UILabel(frame: CGRect(x: imageView.center.x - (labelWidth/2), y: imageView.frame.origin.y + target.heightArrow + target.topTextMargin,width: labelWidth, height: labelHeight))
                    label.textAlignment = target.textAlignement
                    break
                    
                case Target.TargetPosition.left.hashValue:
                    /* Illustration
                     H:[label]-rightTextMargin-[imageView]-leftMargin-[view]
                     V:[label]-[imageView]-[view] */
                    imageView = UIImageView(frame: CGRect(x: holeOriginX-target.leftMargin-target.widthArrow, y: holeOriginY+(holeHeight/2)-(target.heightArrow/2),width: target.widthArrow, height: target.heightArrow))
                    imageView.image = (target.withArrow) ? loadImageFromPBTutorialBundle(name: "arrow_horizontal_left"):UIImage()
                    imageView.contentMode = .scaleAspectFit
                    
                    label = UILabel(frame: CGRect(x: imageView.frame.origin.x - target.rightTextMargin-labelWidth, y: imageView.center.y - (labelHeight/2),width: labelWidth, height: labelHeight))
                    label.textAlignment = target.textAlignement
                    break
                    
                case Target.TargetPosition.right.hashValue:
                    /* Illustration
                     H:[view]-rightMargin-[imageView]-leftTextMargin-[label]
                     V:[view]-[imageView]-[label] */
                    imageView = UIImageView(frame: CGRect(x: holeOriginX+holeWidth+target.rightMargin, y: holeOriginY+(holeHeight/2)-(target.heightArrow/2), width: target.widthArrow, height: target.heightArrow))
                    imageView.image = (target.withArrow) ? loadImageFromPBTutorialBundle(name: "arrow_horizontal_right") : UIImage()
                    imageView.contentMode = .scaleAspectFit
                    
                    label = UILabel(frame: CGRect(x: imageView.frame.origin.x+target.widthArrow + target.leftTextMargin, y: imageView.center.y - (labelHeight/2),width: labelWidth, height: labelHeight))
                    label.textAlignment = target.textAlignement
                    break
                    
                case Target.TargetPosition.topLeft.hashValue:
                    /* Illustration
                     H:[label]-rightTextMargin-[imageView]-leftMargin-[view]
                     V:[view]-topMargin-[imageView]-bottomTextMargin-[label] */
                    imageView = UIImageView(frame: CGRect(x: holeOriginX-target.leftMargin-target.widthArrow, y: holeOriginY-target.topMargin-target.heightArrow, width: target.widthArrow, height: target.heightArrow))
                    imageView.image = (target.withArrow) ? loadImageFromPBTutorialBundle(name: "arrow_top_left"):UIImage()
                    imageView.contentMode = .scaleAspectFit
                    
                    label = UILabel(frame: CGRect(x: imageView.frame.origin.x-target.rightTextMargin-labelWidth, y: imageView.frame.origin.y-target.bottomTextMargin-(labelHeight/2),width: labelWidth, height: labelHeight))
                    label.textAlignment = target.textAlignement
                    break
                    
                case Target.TargetPosition.topRight.hashValue:
                    /* Illustration
                     H:[view]-rightMargin-[imageView]-leftTextMargin-[label]
                     V:[view]-topMargin-[imageView]-bottomTextMargin-[label] */
                    imageView = UIImageView(frame: CGRect(x: holeOriginX+holeWidth+target.rightMargin, y: holeOriginY-target.topMargin-target.heightArrow, width: target.widthArrow, height: target.heightArrow))
                    imageView.image = (target.withArrow) ? loadImageFromPBTutorialBundle(name: "arrow_top_right"):UIImage()
                    imageView.contentMode = .scaleAspectFit
                    
                    label = UILabel(frame: CGRect(x: imageView.frame.origin.x+target.widthArrow + target.leftTextMargin, y: imageView.frame.origin.y-target.bottomTextMargin - (labelHeight/2),width: labelWidth, height: labelHeight))
                    label.textAlignment = target.textAlignement
                    break
                    
                case Target.TargetPosition.bottomLeft.hashValue:
                    /* Illustration
                     H:[label]-rightTextMargin-[imageView]-leftMargin-[view]
                     V:[view]-bottomMargin-[imageView]-topTextMargin-[label] */
                    imageView = UIImageView(frame: CGRect(x: holeOriginX-target.leftMargin-target.widthArrow, y: holeOriginY+holeHeight+target.bottomMargin, width: target.widthArrow, height: target.heightArrow))
                    imageView.image = (target.withArrow) ? loadImageFromPBTutorialBundle(name: "arrow_bottom_left"):UIImage()
                    imageView.contentMode = .scaleAspectFit
                    
                    label = UILabel(frame: CGRect(x: imageView.frame.origin.x-target.rightTextMargin-labelWidth, y: imageView.frame.origin.y+target.heightArrow+target.topTextMargin-(labelHeight/2),width: labelWidth, height: labelHeight))
                    label.textAlignment = target.textAlignement
                    break
                    
                case Target.TargetPosition.bottomRight.hashValue:
                    /* Illustration
                     H:[view]-rightMargin-[imageView]-leftTextMargin-[label]
                     V:[view]-bottomMargin-[imageView]-topTextMargin-[label] */
                    imageView = UIImageView(frame: CGRect(x: holeOriginX+holeWidth+target.rightMargin, y: holeOriginY+holeHeight+target.bottomMargin, width: target.widthArrow, height: target.heightArrow))
                    imageView.image = (target.withArrow) ? loadImageFromPBTutorialBundle(name: "arrow_bottom_right"):UIImage()
                    imageView.contentMode = .scaleAspectFit
                    
                    label = UILabel(frame: CGRect(x: imageView.frame.origin.x+target.widthArrow + target.leftTextMargin, y: imageView.frame.origin.y + target.heightArrow+target.topTextMargin, width: labelWidth, height: labelHeight))
                    label.textAlignment = target.textAlignement
                    break
                    
                default:
                    label = UILabel(frame: CGRect(x: 0, y: 0,width: labelWidth, height: labelHeight))
                    break
            }
            
            label.numberOfLines = 0
            label.textColor = UIColor.white
            label.font = target.font
            label.text = target.message
            
            // Add an arrow if the user as ask for one
            if target.withArrow {mask.addSubview(imageView!)}
            mask.addSubview(label)
            
            if let duration = target.duration, !target.breakPoint{
                
                // Delay execution of my block for duration
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(duration * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                    //If not persistent disappear before the next mask appear
                    if target.persistant == false {
                        mask.removeHoles()
                        imageView?.isHidden = true
                        label.isHidden = true
                    }
                    self.targets?.removeFirst()
                    self.fireTargets(mask)
                })
        
            }
        }
    }
    
    /**
     When a target's view is touched
     */
    open func holedView(_ holedView:JMHoledView, didSelectHoleAt didSelectHoleAtIndex:UInt){
        print("Callback holedView")
        if let target = targets?.first, target.isTapable {
            holedView.removeFromSuperview()
            targets?.removeFirst()
            fireTargets()
        }
        if(targets!.count <= 0){
            holedView.removeFromSuperview()
        }
    }
}

/**
 Acces the ressource of the pod bundle
 - Parameters:
 - name: The name of the ressource image
 
 - Return:
 - image
 */
fileprivate func loadImageFromPBTutorialBundle(name:String) -> UIImage?{
    let podBundle = Bundle(for: TutorialManager.self)
    
    // 'PBTutorialManager' is the name specified for the pod bundle in the podspec
    if let url = podBundle.url(forResource: "PBTutorialManager", withExtension: "bundle") {
        let bundle = Bundle(url: url)
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    // If the user imported the library without cocoa pod, images directly in the assets
    return UIImage(named: name)
}

extension String {
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
