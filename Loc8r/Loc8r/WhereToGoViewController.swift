//
//  WhereToGoViewController.swift
//  Loc8r
//
//  Created by Nehal Kanetkar on 2016-07-11.
//  Copyright © 2016 SYDE361. All rights reserved.
//

import UIKit
import MapKit

var cancelShouldAppear: Bool = false

class WhereToGoViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var mapViewHeightConstraint: NSLayoutConstraint!
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
    let initialLocation = CLLocation(latitude: currentLocation[0], longitude: currentLocation[1])
    let hospital = CLLocationCoordinate2D(latitude: 43.470090, longitude: -80.553779)
//    let hospital = CLLocationCoordinate2D(latitude: 43.473449, longitude: -80.532994)
    let regionRadius: CLLocationDistance = 2000
    
    let request: MKDirectionsRequest = MKDirectionsRequest()

    override func viewWillAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        let modelName = UIDevice.currentDevice().modelName
        if (modelName == "iPhone 5") || (modelName == "iPhone 5c") || (modelName == "iPhone 5s") {
            mapViewHeightConstraint.constant = 292
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        centerMapOnLocation(initialLocation)
        
        setupMapDirections()
        
        tv.delegate = self
        tv.dataSource = self
        tv.alwaysBounceVertical = false
        tv.separatorColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
        
        notificationCenter.addObserver(self, selector:#selector(WhereToGoViewController.earthquakeOver), name: "EarthquakeEnd", object: nil)
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
        if indexPath.row == 0 {
            cancelShouldAppear = true
            tv.deselectRowAtIndexPath(indexPath, animated: true)
            performSegueWithIdentifier("resetStatus", sender: self)
        }
    }
    
    func setupMapDirections() {
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: initialLocation.coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: hospital, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .Walking
        
        let directions = MKDirections(request: request)
        
        directions.calculateDirectionsWithCompletionHandler { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.displayDistance(route.distance)
                self.mapView.addOverlay(route.polyline, level: .AboveRoads)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0), animated: true)
            }
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor(colorLiteralRed: 0, green: 122/255, blue: 255/255, alpha: 1.0)
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func displayDistance(distance: CLLocationDistance) {
        if distance >= 1000 {
            let distanceKM = distance / 1000
            UIView.animateWithDuration(0.4, animations: {
                self.distanceLabel.text = String(round(distanceKM * 10) / 10) + " km"
            })
        } else {
            UIView.animateWithDuration(0.4, animations: {
                self.distanceLabel.text = String(round(distance * 100) / 100) + " m"
            })
        }
    }
    
    func earthquakeOver() {
        performSegueWithIdentifier("earthquakeComplete", sender: nil)
    }
}
