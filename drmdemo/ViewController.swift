//
//  ViewController.swift
//  drmdemo
//
//  Created by abc on 17/12/20.
//

import UIKit
import OPYSDKFPSTv
import AVFoundation

class PlayerView: UIView {

  var player: AVPlayer? {
    get { return playerLayer.player }
    set { playerLayer.player = newValue }
  }

  var playerLayer: AVPlayerLayer {
    return layer as! AVPlayerLayer
  }

  override class var layerClass: AnyClass {
    return AVPlayerLayer.self
  }
}

class ViewController: UIViewController {

  let otvPlayer: OTVAVPlayer

  @IBOutlet weak var playerView: PlayerView!

//  let assetURL = URL(string:
//    "https://d3bqrzf9w11pn3.cloudfront.net/basic_hls_bbb_clear/index.m3u8")!

//    let assetURL = URL(string:
//    "https://d3oa3c8etfmj1l.cloudfront.net/Content/Movies/MV_Punyakoti_Sanskrit_MIDNA/Trailer/Trl_Punyakoti_Sanskrit.m3u8?Expires=1603383076&Signature=l8bgT3tFfplNG79FAMhCuM11rxkYgLvozwvO4xEFr7hAMgmHuaRkOY-jSPLiCHDcYJKgpY2auJ~hXMPE289F8Dtd2OSOokpkyRZRQUArgl1WencSVsFbd06PjZ12yX1MkH76Hvw12QrRBtomqEqZCmKCsrjj-3DX6U5-zGuT91S5WXtsqCkVCFl2RlWoA0OFfQTJKpmz4dAHIAxOG7BDfOiVs8Q4B7kAMcYulmKVUu4yQXUW-nfEXaFs70FLi6CQ2QgZbUL9tDCpWbvImd1wdfKBNm8494FEDac5EqU3mRgk4u1CDX79vm0w9nUDBh37mWJ~A60O-7QHVLY942-YuQ__&Key-Pair-Id=APKAJ33H2SGDXVDF2HLQ")!

    
      let assetURL = URL(string:
        "https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Faka.ms%2FAlWakrahLive&data=04%7C01%7CMourad.Idrissi%40microsoft.com%7C7df0d5c71c724be4d14908d8854d0258%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C637405913110621559%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&sdata=3JvnpsWq2NCx8OyNKaMHoXX2vCX2DIIWWk%2Fub%2FfYnsg%3D&reserved=0")!

  required init?(coder aDecoder: NSCoder) {

    // Ensure SDK has been loaded before constructing the player.
    // Note `load()` will load the file `opy_licence` if it's included in the project
    // If the licence token is stored under a different file name then string token must be
    // loaded in manually and passed in directly to `OTVSDK.load()`.
    // It may be more suitable to call `load()` in the `AppDelegate` depending on use case.
    OTVSDK.load()

    // initialise the player by passing in the asset url.
    otvPlayer = OTVAVPlayer(url: assetURL)

    super.init(coder: aDecoder)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    //assign player to playerView
    playerView.player = otvPlayer
    otvPlayer.play()
  }
}
