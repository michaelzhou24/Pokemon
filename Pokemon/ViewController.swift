//
//  ViewController.swift
//  Pokemon
//
//  Created by Michael Zhou on 2018-07-13.
//  Copyright © 2018 Michael Zhou. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var updateCount = 0
    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    var pokemons : [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        pokemons = getAllPokemon()
        mapView.delegate = self
        if CLLocationManager.authorizationStatus()
            != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = true
        manager.delegate = self
        manager.startUpdatingLocation()
        Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { (timer) in
            print("Timer")
            if let coord = self.manager.location?.coordinate {
                let anno = MKPointAnnotation()
                anno.coordinate = coord
                anno.coordinate.latitude += (Double(arc4random_uniform(200)) - 100) / 50000
                anno.coordinate.longitude += (Double(arc4random_uniform(200)) - 100) / 50000
                self.mapView.addAnnotation(anno)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func centreButton(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 500, 500)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 500, 500)
            mapView.setRegion(region, animated: true)
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation {
            annoView.image = UIImage(named: "player")
        } else {
            annoView.image = UIImage(named: "mew")
        }
        var frame = annoView.frame
        frame.size.height = 30
        frame.size.width = 30
        annoView.frame = frame
        return annoView
    }


}

