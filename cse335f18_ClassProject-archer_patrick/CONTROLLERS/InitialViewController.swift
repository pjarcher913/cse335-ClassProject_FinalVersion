//
//  ViewController.swift
//  cse335f18_ClassProject-archer_patrick
//
//  Created by Patrick Archer
//  Copyright © 2018 Patrick Archer - Self. All rights reserved.
//

import UIKit
import Foundation

class InitialViewController: UIViewController {
    
    /*==========================================================*/
    
    @IBOutlet weak var label_introMsg: UILabel!
    @IBOutlet weak var label_msgTempeOnly: UILabel!
    
    /*==========================================================*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("Now executing via TableEntryDetailVC.")  // debug
        
        // set initial text for label_introMsg
        self.label_introMsg.text =
        "Welcome to Patrick Archer's Bathroom Location and Review app.\n\n\nPlease press the CONTINUE button below to load the database and table view."
        
        // set initial text for label_msgTempeOnly
        self.label_msgTempeOnly.text =
        "This application utilizes CoreData and your device's location. Please ensure you have enough disk space to perform all your desired operations and you have an active connection to the internet."
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*==========================================================*/
    
    // used by segue handler to prepare for segue and pass data to the next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "segueToLocTableView"){
            if let tableVC1ViewController: TableVC1 = segue.destination as? TableVC1
            {
                print("Prepare for segue to: TableVC1 view.")    // debug
            }
        }
    }
    
    // used by exit handler to unwind segue and pass data to the original page
    @IBAction func unwindSegue(segue: UIStoryboardSegue)
    {
        print("Unwinding segue from: TableVC1 view.")
        
        if let tableVC1ViewController = segue.source as? TableVC1
        {
            //let dataReceived = sourceViewController.passedLocName
            //print("Unwinding segue from: \(String(dataReceived))")    // debug
            print("")   // debug
            
        }
    }
    
    /*==========================================================*/

    // trigger for when user presses CONTINUE button to load the database and tableView
    @IBAction func button_beginApp(_ sender: UIButton) {
        // do nothing, because this button is a segue trigger
    }
    
    /*==========================================================*/
    
}








