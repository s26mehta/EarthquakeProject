//
//  WhereToGoViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-11.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit
import MapKit

class WhereToGoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tv: UITableView!
    
    let initialLocation = CLLocation(latitude: currentLocation[0], longitude: currentLocation[1])
    let hospital = CLLocation(latitude: 43.458543, longitude: -80.5185419)
    let regionRadius: CLLocationDistance = 1000
    
    let request: MKDirectionsRequest = MKDirectionsRequest()

    override func viewWillAppear(animated: Bool) {
        self.navigationItem.leftBarButtonItem = nil
    }
    
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCellWithIdentifier("goBack") as! MapPageTableViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            print("Should perform segue")
        }
    }
}
