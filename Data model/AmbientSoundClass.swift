//
//  AmbientSoundClass.swift
//  Budi
//
//  Created by Thijs van der Heijden on 3/14/18.
//  Copyright © 2018 Thijs van der Heijden. All rights reserved.
//

import Foundation

//Creating the class for every ambient sound
public class AmbientSound {
    
    let imageName: String
    let soundFile: String
    
    init(imageName: String, soundFile: String) {
        self.imageName = imageName
        self.soundFile = soundFile
    }
    
}

//Array
var ambientSounds = [AmbientSound]()

//Adding all the ambient sounds to data model
let fireSound =  AmbientSound(imageName: "fire", soundFile: "Fire.mp3")
let rainSound = AmbientSound(imageName: "rain", soundFile: "rain.mp3")
let thunderSound = AmbientSound(imageName: "thunder", soundFile: "rain.mp3")
let windSound = AmbientSound(imageName: "wind", soundFile: "Fire.mp3")

//Adding sounds to array
public func addSoundsToArray() {
    ambientSounds.append(fireSound)
    ambientSounds.append(rainSound)
    ambientSounds.append(thunderSound)
    ambientSounds.append(windSound)
}

