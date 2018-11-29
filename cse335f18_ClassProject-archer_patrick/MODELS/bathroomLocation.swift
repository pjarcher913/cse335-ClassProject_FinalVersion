//
//  bathroomLocation.swift
//  cse335f18_ClassProject-archer_patrick
//
//  Created by Patrick Archer
//  Copyright © 2018 Patrick Archer - Self. All rights reserved.
//

import Foundation
import UIKit

class bathroomLocations {
    
    var descriptionCoor:String = "Coor has bathrooms located on all floors, however the recommended bathrooms are located on the lower level (L1) and the main level (1)."
    var descriptionBYENG:String = "BYENG has 7 main floors. Bathrooms are only located on floors 2-7. Because of clearance permissions, the recommended bathrooms are located on floors 2 and 3."
    var descriptionMU:String = "The Memorial Union has bathrooms scattered all throughout the complex. All bathrooms are similarly-maintained by the same janitorial staff. High foot-traffic (heavy use)."
    var descriptionCPCOM:String = "The Computing Commons has bathrooms scattered all throughout the complex. All bathrooms are similarly-maintained by the same janitorial staff. High foot-traffic (heavy use)."
    
    var bathroomLocations:[bathroomLocation] = []
    let tableSectionTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    init()
    {
        let l_coor = bathroomLocation(lBuilding: "(COOR)-Lattie Coor", lDesc: descriptionCoor, lImage: "coor.jpg")
        let l_byeng = bathroomLocation(lBuilding: "(BYENG)-Brickyard Engineering", lDesc: descriptionBYENG, lImage: "byeng.jpg")
        let l_mu = bathroomLocation(lBuilding: "(MU)-Memorial Union", lDesc: descriptionMU, lImage: "mu.jpg")
        let l_ccommons = bathroomLocation(lBuilding: "(CPCOM)-Computing Commons", lDesc: descriptionCPCOM, lImage: "cpcom.jpg")
        
        bathroomLocations.append(l_coor)
        bathroomLocations.append(l_byeng)
        bathroomLocations.append(l_mu)
        bathroomLocations.append(l_ccommons)
        
        //...
        
    }
    
    func addEntry()
    {
        // <TODO>
    }
    
    func deleteEntry()
    {
        // <TODO>
    }
    
    func editEntry()
    {
        // <TODO>
    }
}

class bathroomLocation {
    
    var locBuilding:String  // building name where bathroom resides (for no building, == "STANDALONE")
    var locDescription:String   // description of the bathroom, how to get to it, etc.
    var locImageName:String // attached images of building, bathroom, etc.
    
    init(lBuilding:String, lDesc:String, lImage:String)
    {
        locBuilding = lBuilding
        locDescription = lDesc
        locImageName = lImage
    }
    
}
