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
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var mainImage: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var button: UIButton!
    @IBOutlet var test: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        let targetProfilePicture = Target(view: profilePicture)
            .withArrow(true)
            .heightArrow(50)
            .widthArrow(25)
            .position(.Bottom)
            .shape(JMHoleType.Cirle)
            .duration(1.0)
            .message("This is a profile picture")
        
        let targetMainImage = Target(view: mainImage)
            .withArrow(true)
            .heightArrow(50)
            .widthArrow(25)
            .position(.Bottom)
            .shape(JMHoleType.Rect)
            .duration(1.0)
            .message("This is the main image")
        
        let targetNameLabel = Target(view: nameLabel)
            .withArrow(true)
            .widthArrow(75)
            .heightArrow(30)
            .position(.Right)
            .shape(JMHoleType.Rect)
            .duration(1.0)
            .message("This is a label")
            .textAlignement(.Left)
            .breakPoint(true)
        
        let targetButton = Target(view:button)
            .withArrow(true)
            .heightArrow(50)
            .widthArrow(25)
            .position(.Top)
            .shape(.Cirle)
            .message("This is a button")
            .breakPoint(true)
        
        let tutorialManager = TutorialManager(parentView: self.view)
        tutorialManager.addTarget(targetProfilePicture)
        tutorialManager.addTarget(targetMainImage)
        tutorialManager.addTarget(targetNameLabel)
        tutorialManager.addTarget(targetButton)
        tutorialManager.fireTargets()
        
    }
    
    private func setup(){
        profilePicture.layer.cornerRadius = profilePicture.frame.width/2
        profilePicture.clipsToBounds = true
    }
    
    
}

