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
    let soundName: String
    
    init(imageName: String, soundFile: String, soundName: String) {
        self.imageName = imageName
        self.soundFile = soundFile
        self.soundName = soundName
    }
    
}

//Array
var ambientSounds = [AmbientSound]()

//Adding all the ambient sounds to data model
let fireSound =  AmbientSound(imageName: "fire", soundFile: "Fire.mp3", soundName: "fire")
let rainSound = AmbientSound(imageName: "rain", soundFile: "rain.mp3", soundName: "rain")
let thunderSound = AmbientSound(imageName: "thunder", soundFile: "rain.mp3", soundName: "thunder")
let windSound = AmbientSound(imageName: "wind", soundFile: "Fire.mp3", soundName: "wind")
let trainSound = AmbientSound(imageName: "train", soundFile: "rain.mp3", soundName: "train")
let waterSound = AmbientSound(imageName: "water", soundFile: "rain.mp3", soundName: "water")
//Adding sounds to array
public func addSoundsToArray() {
    ambientSounds.append(fireSound)
    ambientSounds.append(rainSound)
    ambientSounds.append(thunderSound)
    ambientSounds.append(windSound)
    ambientSounds.append(trainSound)
    ambientSounds.append(waterSound)
}

