//
//  WSHCameraView.swift
//  WhistScoreHolder
//
//  Created by OctavF on 13/08/16.
//  Copyright © 2016 WSHGmbH. All rights reserved.
//

import UIKit
import AVFoundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol WSHCameraViewDelegate: class {
    func cameraViewWantsToGiveCameraPermission(_ cameraView: WSHCameraView)
}

class WSHCameraView: UIView {
    
    var delegate: WSHCameraViewDelegate?
    var permissionGranted: Bool = false {
        didSet {
            if permissionGranted {
                self.addressTheUserView.isHidden = true
                self.cameraContainerView.isHidden = false
                self.overlayButtonsView.isHidden = false
                
                self.setupCamera()
                
            } else {
                self.addressTheUserView.isHidden = false
                self.cameraContainerView.isHidden = true
                self.overlayButtonsView.isHidden = true
            }
        }
    }
    
    @IBOutlet fileprivate weak var addressTheUserView: WSHAddressTheUserView!
    @IBOutlet fileprivate weak var cameraContainerView: UIView!
    @IBOutlet fileprivate weak var overlayButtonsView: WSHOverlayView!
    
    @IBOutlet fileprivate weak var previewView: UIView!
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var couldBeAToolbarView: WSHOverlayView!
    @IBOutlet fileprivate weak var couldBeATopbarView: WSHOverlayView!
    @IBOutlet fileprivate weak var takePicButton: WSHCircleButton!
    
    fileprivate var captureSession: AVCaptureSession?
    fileprivate var backCameraDevice: AVCaptureDevice?
    fileprivate var frontCameraDevice: AVCaptureDevice?
    fileprivate var currentCameraDevice: AVCaptureDevice?
    fileprivate var stillImageOutput: AVCaptureStillImageOutput?
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var videoConnection: AVCaptureConnection!
    
    fileprivate(set) var image: UIImage? {
        set(newImage) {
            self.imageView.image = newImage
            
            if (newImage != nil) {
                self.stopCamera()
            } else {
                self.imageView.contentMode = .scaleAspectFill
                self.startCamera()
            }
        }
        get {
            return self.imageView.image
        }
    }
    
    
    // MARK: - Lifecycle
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
        setupCamera()
        setupOverlayButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
        setupCamera()
        setupOverlayButtons()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.previewLayer?.position = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
        self.setupPreviewLayerOrientationDeviceDependent()
    }
    
    
    // MARK: - Public
    
    
    func setFitImage(_ givenImage: UIImage?) {
        self.image = givenImage
        
        if let _ = givenImage {
            self.imageView.contentMode = .scaleAspectFit
        }
    }
    
    
    // MARK: - Private
    
    
    fileprivate func xibSetup() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "WSHCameraView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
    fileprivate func setupCamera() {
        if self.permissionGranted {
            self.captureSession = AVCaptureSession()
            self.captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
            
            let availableCameraDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            
            for device in availableCameraDevices as! [AVCaptureDevice] {
                if device.position == .back {
                    self.backCameraDevice = device
                    self.setupDevice(self.backCameraDevice!)
                    
                } else if device.position == .front {
                    self.frontCameraDevice = device
                    self.setupDevice(self.frontCameraDevice!)
                }
            }
            if let _ = self.backCameraDevice {
                self.setupIntputTo(self.backCameraDevice!)
                
                self.stillImageOutput = AVCaptureStillImageOutput()
                self.stillImageOutput!.outputSettings = [AVVideoCodecJPEG: AVVideoCodecKey]
                
                if (self.captureSession?.canAddOutput(self.stillImageOutput) ?? false) {
                    self.captureSession!.addOutput(self.stillImageOutput)
                }
                
                let deviceMin = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
                
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.previewLayer?.frame = CGRect(x: 0.0, y: 0.0, width: deviceMin, height: deviceMin)
                self.previewLayer?.position = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
                self.previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                self.setupPreviewLayerOrientationDeviceDependent()
                
                self.previewView.layer.addSublayer(self.previewLayer!)
                
                self.videoConnection = self.stillImageOutput!.connection(withMediaType: AVMediaTypeVideo)
                
                self.startCamera()
            }
        }
    }
    
    fileprivate func setupOverlayButtons() {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.couldBeAToolbarView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        self.couldBeAToolbarView.layer.insertSublayer(gradient, at: 0)
        
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = self.couldBeATopbarView.bounds
        topGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        self.couldBeATopbarView.layer.insertSublayer(topGradient, at: 0)
    }
    
    fileprivate func startCamera() {
        self.captureSession?.startRunning()
        self.refreshInput()
        
        self.previewView.isHidden = false
        self.imageView.isHidden = true
        self.takePicButton.hasX = false
    }
    
    fileprivate func stopCamera() {
        self.captureSession?.stopRunning()
        
        self.previewView.isHidden = true
        self.imageView.isHidden = false
        self.takePicButton.hasX = true
    }
    
    fileprivate func setupIntputTo(_ inputDevice: AVCaptureDevice) {
        do {
            let input = try AVCaptureDeviceInput(device: inputDevice)
            
            if self.captureSession!.canAddInput(input) {
                self.captureSession!.addInput(input)
                
                self.currentCameraDevice = inputDevice
            }
        } catch {//let error {
//            presentError(error, fromController: nil)
        }
    }
    
    fileprivate func setupDevice(_ inputDevice: AVCaptureDevice) {
        let baseCameraSize = prefferedImageSize()
        let focusPoint = CGPoint(x: baseCameraSize.width / 2.0, y: baseCameraSize.height / 2.0)
        
        if inputDevice.isFocusPointOfInterestSupported {
            do {
                try inputDevice.lockForConfiguration()
                inputDevice.focusPointOfInterest = focusPoint
                inputDevice.focusMode = .autoFocus
                inputDevice.exposurePointOfInterest = focusPoint
                inputDevice.exposureMode = .autoExpose
            } catch {
                //ERR
            }
        }
    }
    
    fileprivate func setupPreviewLayerOrientationDeviceDependent() {
        if let connection = self.previewLayer?.connection  {
            connection.videoOrientation = self.avOrientation(UIDevice.current.orientation)
        }
    }
    
    fileprivate func imageOrientationForCurrentDeviceOrientation() -> UIImageOrientation {
        var imageOrientation: UIImageOrientation = .up
        
        if self.currentCameraDevice == self.frontCameraDevice {
            switch UIDevice.current.orientation {
            case .portrait:
                imageOrientation = .leftMirrored
                break
                
            case .portraitUpsideDown:
                imageOrientation = .right
                break
                
            case .landscapeRight:
                imageOrientation = .upMirrored
                break
            
            case .landscapeLeft:
                imageOrientation = .downMirrored
                break
                
            default:
                break
            }
            
        } else {
            switch UIDevice.current.orientation {
            case .portrait:
                imageOrientation = .right
                break
                
            case .portraitUpsideDown:
                imageOrientation = .left
                break
                
            case .landscapeRight:
                imageOrientation = .down
                break
                
            default:
                break
            }
        }
        return imageOrientation
    }
    
    fileprivate func avOrientation(_ forDeviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation {
        var result:AVCaptureVideoOrientation = .portrait
        
        switch forDeviceOrientation {
        case .landscapeLeft:
            result = .landscapeRight
            break
        case .landscapeRight:
            result = .landscapeLeft
            break
        default:
            break
        }
        return result
    }
    
    fileprivate func refreshInput() {
        if let asdf = self.currentCameraDevice {
            self.setupIntputTo(asdf)
            self.videoConnection = self.stillImageOutput!.connection(withMediaType: AVMediaTypeVideo)
        }
    }
    
    
    //MARK: - Actions
    
    
    @IBAction func didTap(_ sender: AnyObject) {
        if let _ = self.image {
            self.image = nil
            
        } else {
            self.stillImageOutput?.captureStillImageAsynchronously(from: self.videoConnection, completionHandler: {[weak self] (sampleBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                let dataProvider = CGDataProvider(data: imageData as! CFData)
                let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                let image = UIImage(cgImage: cgImageRef!, scale: 0.7, orientation: self?.imageOrientationForCurrentDeviceOrientation() ?? .up)
                
                self?.image = image
                
                if let imageView = self?.imageView {
                    if let visibleImage = UIImage.visibleImageFromImageView(imageView) {
                        self?.setFitImage(visibleImage)
                    }
                }
                if let maImage = self?.image {
                    self?.setFitImage(maImage.centerCroppedImage(prefferedImageSize()))
                }
                })
        }
    }
    
    @IBAction func didTapSwitchCamera(_ sender: AnyObject) {
        if self.image == nil {
            if self.captureSession?.inputs.count > 0 {
                if let input = self.captureSession?.inputs[0] as? AVCaptureInput {
                    self.captureSession?.removeInput(input)
                }
                if self.currentCameraDevice == self.frontCameraDevice {
                    self.currentCameraDevice = self.backCameraDevice
                } else {
                    self.currentCameraDevice = self.frontCameraDevice
                }
            }
            
            UIView.transition(with: self.previewView, duration: kAnimationDuration, options: .transitionFlipFromLeft, animations: {
                self.previewView.isHidden = true
                }, completion: { (_) in
                    UIView.transition(with: self.previewView, duration: kAnimationDuration, options: .transitionFlipFromLeft, animations: {
                        self.previewView.isHidden = false
                        }, completion: nil)
                    
                    self.refreshInput()
            })
        }
    }
    
    @IBAction func wannaGivePermission(_ sender: AnyObject) {
        if let asdf = self.delegate {
            asdf.cameraViewWantsToGiveCameraPermission(self)
        }
    }
    
}
