//
//  CameraViewController.swift
//  iMap
//
//  Created by David Hernández on 07/06/16.
//  Copyright © 2016 David Hernández. All rights reserved.
//

import UIKit
import MessageUI

class SMessageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,MFMailComposeViewControllerDelegate  {
    
    @IBOutlet weak var CameraDisplay: UIImageView!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var Gallery: UIButton!
    @IBOutlet weak var destinatario: UITextField!
    @IBOutlet weak var scroller: UIScrollView!
    
    // MARK: Camera code
    
    
    @IBAction func CameraAction(sender: UIButton) {
        
        LaunchGallery()
        
    }
    @IBAction func GalleryAction(sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        CameraDisplay.image = info[UIImagePickerControllerOriginalImage] as? UIImage;
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func returnPressed(sender: UITextField) {
        self.view.endEditing(true)
    }
    func LaunchGallery(){
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
    }
    @IBAction func clearText(){
        if (destinatario.text == "Introduce destinatario!!!"){
            destinatario.text = ""
            destinatario.textColor = UIColor.blackColor()
        }
        if (message.text == "Introduce mensaje!!!"){
            message.text = ""
            message.textColor = UIColor.blackColor()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "LaunchGallery")
        CameraDisplay.addGestureRecognizer(tapGesture)
        scroller.contentSize = CGSize(width: 320,height: 1000)
        scroller.scrollEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:  Send email
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        if (!(destinatario.text == "" || message.text == "")){
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
                print("Mensaje enviado!!!")
            
            } else {
                self.showSendMailErrorAlert()
                print("Sorry carnal ")
            }
        } else {
            if (destinatario.text == ""){
                destinatario.text = "Introduce destinatario!!!"
                destinatario.textColor = UIColor.redColor()
            }
            if (message.text == ""){
                message.text = "Introduce mensaje!!!"
                message.textColor = UIColor.redColor()
            }
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([destinatario.text!])
        mailComposerVC.setSubject("Hi!, I'm using iMap!")
        mailComposerVC.setMessageBody(message.text!, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: Send image
    
    @IBAction func postEmail() {
        if (!(destinatario.text == "" || message.text == "")){
            var mail:MFMailComposeViewController = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            //mail.setSubject("your subject here")
            mail.setToRecipients([destinatario.text!])
            mail.setSubject("Hi!, I'm using iMap!")
        
            var image = CameraDisplay.image
            var imageString = returnEmailStringBase64EncodedImage(image!)
            var emailBody = "<html><body><p>\(message.text)'</p><br><img src='data:image/jpeg;base64,\(imageString)' width='\(image!.size.width)' height='\(image!.size.height)'><br><h5>Ubicacion:</h5><br><a href='www.google.com.mx/maps/@32.5331546,-116.9652218,16z'>Map location link</a></body></html>"
            // width='\(image!.size.width)' height='\(image!.size.height)'
            // width=250 height=200
            mail.setMessageBody(emailBody, isHTML:true)
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mail, animated: true, completion:nil)
                print("Mensaje enviado!!!")
                
            } else {
                self.showSendMailErrorAlert()
                print("Sorry carnal ")
            }
            
    
        } else {
            if (destinatario.text == ""){
                destinatario.text = "Introduce destinatario!!!"
                destinatario.textColor = UIColor.redColor()
            }
            if (message.text == ""){
                message.text = "Introduce mensaje!!!"
                message.textColor = UIColor.redColor()
            }
        }
    }
    
    func returnEmailStringBase64EncodedImage(image:UIImage) -> String {
        let imgData:NSData = UIImagePNGRepresentation(image)!;
        let dataString = imgData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return dataString
    }
    
    
}





