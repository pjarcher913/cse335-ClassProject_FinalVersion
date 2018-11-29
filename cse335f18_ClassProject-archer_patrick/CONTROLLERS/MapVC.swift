//
//  MapVC.swift
//  cse335f18_ClassProject-archer_patrick
//
//  Created by Patrick Archer on 11/19/18.
//  Copyright © 2018 Patrick Archer - Self. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, MKMapViewDelegate {
    
    // segue-passed LocationEntity info
    var userSelectedLoc:LocationEntity?
    
    // segue-assed indexPath of user-selected Location entity/row
    var userSelectedIndex:IndexPath?
    
    // var to store address string of userSelected location (for MapKit utilization)
    var locationAddressString:String?
    var locationDestLat:String?
    var locationDestLon:String?
    
    // outlets for various placemarks
    var currentPlacemark: CLPlacemark?
    var sourcePlacemark: CLPlacemark?
    var destinationPlacemark: CLPlacemark?
    
    // required vars for map route calculation
    var currentTransportType = MKDirectionsTransportType.automobile
    var currentRoute: MKRoute?
    
    // outlet for mapview
    @IBOutlet weak var mapView: MKMapView!
    
    // label outlets to display calculated lat/lon coordinates to user
    @IBOutlet weak var label_latCoords: UILabel!
    @IBOutlet weak var label_lonCoords: UILabel!
    
    /*==========================================================*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // configure MapView delegate access and configuration
        self.mapView.delegate = self;
        self.mapView.mapType = .standard
        
        // check iOS version compatibility
        if #available(iOS 9.0, *) {
            mapView.showsCompass = true
            mapView.showsScale = true
            mapView.showsTraffic = true
        }
        
        // set displayed initial lat/lon coordinates to nil (until calculated by geocoder)
        self.label_latCoords.text = ""
        self.label_lonCoords.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // start route calculation and display
        getLocation1()
    }
    
    /*==========================================================*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    /*==========================================================*/
    
    // mapView delegate to configure route rendering
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = (currentTransportType == .automobile) ? UIColor.blue : UIColor.orange
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
    /*==========================================================*/
    
    @IBAction func barButton_back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func barButton_help(_ sender: UIBarButtonItem) {
        let msgToDisplay:String =
        "This view displays a GPS marker/CLPlacemark pertaining to the location you previously selected.\n\nSimply press the \"Back\" button to go back to the previous view."
        
        let alert = UIAlertController(title: "Help Dialogue", message: msgToDisplay, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    /*==========================================================*/
    
    func getLocation1()
    {
        let geoCoder = CLGeocoder();
        
        let addressString = "\((self.userSelectedLoc?.buildingName)!)"
        
        print("\nAddressString being geocoded: \(addressString)\n") // debug
        
        CLGeocoder().geocodeAddressString(addressString, completionHandler:
            {(placemarks, error) in
                
                if error != nil {
                    print("Geocode failed: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    let placemark = placemarks![0]
                    self.destinationPlacemark = placemark
                    let location = placemark.location
                    let coords = location!.coordinate
                    
                    self.locationDestLat = String(coords.latitude)
                    self.locationDestLon = String(coords.longitude)
                    
                    self.label_latCoords.text = "\(String(describing: self.locationDestLat!))"
                    self.label_lonCoords.text = "\(String(describing: self.locationDestLon!))"
                    
                    let span = MKCoordinateSpanMake(1.0, 1.0)
                    let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                    self.mapView.setRegion(region, animated: true)
                    let ani = MKPointAnnotation()
                    ani.coordinate = placemark.location!.coordinate
                    ani.title = placemark.locality
                    ani.subtitle = placemark.subLocality
                    
                    self.mapView.addAnnotation(ani)
                    
                    //self.getLocation2()
                }
        })
    }


}
