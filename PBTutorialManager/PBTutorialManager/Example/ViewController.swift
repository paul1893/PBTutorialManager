//
//  ViewController.swift
//  PBTutorialManager
//
//  Created by Paul Bancarel on 05/07/2016.
//  Copyright © 2016 TheFrenchTouchDeveloper. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    /**
     This is an example of how use the PBTutorialManager library
     */
    
    /**
     Here some of your views you want to target with PBTutorialManager
     */
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet var test: UIButton!
    
    /**
    Ok so viewDidLoad
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        setup() // Some config to have a roundProfilePicture
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Start to create your targets
        let targetProfilePicture = TutorialTarget(view: profilePicture)
            .withArrow(true)
            .heightArrow(50)
            .widthArrow(25)
            .position(.bottom)
            .shape(.elipse)
            .duration(1.0)
            .message("This is a profile picture")
        
        let targetMainImage = TutorialTarget(view: mainImage)
            .withArrow(true)
            .heightArrow(50)
            .widthArrow(25)
            .position(.bottom)
            .shape(.rect)
            .duration(1.0)
            .message("This is the main image")
        
        let targetNameLabel = TutorialTarget(view: nameLabel)
            .withArrow(true)
            .widthArrow(75)
            .heightArrow(30)
            .position(.right)
            .shape(.rect)
            .duration(1.0)
            .message("This is a label")
            .textAlignement(.left)
            .breakPoint(true)
        
        let targetButton = TutorialTarget(view:button)
            .withArrow(true)
            .heightArrow(50)
            .widthArrow(25)
            .position(.top)
            .shape(.elipse)
            .message("This is a button")
            .breakPoint(true)
        
        // Then create a tutorialManager
        let tutorialManager = TutorialManager(parent: view)
        // ... and feed him with your targets
        tutorialManager.addTarget(targetProfilePicture)
        tutorialManager.addTarget(targetMainImage)
        tutorialManager.addTarget(targetNameLabel)
        tutorialManager.addTarget(targetButton)
        
        // Do not forget to fire the targets ;)
        tutorialManager.fireTargets()
    }
    
    fileprivate func setup() {
        profilePicture.layer.cornerRadius = profilePicture.frame.width/2
        profilePicture.clipsToBounds = true
    }
}


class TestViewController: UIViewController {
    private        var tutorialManager: TutorialManager!
    @IBOutlet weak var testView:        UIView!
    @IBOutlet weak var centreTestView:  UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // So the tutorial appears above the toolbars the parent must be the window
        tutorialManager = TutorialManager(parent: view.window!, fadeInDelay: 0.25)
        
        var targets = [TutorialTarget]()
        let possitions: [TutorialTarget.TargetPosition] = [.left,    .top,      .right,       .bottom,
                                                           .topLeft, .topRight, .bottomRight, .bottomLeft]
        var breakpoint = false
        possitions.forEach() {
            // Start to create your targets
            let target = TutorialTarget(view: testView)
                .withArrow(true)
                .position($0)
                .shape(.rect)
                .breakPoint(breakpoint)
                .message("Test")
            breakpoint = !breakpoint
            targets.append(target)
        }
        
        // Setup a centered message
        let target = TutorialTarget(view: centreTestView)
            .position(.centre)
            .breakPoint(true)
            .message("Centered message")
        targets.append(target)
        
        // Clone the targets but this time remove the breakpoints so we can see them all together
        let clonedTargets = targets.map({TutorialTarget(copyFrom: $0)})
        clonedTargets.forEach({$0.breakPoint = false})
        clonedTargets.last?.breakPoint = true
        targets.append(contentsOf: clonedTargets)
        
        tutorialManager.addTargets(targets)
        tutorialManager.fireTargets()
    }
}
