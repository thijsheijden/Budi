//
//  AmbientViewController.swift
//  Budi
//
//  Created by Thijs van der Heijden on 3/14/18.
//  Copyright © 2018 Thijs van der Heijden. All rights reserved.
//

import UIKit

class AmbientViewController: UITableViewController {
    
    @IBOutlet weak var ambientSoundTableView: UITableView!
    
    //Constants and variables
    let cellIdentifier = "AmbientSoundCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITableview Functions
    func ambientSoundTableView(_ ambientSoundTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func ambientSoundTableView(_ ambientSoundTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ambientSoundTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AmbientSoundCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        return cell
    }
}
