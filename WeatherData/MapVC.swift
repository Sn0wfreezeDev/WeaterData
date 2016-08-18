//
//  MapVC.swift
//  WeatherData
//
//  Created by Alexander Heinrich on 16/08/16.
//  Copyright © 2016 Sn0wfreeze Development UG. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var location : CLLocationCoordinate2D!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let annotation = CustomAnnotation(withLocation: location)
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "annotate")
        annotationView.centerOffset = CGPointMake(20, 20)
        
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
        self.mapView.region = region
        
        self.mapView.addAnnotation(annotation)
        
        self.navigationItem.title = "\(WeatherCollection.sharedCollection.locationName) - Map View"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(withLocation location : CLLocationCoordinate2D) {
        coordinate = location
    }
}
