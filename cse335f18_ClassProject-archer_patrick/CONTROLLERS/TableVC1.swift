//
//  TableVC1.swift
//  cse335f18_ClassProject-archer_patrick
//
//  Created by Patrick Archer
//  Copyright © 2018 Patrick Archer - Self. All rights reserved.
//

import UIKit
//import Foundation
import CoreData

class TableVC1: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /*==========================================================*/
    
    //var counter:Int = 1
    
    // var to store user-selected table row entry, in order to pass info to next viewController
    weak var userSelectedRowEntry:LocationEntity?
    
    // object instance of location object that has an array of locations
    // and the section headers for the location table
    var myLocList:bathroomLocations =  bathroomLocations()
    
    // dictionary with section headers as a key and location object as a value
    var locList = [String: [bathroomLocation]]()
    
    // bool to catch whether the dictionary has already been loaded or not; set to false after first viewLoad
    var firstTimeOpening:Bool = true
    
    // outlet for main location table
    @IBOutlet weak var table_bthrmLocs: UITableView!
    
    // label that describes the view's functionality to the user and provides
    // instructions for how to navigate said view
    //@IBOutlet weak var label_viewInstructionsToUser: UILabel!
    
    /*==========================================================*/
    // configure CoreData utilization
    
    // handler to the managed object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //this is the array to store location entities from the coredata
    var fetchResults = [LocationEntity]()
    
    // func to handle when fetching record data from CoreData
    func fetchRecord() -> Int {
        
        // Create a new fetch request using the LocationEntity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LocationEntity")
        let sort = NSSortDescriptor(key: "buildingName", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        //var x = 0
        
        // Execute the fetch request, and cast the results to an array of LocationEntity objects
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [LocationEntity])!
        
        let x = fetchResults.count
        let y = fetchResults.description
        
        print("fetchResults.count = \(x)")    // debug
        print("fetchResults = \(y)")
        
        // return how many entities in the coreData
        return x
        
    }
    
    func updateLastRow() {
        let indexPath = IndexPath(row: fetchResults.count - 1, section: 0)
        self.table_bthrmLocs.reloadRows(at: [indexPath], with: .automatic)
    }
    
    /*==========================================================*/

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Now executing via TableVC1.")  // debug
        
        // create/load dictionary on view load
        //createLocDictionary()
        
        self.table_bthrmLocs.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.table_bthrmLocs.reloadData()
    }
    
    /*==========================================================*/
    
    // used by segue handler to prepare for segue and pass data to the next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let selectedIndex: IndexPath = self.table_bthrmLocs.indexPath(for: sender as! UITableViewCell)!
        
        if (segue.identifier == "segueToDetailView"){
            if let destinationViewController: TableEntryDetailVC = segue.destination as? TableEntryDetailVC
            {
                print("\nPrepare for segue to: TableEntryDetailVC view.")    // debug

                let indexPath = self.table_bthrmLocs.indexPathForSelectedRow!
                //destinationViewController.userSelectedLoc = fetchResults[indexPath.row]
                destinationViewController.userSelectedLoc = fetchResults[indexPath.row]
                destinationViewController.userSelectedIndex = indexPath
                
                
                print("\nName of Building Passed: \(destinationViewController.userSelectedLoc?.buildingName!)") // debug
                print("Index of Building Passed: \(destinationViewController.userSelectedIndex?.description)") // debug
                print("ObjectID of building Passed: \(fetchResults[selectedIndex.row].objectID)\n")
                
                self.table_bthrmLocs.reloadData()
                
                /*
                // save the updated context
                do {
                    try self.managedObjectContext.save()
                } catch _ {
                }*/
            }
        }

    }
    
    // used by exit handler to unwind segue and pass data to the original page
    @IBAction func unwindSegue(segue: UIStoryboardSegue)
    {
        print("Unwinding segue from: TableVC1 view.")
        
        /*if let destinationViewController: InitialViewController = segue.destination as? InitialViewController
        {
            print("Unwinding segue from Table VC1 to InitialViewController") // debug
        }*/
        
        /*if let tableVC1ViewController = segue.source as? TableVC1
        {
            //let dataReceived = sourceViewController.passedLocName
            //print("Unwinding segue from: \(String(dataReceived))")    // debug
            print("")   // debug
            
        }*/
        
        /*if (segue.identifier == "segueToLocTableView"){
            if let destinationViewController: InitialViewController = segue.destination as? InitialViewController
            {
                print("Unwinding segue from Table VC1 to InitialViewController") // debug
            }
        }*/
        
        self.table_bthrmLocs.reloadData()
    }
    
    /*==========================================================*/
    
    // handles what happens when user presses "Refresh" bar button
    @IBAction func barButton_refresh(_ sender: UIBarButtonItem) {
        self.table_bthrmLocs.reloadData()
    }
    
    // handles what to do when user presses addEntry barbutton (plus sign)
    @IBAction func barbutton_addEntry(_ sender: UIBarButtonItem) {
        
        let alertMsg = "PLEASE enter your desired information in the following format:\n\nIn the FIRST text box, enter the FULL ADDRESS of the building in which the bathroom is located.\n\nIn the SECOND text box, enter any DETAILS pertaining to the building or bathroom (such as the common name for the building). See the below text boxes, for examples.\n\nPress the SUBMIT button when done, or CANCEL to go back without creating a new entry."
        
        let alert = UIAlertController(title: "ADD LOCATION ENTRY", message: alertMsg, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "\"699 S Mill Ave, Tempe, AZ\""
        })
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "\"Brickyard Engineering (BYENG)\""
        })
        
        // handles what to do when user presses the SUBMIT button in the alert
        alert.addAction(UIAlertAction(title: "SUBMIT", style: .default, handler: { action in
            
            if alert.textFields![0].text == ""
            {
                print("\nERROR: Invald building address enterred. Aborting entry addition.\n")
            }else{
                //let newLocation:bathroomLocation = bathroomLocation.init(lBuilding: newName!, lDesc: newDesc!, lImage: "house.jpg")
                
                // create a new coredata entity object
                let ent = NSEntityDescription.entity(forEntityName: "LocationEntity", in: self.managedObjectContext)
                
                //let ent = NSEntityDescription.insertNewObject(forEntityName: "LocationEntity", into: self.managedObjectContext) as? LocationEntity
                
                //add to the managed object context
                let newItem = LocationEntity(entity: ent!, insertInto: self.managedObjectContext)
                newItem.buildingName = alert.textFields![0].text!
                newItem.buildingDescription = alert.textFields![1].text!
                newItem.buildingImage = nil
                newItem.ratingCleanliness = 1
                newItem.ratingPopularity = 3
                newItem.ratingEofA = 5
                
                
                // save the updated context
                do {
                    try self.managedObjectContext.save()
                } catch _ {
                }
                
                self.table_bthrmLocs.reloadData()
                
                //self.updateLastRow()
            }
            
        }))
        
        // handles what to do when user presses the CANCEL button in the alert
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    /*// handles what to do when user presses additionalActions barbutton (square w/ up-arrow)
    @IBAction func barbutton_additionalActions(_ sender: UIBarButtonItem) {
        let msgToDisplay:String =
        "This app is a 1.0 version and as such is still in development (==> this submission is for PHASE 1, which only requires minimum functionality <==).\n\nIn the completed/PHASE 3 version, pressing this button would bring up a menu filled with additional options. These options would vary in terms of operation, however at least one will utilize WebAPI calling functionality (this is to satisfy the corresponding project requirement).\n\nThis message is a temporary placeholder while this feature of the app is in development."
        
        let alert = UIAlertController(title: "IMPORTANT NOTICE:", message: msgToDisplay, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "I ACKNOWLEDGE", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }*/
    
    // handles what to do when user presses help navBarbutton
    @IBAction func navBarButton_back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // handles what to do when user presses back navBarbutton
    @IBAction func navBarButton_help(_ sender: UIBarButtonItem) {
        
        let alertMsg = "Welcome to the main table view. \n\nThis list is a collection of building addresses and corresponding descriptions of their respective bathroom(s). \n\nSelecting an entry will take you to a detailed-view page with specific information on bathrooms located within that building.\n\nAdditionally, using the respective icons located around this screen will allow you to add an entry to the database or force-refresh the table's contents.\n\nIn the detailed-view page, you will have the ability to review some qualities of the building/bathrooms, edit desired details, generate a GPS location pin, and more."
        
        let alert = UIAlertController(title: "Help Dialogue", message: alertMsg, preferredStyle: .alert)
        
        // handles what to do when user presses the CANCEL button in the alert
        alert.addAction(UIAlertAction(title: "DONE", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    /*==========================================================*/

    // used to create dictionary of bathroom locations (<TODO>: in coredata memory)
    /*func createLocDictionary() {
        
        print("Inside createLocDictionary().")  // debug
        
        if (firstTimeOpening == true) {
            
            // set bool catch to false and proceed with dictionary build
            firstTimeOpening = false
            
            print("Building dictionary for first time.")
            
            // for each location in the location list from the loc object
            for loc in myLocList.bathroomLocations {
                // extract the first letter as a string for the key
                let lBuilding = loc.locBuilding
                
                let endIndex = lBuilding.index((lBuilding.startIndex), offsetBy: 1)
                
                let locKey = String(lBuilding[(..<endIndex)])
                
                // build the location object array for each key
                if var locObjects = locList[locKey] {
                    locObjects.append(loc)
                    locList[locKey] = locObjects
                } else {
                    locList[locKey] = [loc]
                }
                
            }
        }else{
            // do nothing, as the dictionary does not need to be rebuilt after first open
            print("Dictionary does not need to be rebuilt.")
        }
    }*/
    
    /*==========================================================*/
    /*
    func initCounter() {
        counter = UserDefaults.init().integer(forKey: "counter")
    }
    
    func updateCounter() {
        counter += 1
        UserDefaults.init().set(counter, forKey: "counter")
        UserDefaults.init().synchronize()
    }
    */
    /*==========================================================*/
    
    // func to hide keyboard when tap somehere else in the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        //self.resignFirstResponder()
        super.touchesBegan(touches, with: event)
    }
    
    /*==========================================================*/
    
    // delegate to return the number of rows in a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of rows based on the coredata storage
        return fetchRecord()
    }
    
    // delegate to build the actual table from coredata, including the section headers/keys and each row individually
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // add each row from coredata fetch results
        let Lcell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocTableCells
        Lcell.layer.borderWidth = 1.0
        Lcell.locTitle?.text = fetchResults[indexPath.row].buildingName
        Lcell.locDescription.text = fetchResults[indexPath.row].buildingDescription
        //Lcell.locImage.image = fetchResults[indexPath.row].buildingImage
        
        if let image = fetchResults[indexPath.row].buildingImage {
            Lcell.locImage?.image =  UIImage(data: image as Data)
        } else {
            Lcell.locImage?.image = nil
        }
        return Lcell
    }
    
    // delegate to allow row entry editting
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // delegate to return the table view style as deletable
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle { return UITableViewCellEditingStyle.delete }
    
    // delegate to deal with swipe-to-delete entry functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            // delete the selected object from the managed object context
            managedObjectContext.delete(fetchResults[indexPath.row])
            // remove it from the fetch results array
            fetchResults.remove(at:indexPath.row)
            
            do {
                // save the updated managed object context
                try managedObjectContext.save()
            } catch {
                
            }
            // reload the table after deleting a row
            self.table_bthrmLocs.reloadData()
        }
    }
    
    // delegate to change row height to be larger in order to more-easily display entry info
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        userSelectedRowEntry = fetchResults[indexPath.row]
    }*/
    
    /*// delegate to set number of sections in table
    func numberOfSections(in tableView: UITableView) -> Int {
        // get the section count
        //return myLocList.tableSectionTitles.count
        
        // number of rows based on the coredata storage
        //return fetchRecord()
        return 26
    }*/
    
    /*// delegate to return the heading string for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // returns the heading for each section
        return myLocList.tableSectionTitles[section]
    }*/
    
    /*==========================================================*/

    
    

    
    
    
    
    
    
}









