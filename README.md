# PBTutorialManager

PBTutorialManager enables you to easily create an in-app tutorial for your app.  

<img src="https://raw.githubusercontent.com/paul1893/PBTutorialManager/master/Screenshots/demo.gif" width="275" />
<img src="https://raw.githubusercontent.com/paul1893/PBTutorialManager/master/Screenshots/demo.png" width="275" />  

### Version
1.0.0  
### Installation

With CocoaPods simply add to your podfile
```sh
pod PBTutorialManager
``` 
or  Copy paste the lib folder on your project
### How to use
So PBTutorialManager works with Target's objects and he manages a queue for you to display one after one the target you put on the queue.
<img src="https://raw.githubusercontent.com/paul1893/PBTutorialManager/master/Screenshots/visual_expl.png" width="1000"  />  
<img src="https://raw.githubusercontent.com/paul1893/PBTutorialManager/master/Screenshots/descritpion.png" width="1000" />  
```swift
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
        
let targetButton = Target(view: button)
            .withArrow(true)
            .heightArrow(50)
            .widthArrow(25)
            .position(.Top)
            .shape(.Cirle)
            .message("This is a button")
            .breakPoint(true)
        
let tutorialManager = TutorialManager(parentView: view)
tutorialManager.addTarget(targetProfilePicture)
tutorialManager.addTarget(targetMainImage)
tutorialManager.addTarget(targetButton)
tutorialManager.fireTargets()
```
#### Extra target properties
Target has other properties you can play with
```swift
textAlignement 	/* The text alignement */
position 		/* The position of your text around the highlight view */
shape 			/* The shape of the mask to highlight the view */
duration 		/* time duration before to show the next target */
isTapable 		/* if isTapable is true you can tap to dismiss the target */
closure 		/* A closure executed after the target has been shown */
persistant		/* if persistant the target stay on screen when the next one show up, you can add multiple target one after one */
breakPoint 		/* breakpoint is a target which attempt a user click to continue */
    
/*Margins*/
topMargin
rightMargin
bottomMargin
leftMargin
    
topTextMargin
rightTextMargin
bottomTextMargin
leftTextMargin
    
/*Arrow: it's not very conveniant but for now arrow is an image. Need to update un the future, you can interact with these properties*/
withArrow
heightArrow
widthArrow
```
### Dependencies

Thanks to [JMHoledView](https://github.com/leverdeterre/JMHoledView)

License
----
MIT License

Copyright (c) [2016] [Paul Bancarel]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
