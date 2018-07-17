//
//  PokeAnnotation.swift
//  Pokemon
//
//  Created by Michael Zhou on 2018-07-17.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PokeAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon : Pokemon
    
    init(coordinate: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinate
        self.pokemon = pokemon
    }
    
}
