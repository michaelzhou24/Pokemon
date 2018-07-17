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
        if CLLocationManager.authorizationStatus()
            == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            manager.delegate = self
            manager.startUpdatingLocation()
            Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
                print("Timer")
                if let coord = self.manager.location?.coordinate {
                    let pokemon = self.pokemons[Int((arc4random_uniform(UInt32(self.pokemons.count))))]
                    let anno = PokeAnnotation(coordinate: coord, pokemon: pokemon)
                    anno.coordinate = coord
                    anno.coordinate.latitude += (Double(arc4random_uniform(200)) - 100) / 50000
                    anno.coordinate.longitude += (Double(arc4random_uniform(200)) - 100) / 50000
                    self.mapView.addAnnotation(anno)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func centreButton(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 250, 250)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 250, 250)
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
            let pokemon = (annotation as! PokeAnnotation).pokemon
            annoView.image = UIImage(named: pokemon.image!)
        }
        var frame = annoView.frame
        frame.size.height = 30
        frame.size.width = 30
        annoView.frame = frame
        return annoView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation! is MKUserLocation {
            return
        }
        print("tapped annotation")
        mapView.deselectAnnotation(view.annotation!, animated: true)
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 250, 250)
        mapView.setRegion(region, animated: true)
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            if let coord = self.manager.location?.coordinate {
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    print("Can catch!")
                    let pokemon = (view.annotation! as! PokeAnnotation).pokemon
                    pokemon.isCaught = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    let alertVC = UIAlertController(title: "Congrats!", message: "You caught the \(pokemon.name!)!", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    }))
                    alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alertVC, animated: true, completion: nil)
                    mapView.removeAnnotation(view.annotation!)
                } else {
                    print("Pokemon too far!")
                    let alertVC = UIAlertController(title: "Pokemon is too far away..", message: "Try to move closer!", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
}

