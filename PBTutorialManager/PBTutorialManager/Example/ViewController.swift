//
//  ViewController.swift
//  PBTutorialManager
//
//  Created by Paul Bancarel on 05/07/2016.
//  Copyright © 2016 TheFrenchTouchDeveloper. All rights reserved.
//

import UIKit
import JMHoledView

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
        
        // Start to create your targets
        let targetProfilePicture = Target(view: profilePicture)
            .withArrow(true)
            .heightArrow(50)
            .widthArrow(25)
            .position(.bottom)
            .shape(JMHoleType.cirle)
            .duration(1.0)
            .message("This is a profile picture")
        
        let targetMainImage = Target(view: mainImage)
            .withArrow(true)
            .heightArrow(50)
            .widthArrow(25)
            .position(.bottom)
            .shape(JMHoleType.rect)
            .duration(1.0)
            .message("This is the main image")
        
        let targetNameLabel = Target(view: nameLabel)
            .withArrow(true)
            .widthArrow(75)
            .heightArrow(30)
            .position(.right)
            .shape(JMHoleType.rect)
            .duration(1.0)
            .message("This is a label")
            .textAlignement(.left)
            .breakPoint(true)
        
        let targetButton = Target(view:button)
            .withArrow(true)
            .heightArrow(50)
            .widthArrow(25)
            .position(.top)
            .shape(.cirle)
            .message("This is a button")
            .breakPoint(true)
        
        // Then create a tutorialManager
        let tutorialManager = TutorialManager(parentView: self.view)
        // ... and feed him with your targets
        tutorialManager.addTarget(targetProfilePicture)
        tutorialManager.addTarget(targetMainImage)
        tutorialManager.addTarget(targetNameLabel)
        tutorialManager.addTarget(targetButton)
        
        // Do not forget to fire the targets ;)
        tutorialManager.fireTargets()
        
    }
    
    fileprivate func setup(){
        profilePicture.layer.cornerRadius = profilePicture.frame.width/2
        profilePicture.clipsToBounds = true
    }
}
