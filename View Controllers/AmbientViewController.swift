//
//  AmbientViewController.swift
//  Budi
//
//  Created by Thijs van der Heijden on 3/14/18.
//  Copyright © 2018 Thijs van der Heijden. All rights reserved.
//

import UIKit
import AVFoundation

class AmbientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentAudioView: UIView!
    @IBOutlet weak var currentAudioLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    //Constants and variables
    let cellIdentifier = "AmbientSoundCell"
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Adding the current audio view to the tableview
        tableView.addSubview(currentAudioView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Remove the grey lines between the tableview cells
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        //Hide the stop button until the music starts playing
        stopButton.isHidden = true
    }
    
    //UITableview Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ambientSounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AmbientSoundCell  else {
            fatalError("The dequeued cell is not an instance of AmbientSoundCell.")
        }
        
        //Adding the button to the cell and making it selectable
        cell.playSoundButton.tag = indexPath.row
        cell.playSoundButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    
        //Rounding the corners of the ambientSoundCells
        cell.cellView.layer.cornerRadius = 20
        cell.cellView.layer.shadowColor = UIColor.darkGray.cgColor
        cell.cellView.layer.shadowRadius = 5
        cell.cellView.layer.shadowOpacity = 0.75
        
        //Adding all the sound images to the cells and giving them rounded edges
        cell.soundImage.image = UIImage(named: ambientSounds[indexPath.row].imageName)
        cell.soundNameLabel.text = ambientSounds[indexPath.row].imageName
        
        return cell
        
    }
    
    //MARK: Functions
    
    //Function to get the correct sound file according to the button tag
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        let tapedIndex = sender as! UIButton
        let getSoundURL = ambientSounds[tapedIndex.tag].soundFile
        let getSoundName = ambientSounds[tapedIndex.tag].soundName
        playSound(soundURL: getSoundURL, soundName: getSoundName)
    }
    
    func playSound(soundURL: String, soundName: String) {
        //Prepare the audio player to play the correct sound file
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: soundURL, ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
            
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
        
        //start the audio player playback
        audioPlayer.play()
        stopButton.isHidden = false
        currentAudioLabel.text = soundName
    }
    
    //MARK: IBACTIONS
    @IBAction func stopButtonPressed(_ sender: Any) {
        if audioPlayer.isPlaying == true {
            audioPlayer.stop()
        } else {
            print("Audio player not playing, not able to be stopped")
        }
        
    }
    
}
