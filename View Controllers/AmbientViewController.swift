//
//  AmbientViewController.swift
//  Budi
//
//  Created by Thijs van der Heijden on 3/14/18.
//  Copyright © 2018 Thijs van der Heijden. All rights reserved.
//

import UIKit

class AmbientViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //Constants and variables
    let cellIdentifier = "AmbientSoundCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        //Remove the grey lines between the tableview cells
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    //UITableview Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ambientSounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AmbientSoundCell  else {
            fatalError("The dequeued cell is not an instance of AmbientSoundCell.")
        }
        
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
}
