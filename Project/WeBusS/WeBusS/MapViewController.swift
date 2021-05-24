//
//  MapViewController.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/05/25.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnnotation(latiValue: locationY.doubleValue, longtiValue: locationX.doubleValue, delta: 0.1, title: "Bus", subtitle: "Station")
    }
    
    func setAnnotation(latiValue: CLLocationDegrees, longtiValue: CLLocationDegrees, delta span: Double, title strTitle: String, subtitle strSubTitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latiValue: latiValue, longtiValue: longtiValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        mapView.addAnnotation(annotation)
    }
    
    func goLocation(latiValue: CLLocationDegrees, longtiValue: CLLocationDegrees, delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latiValue, longtiValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        
        mapView.setRegion(pRegion, animated: true)
        return pLocation
    }
}
