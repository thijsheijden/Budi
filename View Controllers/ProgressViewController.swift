//
//  ProgressViewController.swift
//  Budi
//
//  Created by Thijs van der Heijden on 3/17/18.
//  Copyright © 2018 Thijs van der Heijden. All rights reserved.
//

import UIKit

class ProgressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

        @IBOutlet weak var tableView: UITableView!
        
        //Constants and variables
        let cellIdentifier = "DailyProgressCell"
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            
            //Remove the grey seperators between the tableview cells
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            
        }
        
        //UITableview Functions
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dailyProgressArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DailyProgressCell  else {
                fatalError("The dequeued cell is not an instance of DailyProgressCell.")
            }
            
            //Rounding the corners of the DailyProgress Cells
            cell.cellView.layer.cornerRadius = 20
            cell.cellView.layer.shadowColor = UIColor.darkGray.cgColor
            cell.cellView.layer.shadowRadius = 5
            cell.cellView.layer.shadowOpacity = 0.75
            
            //Adding the text to the labels
            cell.dateLabel.text = String(dailyProgressArray[indexPath.row].dayNumber)
            cell.focusCountLabel.text = String(dailyProgressArray[indexPath.row].numberOfFocusRounds)
            
            return cell
            
        }
    }
