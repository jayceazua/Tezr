//
//  AVPlayerView.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/22/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerView: UIView {
    
    var resource: URL?
    
    var player : AVPlayer?
    var avPlayerLayer : AVPlayerLayer?
    
    init(frame: CGRect, with resource: URL) {
        player = AVPlayer(url: resource)
        avPlayerLayer = AVPlayerLayer(player: player)
        
        super.init(frame: frame)
        
        initLayout()
    }
    
    init(frame: CGRect, fromBundle filename: String) {
        if let path = Bundle.main.path(forResource: filename, ofType: "mp4") {
            player = AVPlayer(url: URL(fileURLWithPath: path))
            avPlayerLayer = AVPlayerLayer(player: player)
        }
        
        super.init(frame: frame)
        
        initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let path = Bundle.main.path(forResource: "header-movie-1", ofType: "mp4") {
            player = AVPlayer(url: URL(fileURLWithPath: path))
            avPlayerLayer = AVPlayerLayer(player: player)
        }
        
        super.init(coder: aDecoder)
        
        initLayout()
    }
    
    private func initLayout() {
        guard
            let player = self.player,
            let avPlayerLayer = self.avPlayerLayer else {
                return
        }
        
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resize
        
        self.layer.addSublayer(avPlayerLayer)
        player.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avPlayerLayer?.frame = self.layer.bounds
    }

}
