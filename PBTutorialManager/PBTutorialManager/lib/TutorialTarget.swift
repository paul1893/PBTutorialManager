//
//  TutorialTarget.swift
//  PBTutorialManager
//
//  Created by Paul Bancarel on 05/07/2016.
//  Copyright © 2016 TheFrenchTouchDeveloper. All rights reserved.
//

import Foundation
import UIKit


/**
 Target represent a "Tutorial object" you can point a
 view associated with a message to describe an action
 */
open class TutorialTarget: NSObject {
    public enum TargetPosition {
        case top
        case right
        case bottom
        case left
        case topRight
        case topLeft
        case bottomRight
        case bottomLeft
        case centre
    }
    
    open var view:UIView? /* The view you want to highlight */
    open var message:String! /* The text you want to show */
    open var textAlignement:NSTextAlignment = NSTextAlignment.center /* The text alignement */
    open var numberOfLines:Int = 0
    open var labelWidth:CGFloat = 75
    open var position:TargetPosition /* The position of your text around the highlight view */
    open var shape:HoleShape? /* The shape of the mask to highlight the view */
    open var font:UIFont = UIFont.systemFont(ofSize: 18.0) /* The font of the target */
    open var duration:TimeInterval? /* time duration before to show the next target */
    open var isTapable:Bool = false /* if isTapable is true you can tap to dismiss the target */
    open var closure:(() -> Void)? /* A closure executed after the target has been shown */
    open var persistant:Bool = true /* if persistant the target stay on screen when the next one show up, you can add multiple target one after one */
    open var breakPoint = false /* breakpoint is a target which attempt a user click to continue */
    
    /*Margins*/
    open var topMargin:CGFloat = 0
    open var rightMargin:CGFloat = 0
    open var bottomMargin:CGFloat = 0
    open var leftMargin:CGFloat = 0
    
    open var topTextMargin:CGFloat = 0
    open var rightTextMargin:CGFloat = 0
    open var bottomTextMargin:CGFloat = 0
    open var leftTextMargin:CGFloat = 0
    
    /*Arrow*/
    open var withArrow:Bool = true
    open var heightArrow:CGFloat = 0
    open var widthArrow:CGFloat = 0
    open var arrowHeadSize:CGFloat = 10
    
    public init(view:UIView?) {
        self.view = view
        self.message = ""
        self.position = .bottom
        super.init()
    }
    
    open func message(_ message:String) -> TutorialTarget {
        self.message = message;
        return self;
    }
    open func labelWidth(_ labelWidth:CGFloat) -> TutorialTarget {
        self.labelWidth = labelWidth;
        return self;
    }
    open func position(_ position:TargetPosition) -> TutorialTarget {
        self.position = position;
        return self;
    }
    open func shape(_ shape:HoleShape?) -> TutorialTarget {
        self.shape = shape;
        return self;
    }
    open func duration(_ duration:TimeInterval?) -> TutorialTarget {
        self.duration = duration;
        return self;
    }
    open func isTapable(_ isTapable:Bool) -> TutorialTarget {
        self.isTapable = isTapable;
        return self;
    }
    open func onCompletion(onCompletion: @escaping (() -> Void)) -> TutorialTarget {
        self.closure = onCompletion;
        return self;
    }
    open func persistant(_ persistant:Bool) -> TutorialTarget {
        self.persistant = persistant;
        return self;
    }
    open func textAlignement(_ textAlignement:NSTextAlignment) -> TutorialTarget {
        self.textAlignement = textAlignement;
        return self;
    }
    open func withArrow(_ bool:Bool) -> TutorialTarget {
        withArrow = bool;
        return self;
    }
    open func heightArrow(_ heightArrow:CGFloat) -> TutorialTarget {
        self.heightArrow = heightArrow;
        return self;
    }
    open func widthArrow(_ widthArrow:CGFloat) -> TutorialTarget {
        self.widthArrow = widthArrow;
        return self;
    }
    open func arrowHeadSize(_ arrowHeadSize:CGFloat) -> TutorialTarget {
        self.arrowHeadSize = arrowHeadSize;
        return self;
    }
    open func topMargin(_ topMargin:CGFloat) -> TutorialTarget {
        self.topMargin = topMargin;
        return self;
    }
    open func rightMargin(_ rightMargin:CGFloat) -> TutorialTarget {
        self.rightMargin = rightMargin;
        return self;
    }
    open func bottomMargin(_ bottomMargin:CGFloat) -> TutorialTarget {
        self.bottomMargin = bottomMargin;
        return self;
    }
    open func leftMargin(_ leftMargin:CGFloat) -> TutorialTarget {
        self.leftMargin = leftMargin;
        return self;
    }
    open func topTextMargin(_ topTextMargin:CGFloat) -> TutorialTarget {
        self.topTextMargin = topTextMargin;
        return self;
    }
    open func rightTextMargin(_ rightTextMargin:CGFloat) -> TutorialTarget {
        self.rightTextMargin = rightTextMargin;
        return self;
    }
    open func bottomTextMargin(_ bottomTextMargin:CGFloat) -> TutorialTarget {
        self.bottomTextMargin = bottomTextMargin;
        return self;
    }
    open func leftTextMargin(_ leftTextMargin:CGFloat) -> TutorialTarget {
        self.leftTextMargin = leftTextMargin;
        return self;
    }
    open func breakPoint(_ breakPoint:Bool) -> TutorialTarget {
        self.breakPoint = breakPoint;
        self.isTapable = true;
        return self;
    }
}
