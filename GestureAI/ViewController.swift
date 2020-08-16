//
//  ViewController.swift
//  GestureAI
//
//  Created by Harsh Verma on 07/04/20.
//  Copyright © 2020 Harsh Verma. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import AVKit

enum RemoteCommand: String {
    
    case none
    case open = "open"
    case fist = "fist"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var handImageView: UIImageView!
    @IBOutlet weak var playerView: PlayerView!
    
    // Camera Properties
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice!
    var devicePosition: AVCaptureDevice.Position = .front
    
    
    // Vision
    
    var requests = [VNRequest]()
    
    let bufferSize = 3
    var commandBuffer = [RemoteCommand]()
    var currentCommand: RemoteCommand = .none {
        didSet {
            commandBuffer.append(currentCommand)
            if commandBuffer.count == bufferSize {
                if commandBuffer.filter({$0 == currentCommand}).count == bufferSize {
                    // send commands
                    showAndSendCommand(currentCommand)
                }
                commandBuffer.removeAll()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupVision()
        setupPlayer()
        setupAirPlay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCamera()
    }
    
    
    func setupPlayer() {
        playerView.setPlayerURL(url: URL(string: "BR.mp4")!)
       // playerView.player.play()
    }
    
    
    func setupVision() {
        guard let visionModel = try? VNCoreMLModel(for: Handss().model) else {
            fatalError("Cant load ML Model")
        }
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
        classificationRequest.imageCropAndScaleOption = .centerCrop
        self.requests = [classificationRequest]
    }
    
    func setupAirPlay() {
        
        let airplay = AVRoutePickerView(frame: CGRect(x: 0, y: 40, width: 80, height: 80))
        airplay.center.x = self.view.center.x
        airplay.tintColor = UIColor.white
        self.view.addSubview(airplay)
        
    }
    
    func handleClassification(request: VNRequest, error: Error?) {
        
        guard let observations = request.results else {print("No results"); return}
        let classifications = observations.compactMap({$0 as? VNClassificationObservation}).filter({$0.confidence > 0.4}).map({$0.identifier})
        print(classifications)
        
        switch classifications.first {
        case "none":
            currentCommand = .none
        case "open":
            currentCommand = .open
        case "fist":
            currentCommand = .fist
        default:
            currentCommand = .none
        }
    }
    
    func showAndSendCommand(_ command: RemoteCommand) {
        DispatchQueue.main.async {
            if command == .open {
                self.playerView.player.play()
                self.handImageView.image = UIImage(named: command.rawValue)
            }else if command == .none{
                self.playerView.player.pause()
                self.handImageView.image = UIImage(named: command.rawValue)
            }
            
        }
    }
}

