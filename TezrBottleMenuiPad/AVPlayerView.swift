//
//  AVPlayerView.swift
//  TezrBottleMenuiPad
//
//  Created by Erick Sanchez on 6/22/18.
//  Copyright © 2018 Jona Araujo. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable
class AVPlayerView: UIView {
    
    @IBInspectable
    var resource: String? {
        didSet {
            reloadPlayer()
        }
    }
    
    private var player : AVPlayer?
    private var avPlayerLayer : AVPlayerLayer?
    
    init(frame: CGRect, with resource: String) {
        self.resource = resource
        
        super.init(frame: frame)
        
        initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initLayout()
    }
    
    func play() {
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    
    func loop() {
        guard let player = self.player else {
            return
        }
        
        player.seek(to: kCMTimeZero)
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: kCMTimeZero)
            player.play()
        }
    }
    
    private func initLayout() {
        guard
            let resource = self.resource,
            let path = Bundle.main.path(forResource: resource, ofType: "mp4") else {
                return
        }
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        avPlayerLayer = AVPlayerLayer(player: player)
        
        avPlayerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        self.layer.addSublayer(avPlayerLayer!)
    }
    
    private func reloadPlayer() {
        self.initLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avPlayerLayer?.frame = self.layer.bounds
    }

}
