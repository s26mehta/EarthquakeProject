//
//  WhereToGoViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-11.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit
import MapKit

class WhereToGoViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    let initialLocation = CLLocation(latitude: currentLocation[0], longitude: currentLocation[1])
    let hospital = CLLocation(latitude: 43.458543, longitude: -80.5185419)
    let regionRadius: CLLocationDistance = 1000
    
    let request: MKDirectionsRequest = MKDirectionsRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        centerMapOnLocation(initialLocation)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
