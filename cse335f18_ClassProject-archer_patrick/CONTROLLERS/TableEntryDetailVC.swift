//
//  TableEntryDetailVC.swift
//  cse335f18_ClassProject-archer_patrick
//
//  Created by Patrick Archer
//  Copyright © 2018 Patrick Archer - Self. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class TableEntryDetailVC: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var image_selectedLoc: UIImageView!
    @IBOutlet weak var label_locBuilding: UILabel!
    @IBOutlet weak var label_locDesc: UILabel!
    @IBOutlet weak var label_selectedLocBuilding: UILabel!
    @IBOutlet weak var label_selectedLocDesc: UILabel!
    
    @IBOutlet weak var label_reviewsHeader: UILabel!
    @IBOutlet weak var slider_cleanliness: UISlider!
    @IBOutlet weak var slider_popularityOfPublicUse: UISlider!
    @IBOutlet weak var slider_easeOfAccess: UISlider!
    @IBOutlet weak var label_reviewCleanliness: UILabel!
    @IBOutlet weak var label_reviewPopularity: UILabel!
    @IBOutlet weak var label_reviewEofA: UILabel!
    @IBOutlet weak var label_cleanlinessSliderValue: UILabel!
    @IBOutlet weak var label_popularitySliderValue: UILabel!
    @IBOutlet weak var label_eofaSliderValue: UILabel!
    
    // when the user selects an entry from the table in the previous view,
    // this var gets passed the bathroomLocation object so we have all corresponding info
    var userSelectedLoc:LocationEntity?
    
    // indexPath of user-selected Location entity/row
    var userSelectedIndex:IndexPath?
    
    // temp vars for when user is editting values but hasnt hit save yet (so no overwriting happens immediately)
    var tempBuildingName:String?
    var tempBuildingDesc:String?
    var tempBuildingImage:NSData?
    var tempReviewCleanliness:Int16?
    var tempReviewPopularity:Int16?
    var tempReviewEofA:Int16?
    
    // init ImagePickerController
    let picker = UIImagePickerController()
    var selectedImage:UIImage?
    
    /*==========================================================*/
    // configure CoreData utilization
    
    // handler to the managege object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //this is the array to store location entities from the coredata
    var fetchResults = [LocationEntity]()
    
    func fetchRecord() -> Void {
        
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
        
    }
    
    /*// func to handle when fetching record data from CoreData
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
        
    }*/
    
    /*func updateLastRow() {
        let indexPath = IndexPath(row: fetchResults.count - 1, section: 0)
        self.table_bthrmLocs.reloadRows(at: [indexPath], with: .automatic)
    }*/
    
    /*==========================================================*/

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Now executing via TableEntryDetailVC.")  // debug
        
        picker.delegate = self
        
        self.fetchRecord()
        print("\nDetailedView Fetch Result count: \(fetchResults.count)") // debug
        print("User selected obj from fetchedResults: \(fetchResults[(userSelectedIndex?.row)!])\n")    // debug
        
        /*print("Passed building name: \(passedLocBuilding!)")   // debug
        print("Passed bathroom description: \(passedLocDesc!)")   // debug*/
        print("\nPassed full location object: \(userSelectedLoc.debugDescription)") // debug
        print("Passed loc object building: \(userSelectedLoc?.buildingName)\n")  // debug
        
        // set temp values to initially-passed data; update these vs the actual values in the entity, and when the user hits save, then save the temp values to what is actually stored in CoreData
        tempBuildingName = userSelectedLoc?.buildingName
        tempBuildingDesc = userSelectedLoc?.buildingDescription
        tempBuildingImage = userSelectedLoc?.buildingImage
        tempReviewCleanliness = userSelectedLoc?.ratingCleanliness
        tempReviewPopularity = userSelectedLoc?.ratingPopularity
        tempReviewEofA = userSelectedLoc?.ratingEofA
        
        // set initial values for all view heading labels, images, etc.
        self.label_locBuilding.text = "Building/Location Name: "
        self.label_locDesc.text = "Description: "
        //self.label_selectedLocBuilding.textColor
        self.label_selectedLocBuilding.text = tempBuildingName  //userSelectedLoc?.buildingName
        //self.label_selectedLocDesc.textColor
        self.label_selectedLocDesc.text = tempBuildingDesc  //userSelectedLoc?.buildingDescription
        self.label_selectedLocDesc.sizeToFit()
        self.label_selectedLocDesc.textAlignment = .center
        //self.image_selectedLoc.image = UIImage(data: userSelectedLoc?.buildingImage as! Data)
        
        if let image = tempBuildingImage {   // userSelectedLoc?.buildingImage
            self.image_selectedLoc.image =  UIImage(data: image as Data)
        } else {
            self.image_selectedLoc.image = nil
        }
        
        // set initial values for sliders to whatever is currently stored as a rating in CoreData
        self.label_reviewsHeader.text = "YOUR REVIEWS:"
        self.label_reviewCleanliness.text = "Cleanliness: "
        self.label_reviewPopularity.text = "Popularity: "
        self.label_reviewEofA.text = "Ease of Access: "
        self.slider_cleanliness.value = Float((tempReviewCleanliness)!)    //Float((self.userSelectedLoc?.ratingCleanliness)!)
        self.label_cleanlinessSliderValue.text = String(Int(self.slider_cleanliness.value))
        self.slider_popularityOfPublicUse.value = Float((tempReviewPopularity)!)  //Float((self.userSelectedLoc?.ratingPopularity)!)
        self.label_popularitySliderValue.text = String(Int(self.slider_popularityOfPublicUse.value))
        self.slider_easeOfAccess.value = Float((tempReviewEofA)!)   //Float((self.userSelectedLoc?.ratingEofA)!)
        self.label_eofaSliderValue.text = String(Int(self.slider_easeOfAccess.value))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*==========================================================*/
    
    // used by segue handler to prepare for segue and pass data to the next ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "segueToMapVC"){
            if let mapVCViewController: MapVC = segue.destination as? MapVC
            {
                print("Prepare for segue to: MapVC view.")    // debug
                
                mapVCViewController.userSelectedLoc = fetchResults[(userSelectedIndex?.row)!]
                mapVCViewController.userSelectedIndex = userSelectedIndex
                
                //let indexPath = self.table_bthrmLocs.indexPathForSelectedRow!
                //destinationViewController.userSelectedLoc = fetchResults[indexPath.row]
                //destinationViewController.userSelectedLoc = fetchResults[indexPath.row]
                //destinationViewController.userSelectedIndex = indexPath
                
                
                //print("\nName of Building Passed: \(destinationViewController.userSelectedLoc?.buildingName!)") // debug
                //print("Index of Building Passed: \(destinationViewController.userSelectedIndex?.description)") // debug
                //print("ObjectID of building Passed: \(fetchResults[selectedIndex.row].objectID)\n")
                
                //self.table_bthrmLocs.reloadData()
                
            }
         }
        
    }
    
    // used by exit handler to unwind segue and pass data to the original page
    @IBAction func unwindSegue(segue: UIStoryboardSegue)
    {
        print("Unwinding segue from: TableEntryDetailVC view.")
        
        /*if let tableVC1ViewController = segue.source as? TableVC1
         {
         //let dataReceived = sourceViewController.passedLocName
         //print("Unwinding segue from: \(String(dataReceived))")    // debug
         print("")   // debug
         
         }*/
    }
    
    /*==========================================================*/
    
    // handles what happens when the user is dragging the cleanliness slider
    @IBAction func slider_cleanliness(_ sender: UISlider) {
        tempReviewCleanliness = Int16(self.slider_cleanliness.value)
        self.label_cleanlinessSliderValue.text = String(tempReviewCleanliness!)   //String(Int(self.slider_cleanliness.value))
    }
    
    // handles what happens when the user is dragging the popularityOfUse slider
    @IBAction func slider_popularityOfPublicUse(_ sender: UISlider) {
        tempReviewPopularity = Int16(self.slider_popularityOfPublicUse.value)
        self.label_popularitySliderValue.text = String(tempReviewPopularity!)    //String(Int(self.slider_popularityOfPublicUse.value))
    }
    
    // handles what happens when the user is dragging the EofA slider
    @IBAction func slider_easeOfAccess(_ sender: UISlider) {
        tempReviewEofA = Int16(self.slider_easeOfAccess.value)
        self.label_eofaSliderValue.text = String(tempReviewEofA!)  //String(Int(self.slider_easeOfAccess.value))
    }
    
    // handles what to do when user presses the Back button
    @IBAction func navBarButton_back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // handles what to do when user presses the Help button
    @IBAction func barButton_help(_ sender: UIBarButtonItem) {
        let msgToDisplay:String =
        "This view displays all information pertaining to the location you previously selected from the table.\n\nSimply press the \"Back\" button to discard changes and go back to the previous view. Changes will NOT be saved UNTIL you press the \"Save\" button.\n\nPressing the \"Edit\" button will display a prompt that allows you to change this location's information. Additionally, you may adjust the slider values to your desired ratings for each criteria.\n\nTapping the \"Change Picture\" button will prompt you to select a new picture (from your photo library) to change it to.\n\nPressing the \"GPS\" button will generate a GPS pin to this location and will display the pin via a map-view annotation. You will be taken to a new screen (the map view)."
        
        let alert = UIAlertController(title: "Help Dialogue", message: msgToDisplay, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    // handles what to do when user presses editEntry barbutton ("Edit")
    @IBAction func barbutton_editEntry(_ sender: UIBarButtonItem) {
        
        let msgToDisplay:String =
        "Please edit the values as you desire. NOTE: If you leave a text field blank, the blank will be saved (previous value does not carry over, if field left blank).\n\nWhen finished, press SUBMIT. If you would like to cancel all changes, press CANCEL."
        
        let alert = UIAlertController(title: "Edit Information", message: msgToDisplay, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = self.tempBuildingName
        })
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = self.tempBuildingDesc
        })
        
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "SUBMIT", style: .default, handler: { action in
            self.tempBuildingName = alert.textFields![0].text
            self.tempBuildingDesc = alert.textFields![1].text
            
            self.label_selectedLocBuilding.text = self.tempBuildingName
            self.label_selectedLocDesc.text = self.tempBuildingDesc
        }))
        
        self.present(alert, animated: true)
    }
    
    // handles what to do when user presses saveEntry barbutton ("Save")
    @IBAction func barbutton_saveEntry(_ sender: UIBarButtonItem) {
        
        //print("fetchResults[userSelectedIndex!.row].buildingName: \(fetchResults[userSelectedIndex!.row].buildingName)")  // debug
        //print("fetchResults[userSelectedIndex!.row].buildingDesc: \(fetchResults[userSelectedIndex!.row].buildingDescription)")   // debug
        
        // take tempVars and save their values to the user's selected CoreData entry
        fetchResults[(userSelectedIndex?.row)!].buildingName = self.tempBuildingName
        fetchResults[(userSelectedIndex?.row)!].buildingDescription = self.tempBuildingDesc
        fetchResults[(userSelectedIndex?.row)!].buildingImage = self.tempBuildingImage
        fetchResults[(userSelectedIndex?.row)!].ratingCleanliness = self.tempReviewCleanliness!
        fetchResults[(userSelectedIndex?.row)!].ratingPopularity = self.tempReviewPopularity!
        fetchResults[(userSelectedIndex?.row)!].ratingEofA = self.tempReviewEofA!
        
        //print("NEW fetchResults[userSelectedIndex!.row].buildingName: \(fetchResults[(userSelectedIndex?.row)!].buildingName)") // debug
        //print("NEW fetchResults[userSelectedIndex!.row].buildingDesc: \(fetchResults[userSelectedIndex!.row].buildingDescription)") // debug
        
        // take values and save them to CoreData
        do {
            // save the updated managed object context
            try managedObjectContext.save()
        } catch {   }
        
        let msgToDisplay:String =
        "The current information for the selected building has been successfully saved to this device's memory.\n\nPreviously-made changes to the data will now persist after you tap the \"Back\" button."
        
        let alert = UIAlertController(title: "NOTICE:", message: msgToDisplay, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    // handles what to do when user presses GPS bar button
    // -> open standalone navigation app, generate CLPlacemarks, call APIs, generate directions
    @IBAction func barbutton_getGPSDirections(_ sender: UIBarButtonItem) {
        
        print("Now executing barbutton_getGPSDirections.") // debug
        
        //...
        
    }
    
    // handles what happens when user presses "Change Image" bar button
    @IBAction func barButton_changeImage(_ sender: UIBarButtonItem) {
        print("\nNow executing changeImage func.\n")   // debug
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
    }
    
    /*==========================================================*/
    
    // delegate to control what happens when an image is selected from the library by the user
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        picker .dismiss(animated: true, completion: nil)
        
        let selectedImageAsUIImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        tempBuildingImage = UIImagePNGRepresentation(selectedImageAsUIImage!)! as NSData
        
        /*if let selectedImageAsImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            tempBuildingImage = selectedImageAsImage as! Data
        }*/
        
        self.image_selectedLoc.image = selectedImageAsUIImage
    }
    
    // delegate to handle if the user presses cancel in the image picker view
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}











