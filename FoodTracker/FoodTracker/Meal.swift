//
//  Meal.swift
//  FoodTracker
//
//  Created by ic on 4/26/16.
//  Copyright © 2016 IC. All rights reserved.
//

import Foundation
import UIKit

class Meal {
    // MARK: Properties
    
    var name: String
    var photo: UIImage? // Valor o nil ?
    var rating: Int
    
    // MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int){
        
        // Initilize stored properties
        
        self.name = name
        self.photo = photo
        self.rating = rating
        
        // Initialization should fail if there is no name or if the rating is negative
        
        if name.isEmpty || rating < 0{
            return nil
        }
    }
}
