//
//  Target.swift
//  PBTutorialManager
//
//  Created by Paul Bancarel on 05/07/2016.
//  Copyright © 2016 TheFrenchTouchDeveloper. All rights reserved.
//

import Foundation
import UIKit
import JMHoledView

/**
 Target represent a "Tutorial object" you can point a
 view associated with a message to describe an action
 */
public class Target : NSObject{
    
    public enum TargetPosition{
        case Top
        case Right
        case Bottom
        case Left
        case TopRight
        case TopLeft
        case BottomRight
        case BottomLeft
    }
    
    public var view:UIView? /* The view you want to highlight */
    public var message:String! /* The text you want to show */
    public var textAlignement:NSTextAlignment = NSTextAlignment.Center /* The text alignement */
    public var numberOfLines:Int = 0
    public var position:TargetPosition! /* The position of your text around the highlight view */
    public var shape:JMHoleType! /* The shape of the mask to highlight the view */
    public var duration:Float? /* time duration before to show the next target */
    public var isTapable:Bool = false /* if isTapable is true you can tap to dismiss the target */
    public var closure:(Void -> Void)? /* A closure executed after the target has been shown */
    public var persistant:Bool = true /* if persistant the target stay on screen when the next one show up, you can add multiple target one after one */
    public var breakPoint = false /* breakpoint is a target which attempt a user click to continue */
    
    /*Margins*/
    public var topMargin:CGFloat = 0
    public var rightMargin:CGFloat = 0
    public var bottomMargin:CGFloat = 0
    public var leftMargin:CGFloat = 0
    
    public var topTextMargin:CGFloat = 0
    public var rightTextMargin:CGFloat = 0
    public var bottomTextMargin:CGFloat = 0
    public var leftTextMargin:CGFloat = 0
    
    /*Arrow*/
    public var withArrow:Bool = true
    public var heightArrow:CGFloat = 0
    public var widthArrow:CGFloat = 0
    
    public init(view:UIView?) {
        super.init()
        self.view = view
        self.message = ""
        self.duration = 1.0
        self.position = .Bottom
        self.shape = JMHoleType.Cirle
    }
    
    public func message(message:String) -> Target{
        self.message = message;
        return self;
    }
    public func position(position:TargetPosition) -> Target{
        self.position = position;
        return self;
    }
    public func shape(shape:JMHoleType) -> Target{
        self.shape = shape;
        return self;
    }
    public func duration(duration:Float) -> Target{
        self.duration = duration;
        return self;
    }
    public func isTapable(isTapable:Bool) -> Target{
        self.isTapable = isTapable;
        return self;
    }
    public func onCompletion(onCompletion:(Void -> Void)) -> Target{
        self.closure = onCompletion;
        return self;
    }
    public func persistant(persistant:Bool) -> Target{
        self.persistant = persistant;
        return self;
    }
    public func textAlignement(textAlignement:NSTextAlignment) -> Target{
        self.textAlignement = textAlignement;
        return self;
    }
    public func withArrow(bool:Bool) -> Target{
        withArrow = bool;
        return self;
    }
    public func heightArrow(heightArrow:CGFloat) -> Target{
        self.heightArrow = heightArrow;
        return self;
    }
    public func widthArrow(widthArrow:CGFloat) -> Target{
        self.widthArrow = widthArrow;
        return self;
    }
    
    public func topMargin(topMargin:CGFloat) -> Target{
        self.topMargin = topMargin;
        return self;
    }
    public func rightMargin(rightMargin:CGFloat) -> Target{
        self.rightMargin = rightMargin;
        return self;
    }
    public func bottomMargin(bottomMargin:CGFloat) -> Target{
        self.bottomMargin = bottomMargin;
        return self;
    }
    public func leftMargin(leftMargin:CGFloat) -> Target{
        self.leftMargin = leftMargin;
        return self;
    }
    public func topTextMargin(topTextMargin:CGFloat) -> Target{
        self.topTextMargin = topTextMargin;
        return self;
    }
    public func rightTextMargin(rightTextMargin:CGFloat) -> Target{
        self.rightTextMargin = rightTextMargin;
        return self;
    }
    public func bottomTextMargin(bottomTextMargin:CGFloat) -> Target{
        self.bottomTextMargin = bottomTextMargin;
        return self;
    }
    public func leftTextMargin(leftTextMargin:CGFloat) -> Target{
        self.leftTextMargin = leftTextMargin;
        return self;
    }
    public func breakPoint(breakPoint:Bool) -> Target{
        self.breakPoint = breakPoint;
        self.isTapable = true;
        return self;
    }
}