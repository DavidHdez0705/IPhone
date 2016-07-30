//
//  ViewController.swift
//  iMap
//
//  Created by David Hernández on 07/06/16.
//  Copyright © 2016 David Hernández. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var MapDetails: UILabel!
    var manager:CLLocationManager!
    @IBOutlet var MapView: UIView!
    @IBOutlet weak var autolocation: UIImageView!
    var myLocations: [CLLocation] = []
    var zoom = 0
 
    
    @IBOutlet weak var screenshot: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup our Location Manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        //Setup our Map View
        Map.delegate = self
        Map.mapType = MKMapType.Hybrid
        
        Map.showsUserLocation = true
        
        self.view.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "panTo")
        autolocation.addGestureRecognizer(tapGesture)
        let tap = UITapGestureRecognizer(target: self, action: "takeScreenshot")
        screenshot.addGestureRecognizer(tap)
    
    }
    func takeScreenshot() -> UIImageView {
        UIGraphicsBeginImageContext(MapView.frame.size)
        MapView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        saveImgAlert()
        return UIImageView(image: image)
    }
    func saveImgAlert(){
        let alertVC = UIAlertController(
            title: "Guardada!!",
            message: "Verifica en galería",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC,animated: true,completion: nil)
    }
    
   
    func panTo(){
        let spanX = 0.007
        let spanY = 0.007
        let newRegion = MKCoordinateRegion(center: Map.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        Map.setRegion(newRegion, animated: true)
    }
    // MARK: Camera code
    
    @IBAction func CameraAction(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            let picker = UIImagePickerController()
        
            picker.delegate = self
            picker.sourceType = .Camera
            
            presentViewController(picker, animated: true, completion: nil)
            //let image = UIGraphicsGetImageFromCurrentImageContext()
            //UIGraphicsEndImageContext()
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
        }else{
            print("La cámara no se encuentra disponible")
            noCamera()
        }
        
    }
    /*let imagePicker: UIImagePickerController! = UIImagePickerController()
    @IBAction func CameraAction(sender: UIButton){
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                presentViewController(imagePicker, animated: true, completion: {})
            } else {
                print("Rear camera doesn't exist")
            }
        } else {
            print("Camera inaccessable")
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Got an image")
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
            let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, selectorToCall, nil)
        }
        imagePicker.dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user saves an image
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }*/
    //
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC,animated: true,completion: nil)
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        MapDetails.text = "\(locations[0])"
        myLocations.append(locations[0] )
        let spanX = 0.007
        let spanY = 0.007
        
        if (zoom<5){
            let newRegion = MKCoordinateRegion(center: Map.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
            Map.setRegion(newRegion, animated: true)
            zoom++
        }
        
        
        if (myLocations.count > 1){
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            Map.addOverlay(polyline)
        }
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.blueColor()
        polylineRenderer.lineWidth = 4
        return polylineRenderer
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

    

    

    



