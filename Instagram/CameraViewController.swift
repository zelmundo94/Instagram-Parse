//
//  CameraViewController.swift
//  Instagram
//
//  Created by Denzel Ketter on 3/7/16.
//  Copyright © 2016 Denzel Ketter. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import AVFoundation



class CameraViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    @IBOutlet weak var libraryView: UIView!
    @IBOutlet weak var libImageView: UIImageView!
    @IBOutlet weak var captureView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var captionTextField2: UITextField!
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var draftImage: UIImage!
    let imagePicker = UIImagePickerController()



    @IBAction func indexChanged(sender: AnyObject) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            libraryView.hidden = true
            captureView.hidden = false
            captionTextField.hidden = true
            
        case 1:
            libraryView.hidden = false
            captureView.hidden = true
        default:
            break;
        }
        
    }
    
    @IBAction func didTakePhoto(sender: UIButton) {
        
        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
                if (sampleBuffer != nil) {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    self.capturedImage.image = image
                    self.capturedImage.hidden = false
                    self.captionTextField.hidden = false
                    self.submitButton.hidden = false
                    self.retakeButton.hidden = false
                    sender.hidden = true

                }
            })
        }
        
    }
    
    @IBAction func choosePhoto(sender: AnyObject) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        libraryView.hidden = true
        captureView.hidden = false
        captionTextField.hidden = true
        imagePicker.delegate = self

        

        
        /*
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification,
            object: nil
        )
*/
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            if captureSession!.canAddOutput(stillImageOutput) {
                captureSession!.addOutput(stillImageOutput)
                
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
                cameraView.layer.addSublayer(previewLayer!)
                
                captureSession!.startRunning()
            }
        }
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //previewLayer!.frame = cameraView.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    

    @IBAction func pressedRetake(sender: UIButton) {
        
        self.view.endEditing(true)

        
        captureSession!.startRunning()
        viewDidLoad()
        capturedImage.hidden = true
        captionTextField.hidden = true
        captureButton.hidden = false
        submitButton.hidden = true
        retakeButton.hidden = true
    
        print("Retake!")

    }

    @IBAction func editingDidBegin(sender: AnyObject) {
        
        
        animateViewMoving(true, moveValue: 150)

    }
    
    @IBAction func editingDidEnd(sender: AnyObject) {
        self.view.endEditing(true)
        animateViewMoving(false, moveValue: 150)


    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }

    @IBAction func onSubmitPhoto(sender: AnyObject) {
        self.view.endEditing(true)

        // NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        //If statement does not prevent crash
        if capturedImage.image != nil && captionTextField.text != nil {
            
            submitPostToParse()
        }
            
        else {
            print("ERROR! No image and/or caption")
        }
        
        

    }
    
    @IBAction func onSubmit2(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        // NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        //If statement does not prevent crash
        if libImageView.image != nil && captionTextField.text != nil {
            
            submitPostToParse2()
        }
            
        else {
            print("ERROR! No image and/or caption")
        }
    }
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            
            self.draftImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            // Update UI to reflect selected image
            self.libImageView.image = self.draftImage
            self.libImageView.alpha = 1
            self.libImageView.backgroundColor = UIColor.whiteColor()
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func submitPostToParse() {
        
        // Resize and compress image
        // The image must be under 10 MB to store in Parse
        // Ideally this would be done on a background thread
        let scaledImage = self.resize((self.capturedImage.image)!, newSize: CGSizeMake(750, 750))
        let imageData = UIImageJPEGRepresentation(scaledImage, 0)
        let imageFile = PFFile(name:"image.jpg", data:imageData!)
        
        let photo = PFObject(className: "Photo")
        photo["image"] = imageFile
        
        let post = PFObject(className: "Post")
        post["photo"] = photo
        post["caption"] = self.captionTextField.text
        post.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print("Error saving post: \(error.description)")
            } else {
                print("Post saved successfully")
                self.initializeViews()
                self.tabBarController!.selectedIndex = 0;
            }
        }
    }
    func submitPostToParse2() {
        
        // Resize and compress image
        // The image must be under 10 MB to store in Parse
        // Ideally this would be done on a background thread
        let scaledImage = self.resize((self.libImageView.image)!, newSize: CGSizeMake(750, 750))
        let imageData = UIImageJPEGRepresentation(scaledImage, 0)
        let imageFile = PFFile(name:"image.jpg", data:imageData!)
        
        let photo = PFObject(className: "Photo")
        photo["image"] = imageFile
        
        let post = PFObject(className: "Post")
        post["photo"] = photo
        post["caption"] = self.captionTextField2.text
        post.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                print("Error saving post: \(error.description)")
            } else {
                print("Post saved successfully")
                self.initializeViews()
                self.tabBarController!.selectedIndex = 0;
            }
        }
    }

    func initializeViews() {
        self.capturedImage.image = nil
        self.captionTextField.text = ""
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
