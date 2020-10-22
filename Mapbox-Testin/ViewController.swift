//
//  ViewController.swift
//  Mapbox-Testin
//
//  Created by Daniel Bachar on 22/10/2020.
//

import UIKit
import Mapbox
import MapboxNavigation
import CoreLocation

class ViewController: UIViewController {
    
    var mapView: MGLMapView?
    
    weak var parkingView: CustomAnnotationView?
    
    var userLoction: CLLocationCoordinate2D? {
        mapView?.userLocation?.coordinate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let u = URL(string: "mapbox://styles/azatiinteractivemaps/ck0dldw8q0t7f1dqunjgv3yms")
        
        let mapView = MGLMapView(frame: view.bounds, styleURL: u)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.showsUserLocation = true
        self.mapView = mapView
         
        view.addSubview(mapView)
    }


}

extension ViewController: MGLMapViewDelegate {
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        self.mapView?.showsUserHeadingIndicator = true
        self.mapView?.allowsScrolling = true
        self.mapView?.allowsZooming = true
        
        let a = MGLPointAnnotation()
        a.coordinate = userLoction!
        self.mapView?.addAnnotations([a])
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MGLMapView, withError error: Error) {
        print(error)
    }
    
    public func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
      
    if annotation is  MGLPointAnnotation {
        let v = CustomAnnotationView(reuseIdentifier: "crack")
        let size = CGSize(width: 32, height: 40) // tried different sizes - even cover the hole user
        v.layer.zPosition = CGFloat(Int.max) // tried setting to fron
        v.bounds = CGRect(origin: .zero, size: size)
        parkingView = v
        return v
    }
//        return nil
      guard annotation is MGLUserLocation, mapView.userLocation != nil else {
        return nil
      }

      var userLocationAnnotationView = mapView.dequeueReusableAnnotationView(
        withIdentifier: UserLocationAnnotationView.description())

      // If there is no reusable annotation view available, initialize a new one.
      if userLocationAnnotationView == nil {
        userLocationAnnotationView = UserLocationAnnotationView(
          reuseIdentifier: UserLocationAnnotationView.description())
      }
      userLocationAnnotationView?.cornerRadius = 80 / 2
      let size = CGSize(width: 80, height: 80)
      userLocationAnnotationView?.bounds = CGRect(origin: .zero, size: size)
        // tried disable and set to back
//      userLocationAnnotationView?.isEnabled = false
//      userLocationAnnotationView?.layer.zPosition = -1

      return userLocationAnnotationView
    }
    
    func mapView(_ mapView: MGLMapView, calloutViewFor annotation: MGLAnnotation) -> MGLCalloutView? {
      return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
      return false
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
      mapView.deselectAnnotation(annotation, animated: true)
    }
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        print("DB: - didUpdate")
        if let p = parkingView {
            self.mapView?.bringSubviewToFront(p)
        }
        
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
      print("DB: - didSelect - \(annotation)")
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotationView: MGLAnnotationView) {
        print("DB: - didSelect annotationView - \(String(describing: annotationView.annotation))")
    }
}

class CustomAnnotationView: MGLAnnotationView {
  private lazy var annotationImageView: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "inMapParking")
    view.contentMode  = .scaleAspectFit
    return view
  }()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    addSubview(annotationImageView)
    
    annotationImageView.translatesAutoresizingMaskIntoConstraints = false
    annotationImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    annotationImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    annotationImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    annotationImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    print("DB: - selected!")
  }
}


class UserLocationAnnotationView: MGLUserLocationAnnotationView, CourseUpdatable {
  private lazy var annotationImageView: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "InMapUserCar")
    view.contentMode  = .scaleAspectFit
    return view
  }()
    
    override var hitTestLayer: CALayer? {
        let l = CALayer()
        l.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
        return  l
    }
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    
    backgroundColor = UIColor.purple.withAlpha(0.2)
    addSubview(annotationImageView)
    
    annotationImageView.translatesAutoresizingMaskIntoConstraints = false
    annotationImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    annotationImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    annotationImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    annotationImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
//    override func update() {
//        if frame.isNull {
//        frame = CGRect(x: 0, y: 0, width: size, height: size)
//        return setNeedsLayout()
//        }
//
//        // Check whether we have the user’s location yet.
//        if CLLocationCoordinate2DIsValid(userLocation!.coordinate) {
//        setupLayers()
//        updateHeading()
//        }
//    }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    print("DB: - user selected!")
  }


}

extension UIColor {
    func withAlpha(_ newAlpha: Float) -> UIColor {
      var red = CGFloat()
      var green = CGFloat()
      var blue = CGFloat()
      var alpha = CGFloat()
      getRed(&red, green: &green, blue: &blue, alpha: &alpha)
      return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(newAlpha))
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
      get {
        return layer.cornerRadius
      }
      set {
        layer.cornerRadius = newValue
        layer.masksToBounds = newValue > 0
      }
    }
}
