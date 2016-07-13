//
//  TutorialManager.swift
//  PBTutorialManager
//
//  Created by Paul Bancarel on 05/07/2016.
//  Copyright © 2016 TheFrenchTouchDeveloper. All rights reserved.
//

import Foundation
import JMHoledView

class TutorialManager:NSObject, JMHoledViewDelegate{
    
    private var targets:[Target]? = []
    private var parentView:UIView!
    private var delegate:JMHoledViewDelegate?
    
    
    init(parentView:UIView) {
        super.init()
        self.parentView = parentView
        self.delegate = self
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
//    func orientationChanged(notification:NSNotification){
//        print("orientation Changed")
//        for view in parentView.subviews{
//            view.setNeedsDisplay()
//        }
//    }
    
    func addTarget(target:Target){
        targets?.append(target)
    }
    
    func fireTargets(){
        fireTargets(nil)
    }
    
    private func fireTargets(onView:UIView?){
        assert(parentView != nil, "TutorialManager: You must init TutorialManager with a parent view")
        
        if let currentTarget = targets?.first {
            if let closure  = currentTarget.closure{
                closure()
            }
            showTarget(currentTarget, onView:onView)
        }
    }
    
    private func showTarget(target:Target, onView:UIView?){
        let mask:JMHoledView
        /* Should we create a new mask or not */
        if onView == nil{
            // New mask
            mask = JMHoledView(frame: self.parentView.frame)
            mask.dimingColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
            mask.holeViewDelegate = delegate
            parentView.addSubview(mask)
            
            mask.translatesAutoresizingMaskIntoConstraints = false
            //Equal Width
            parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mask]|", options: [NSLayoutFormatOptions.AlignAllCenterX, NSLayoutFormatOptions.AlignAllCenterY], metrics: nil, views: ["mask":mask]))
            //Equal Height
            parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mask]|", options: [NSLayoutFormatOptions.AlignAllCenterX, NSLayoutFormatOptions.AlignAllCenterY], metrics: nil, views: ["mask":mask]))
            
        }else{
            // Reuse mask
            mask = onView as! JMHoledView
            
        }
        
        if let view = target.view{
            let holeWidth = view.frame.size.width
            let holeHeight = view.frame.size.height
            let holeOriginX = view.frame.origin.x
            let holeOriginY = view.frame.origin.y
            
            let viewCenter:CGPoint = CGPointMake(view.frame.origin.x + parentView.frame.origin.x ,view.frame.origin.y + parentView.frame.origin.y)
            //            let viewCenter:CGPoint = CGPointMake(view.frame.origin.x + parentView.frame.origin.x ,view.frame.origin.y + parentView.frame.origin.y + 64) /* +64 the navbar */
            let viewSize:CGSize = view.frame.size
            
            switch (target.shape.hashValue){
            case JMHoleType.Cirle.hashValue:
                mask.addHoleCircleCenteredOnPosition(CGPointMake(viewCenter.x+(viewSize.width/2), viewCenter.y+(viewSize.height/2)), andDiameter: holeWidth)
                break
            case JMHoleType.Rect.hashValue:
                mask.addHoleRectOnRect(CGRectMake(viewCenter.x, viewCenter.y, viewSize.width, viewSize.height))
                break
            case JMHoleType.RoundedRect.hashValue:
                mask.addHoleRoundedRectOnRect(CGRectMake(viewCenter.x, viewCenter.y, viewSize.width, viewSize.height), withCornerRadius: 10.0)
                break
            default:
                break
                
            }
        
            var label:UILabel
            let labelWidth:CGFloat = 75
            let labelHeight:CGFloat = target.message.heightWithConstrainedWidth(labelWidth, font: UIFont(name: "REIS-Regular", size: 18)!) /* iOS 7*/
            var imageView:UIImageView! = UIImageView()
            
            switch (target.position.hashValue){
                
            case Target.TargetPosition.Top.hashValue:
                /* Illustration
                H:[view]-[imageView]-[label]
                V:[view]-topMargin-[imageView]-bottomTextMargin-[label] */
                imageView = UIImageView(frame: CGRectMake(holeOriginX+(holeWidth/2)-(target.widthArrow/2), holeOriginY - target.heightArrow - target.topMargin, target.widthArrow, target.heightArrow))
                imageView.image = (target.withArrow) ? UIImage(named: "arrow_vertical_up"):UIImage()
                imageView.contentMode = .ScaleAspectFit
                
                label = UILabel(frame: CGRectMake(imageView.center.x - (labelWidth/2), imageView.frame.origin.y-target.bottomTextMargin-labelHeight, labelWidth, labelHeight))
                label.textAlignment = target.textAlignement
                break
                
            case Target.TargetPosition.Bottom.hashValue:
                /* Illustration
                 H:[view]-[imageView]-[label]
                 V:[view]-bottomMargin-[imageView]-topTextMargin-[label] */
                imageView = UIImageView(frame: CGRectMake(holeOriginX+(holeWidth/2)-(target.widthArrow/2), holeOriginY+holeHeight+target.bottomMargin, target.widthArrow, target.heightArrow))
                imageView.image = (target.withArrow) ? UIImage(named: "arrow_vertical_down"):UIImage()
                imageView!.contentMode = .ScaleAspectFit
                
                label = UILabel(frame: CGRectMake(imageView.center.x - (labelWidth/2), imageView.frame.origin.y + target.heightArrow + target.topTextMargin,labelWidth, labelHeight))
                label.textAlignment = target.textAlignement
                break
                
            case Target.TargetPosition.Left.hashValue:
                /* Illustration
                 H:[label]-rightTextMargin-[imageView]-leftMargin-[view]
                 V:[label]-[imageView]-[view] */
                imageView = UIImageView(frame: CGRectMake(holeOriginX-target.leftMargin-target.widthArrow, holeOriginY+(holeHeight/2)-(target.heightArrow/2),target.widthArrow, target.heightArrow))
                imageView.image = (target.withArrow) ? UIImage(named: "arrow_horizontal_left"):UIImage()
                imageView.contentMode = .ScaleAspectFit
                
                label = UILabel(frame: CGRectMake(imageView.frame.origin.x - target.rightTextMargin-labelWidth, imageView.center.y - (labelHeight/2),labelWidth, labelHeight))
                label.textAlignment = target.textAlignement
                break
                
            case Target.TargetPosition.Right.hashValue:
                /* Illustration
                 H:[view]-rightMargin-[imageView]-leftTextMargin-[label]
                 V:[view]-[imageView]-[label] */
                imageView = UIImageView(frame: CGRectMake(holeOriginX+holeWidth+target.rightMargin, holeOriginY+(holeHeight/2)-(target.heightArrow/2), target.widthArrow, target.heightArrow))
                imageView.image = (target.withArrow) ? UIImage(named: "arrow_horizontal_right"):UIImage()
                imageView.contentMode = .ScaleAspectFit
                
                label = UILabel(frame: CGRectMake(imageView.frame.origin.x+target.widthArrow + target.leftTextMargin, imageView.center.y - (labelHeight/2),labelWidth, labelHeight))
                label.textAlignment = target.textAlignement
                break
                
            case Target.TargetPosition.TopLeft.hashValue:
                /* Illustration
                 H:[label]-rightTextMargin-[imageView]-leftMargin-[view]
                 V:[view]-topMargin-[imageView]-bottomTextMargin-[label] */
                imageView = UIImageView(frame: CGRectMake(holeOriginX-target.leftMargin-target.widthArrow, holeOriginY-target.topMargin-target.heightArrow, target.widthArrow, target.heightArrow))
                imageView.image = (target.withArrow) ? UIImage(named: "arrow_top_left"):UIImage()
                imageView.contentMode = .ScaleAspectFit
                
                label = UILabel(frame: CGRectMake(imageView.frame.origin.x-target.rightTextMargin-labelWidth, imageView.frame.origin.y-target.bottomTextMargin-(labelHeight/2),labelWidth, labelHeight))
                label.textAlignment = target.textAlignement
                break
                
            case Target.TargetPosition.TopRight.hashValue:
                /* Illustration
                 H:[view]-rightMargin-[imageView]-leftTextMargin-[label]
                 V:[view]-topMargin-[imageView]-bottomTextMargin-[label] */
                imageView = UIImageView(frame: CGRectMake(holeOriginX+holeWidth+target.rightMargin, holeOriginY-target.topMargin-target.heightArrow, target.widthArrow, target.heightArrow))
                imageView.image = (target.withArrow) ? UIImage(named: "arrow_top_right"):UIImage()
                imageView.contentMode = .ScaleAspectFit
                
                label = UILabel(frame: CGRectMake(imageView.frame.origin.x+target.widthArrow + target.leftTextMargin, imageView.frame.origin.y-target.bottomTextMargin - (labelHeight/2),labelWidth, labelHeight))
                label.textAlignment = target.textAlignement
                break
                
            case Target.TargetPosition.BottomLeft.hashValue:
                /* Illustration
                 H:[label]-rightTextMargin-[imageView]-leftMargin-[view]
                 V:[view]-bottomMargin-[imageView]-topTextMargin-[label] */
                imageView = UIImageView(frame: CGRectMake(holeOriginX-target.leftMargin-target.widthArrow, holeOriginY+holeHeight+target.bottomMargin, target.widthArrow, target.heightArrow))
                imageView.image = (target.withArrow) ? UIImage(named: "arrow_bottom_left"):UIImage()
                imageView.contentMode = .ScaleAspectFit
                
                label = UILabel(frame: CGRectMake(imageView.frame.origin.x-target.rightTextMargin-labelWidth, imageView.frame.origin.y+target.heightArrow+target.topTextMargin-(labelHeight/2),labelWidth, labelHeight))
                label.textAlignment = target.textAlignement
                break
                
            case Target.TargetPosition.BottomRight.hashValue:
                /* Illustration
                 H:[view]-rightMargin-[imageView]-leftTextMargin-[label]
                 V:[view]-bottomMargin-[imageView]-topTextMargin-[label] */
                imageView = UIImageView(frame: CGRectMake(holeOriginX+holeWidth+target.rightMargin, holeOriginY+holeHeight+target.bottomMargin, target.widthArrow, target.heightArrow))
                imageView.image = (target.withArrow) ? UIImage(named: "arrow_bottom_right"):UIImage()
                imageView.contentMode = .ScaleAspectFit
                
                label = UILabel(frame: CGRectMake(imageView.frame.origin.x+target.widthArrow + target.leftTextMargin, imageView.frame.origin.y + target.heightArrow+target.topTextMargin, labelWidth, labelHeight))
                label.textAlignment = target.textAlignement
                break
                
            default:
                label = UILabel(frame: CGRectMake(0, 0,labelWidth, labelHeight))
                break
            }
            
            label.numberOfLines = 0
            label.textColor = UIColor.whiteColor()
            label.font = UIFont(name: "REIS-Regular", size: 18)
            label.text = target.message
            
            if target.withArrow {mask.addSubview(imageView!)}
            mask.addSubview(label)
            
            if let duration = target.duration where !target.breakPoint{
                // Delay execution of my block for duration
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(duration * Float(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    
                    //If not persistent disappear before the next mask appear
                    if target.persistant == false {
                        mask.removeHoles()
                        imageView?.hidden = true
                        label.hidden = true
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
    func holedView(holedView:JMHoledView, didSelectHoleAtIndex:UInt){
        print("Callback holedView")
        if let target = targets?.first where target.isTapable {
            holedView.removeFromSuperview()
            targets?.removeFirst()
            fireTargets()
        }
        if(targets?.count <= 0){
            holedView.removeFromSuperview()
        }
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}