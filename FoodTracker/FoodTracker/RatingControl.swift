//
//  RatingControl.swift
//  FoodTracker
//
//  Created by IC on 4/21/16.
//  Copyright © 2016 IC. All rights reserved.
//

import UIKit

class RatingControl: UIView {
    
    // MARK: Propeties
    var rating = 0{
        didSet{
            setNeedsLayout()
        }
    }
    var ratingButtons = [UIButton]()
    
    let spacing = 5
    let starCount = 5
    
    let emptyStarImage = UIImage(named: "EmptyStar")
    let filledStarImage = UIImage(named: "FillStar")
    

    //MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        for _ in 0..<starCount{
            
            //let button = UIButton(frame: CGRect(x: 0, y: 350, width: 44, height: 44))
            //button.backgroundColor = UIColor.redColor()

            let button = UIButton()
            
            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
            
            button.adjustsImageWhenHighlighted = false
            button.addTarget(self, action: Selector("ratingButtonTapped:"), forControlEvents: .TouchDown)
            ratingButtons += [button]
        
            addSubview(button)
        }
    }
    
    override func layoutSubviews() {
        let buttonSize  = 20
        //let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        for (index, button) in ratingButtons.enumerate(){
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        updateButtonSelectionStates()
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = 20
        //let buttonSize = Int(frame.size.height)
        let width = (buttonSize * starCount) + (spacing: buttonSize)
        return CGSize(width: width, height: buttonSize)
    }
    
    func ratingButtonTapped(button: UIButton){
        rating = ratingButtons.indexOf(button)! + 1
        updateButtonSelectionStates()
        print("Button pressed :P")
    }
    
    func updateButtonSelectionStates(){
        for (index, button) in ratingButtons.enumerate(){
            button.selected = index < rating;
        }
    }
}
