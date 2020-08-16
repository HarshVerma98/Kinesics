//
//  PlayerView.swift
//  GestureAI
//
//  Created by Harsh Verma on 07/04/20.
//  Copyright © 2020 Harsh Verma. All rights reserved.
//

import UIKit
import AVFoundation
class PlayerView: UIView {

    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!

    func setPlayerURL(url: URL) {
        player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "BR", ofType: "mp4")!))
        player.allowsExternalPlayback = true
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspect
        self.layer.addSublayer(playerLayer)
        playerLayer.frame = self.bounds

    }
    
       
}
