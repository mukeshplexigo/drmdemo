/**
 * ViewController.swift
 *
 * This software is the confidential and proprietary product of
 * Nagravision S.A., OpenTV, Inc. or its affiliates,
 * the use of which is governed by
 * (i)  the terms and conditions of the agreement you accepted by
 *      clicking that you agree or
 * (ii) such other agreement entered into between you and
 *      Nagravision S.A., OpenTV, Inc. or their affiliates.
 */

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

  var otvPlayer: OTVAVPlayer?

  let defaultLicenseDelegate: OTVDefaultLicenseDelegate?

  @IBOutlet weak var playerView: PlayerView!
    

  let assetURL = URL(string:
    "https://d3bqrzf9w11pn3.cloudfront.net/basic_hls_bbb_encrypted/index.m3u8")!
    
//    UFO Sample assetURL
//    let assetURL = URL(string:
//      "https://plexigo-nagra-test.s3-eu-west-1.amazonaws.com/Published/trl_airstrike_fps_withiv_test3/Trl_AirStrike_English.m3u8")!

    

// Hardcoded URL to the SSP
  let sspCertificateURL = URL(string:"https://vsd02fy1.anycast.nagra.com/VSD02FY1/fpls/contentlicenseservice/v1/certificates")!

//    UFO Sample sspCertificateURL
//    let sspCertificateURL = URL(string:"https://ufo2b7je.anycast.nagra.com/UFO2B7JE/fpls/contentlicenseservice/v1/certificates/UFO2B7JE")!

    
  // Hardcode URL to the licence server
  let licenseURL = URL(string: "https://vsd02fy1.anycast.nagra.com/VSD02FY1/fpls/contentlicenseservice/v1/licenses")!

//    UFO Sample licenseURL
//    let licenseURL = URL(string: "https://ufo2b7je.anycast.nagra.com/UFO2B7JE/fpls/contentlicenseservice/v1/licenses")!

  // The SSP Token linked with the assetURL
  let sspToken = "eyJraWQiOiI4MTI0MjUiLCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2ZXIiOiIxLjAiLCJ0eXAiOiJDb250ZW50QXV0aFoiLCJjb250ZW50UmlnaHRzIjpbeyJkZWZhdWx0S2NJZHMiOlsiZDhkNzBmYmQtMmNkMi00OTcxLWI4MGMtNjYxNzIwMTE3NjViIl0sImNvbnRlbnRJZCI6ImU4YmJmNzQ4LWE0ZDgtNDc5MS1hNDcwLTEzOTlmZWE5MTQ2MCIsInN0b3JhYmxlIjp0cnVlLCJkZWZhdWx0VXNhZ2VSdWxlcyI6eyJtaW5MZXZlbCI6MCwid2F0ZXJtYXJraW5nRW5hYmxlZCI6dHJ1ZSwiaW1hZ2VDb25zdHJhaW50IjpmYWxzZSwiaGRjcFR5cGUiOiJUWVBFXzAiLCJ1bmNvbXByZXNzZWREaWdpdGFsQ2FwcGluZ1Jlc29sdXRpb24iOiJOT19SRVNUUklDVElPTlMiLCJ1bnByb3RlY3RlZEFuYWxvZ091dHB1dCI6dHJ1ZSwiYW5hbG9nQ2FwcGluZ1Jlc29sdXRpb24iOiJOT19SRVNUUklDVElPTlMiLCJoZGNwIjp0cnVlLCJkZXZpY2VDYXBwaW5nUmVzb2x1dGlvbiI6Ik5PX1JFU1RSSUNUSU9OUyIsImRpZ2l0YWxPbmx5IjpmYWxzZSwidW5wcm90ZWN0ZWREaWdpdGFsT3V0cHV0Ijp0cnVlfX1dfQ.X7kslNaBkbccfGboIDwMJ-ZXpsBUjtpxV6G575D_TkE"
  
//    UFO Sample sspToken
//    let sspToken = "eyJraWQiOiI4MTUxOTgiLCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2ZXIiOiIxLjAiLCJ0eXAiOiJDb250ZW50QXV0aFoiLCJjb250ZW50UmlnaHRzIjpbeyJjb250ZW50SWQiOiJzaW1wbGVobHN0ZXN0MyIsInVzYWdlUnVsZXNQcm9maWxlSWQiOiJUZXN0In1dfQ.XWCLc3pgPpvkA6BDqRJxLK1cmUigd5pHDitybeRdJe8"
    
  required init?(coder aDecoder: NSCoder) {
    
    // Ensure that the licence delegate has been initialised and the SSP Certificate
    // has been downloaded before attempting to play the encrypted stream
    defaultLicenseDelegate = OTVDefaultLicenseDelegate(certificateURL: sspCertificateURL, licenseURL: licenseURL)
    
    // Ensure SDK has been loaded before constructing the player.
    // Note `load()` will load the file `opy_licence` if it's included in the project
    // If the licence token is stored under a different file name then string token must be
    // loaded in manually and passed in directly to `OTVSDK.load()`.
    // It may be more suitable to call `load()` in the `AppDelegate` depending on use case.
    OTVSDK.load()
    OTVSDK.setLogging(level: .debug)
    
    super.init(coder: aDecoder)
    
    // Pass the sspLicenseDelegate to the SDK to enable encrypted playback
    OTVDRMManager.shared.setLicenseDelegate(defaultLicenseDelegate!)

    // Use the SSP token to generate the SSP custom data header
    defaultLicenseDelegate?.setHTTPHeader(parameters: ["nv-authorizations": sspToken])

    // Now that the SSP encrypted playback has been initialised we can construct the player
    otvPlayer = OTVAVPlayer(url: assetURL)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    //assign player to playerView
    playerView.player = otvPlayer
    otvPlayer?.play()
    self.otvPlayer?.isMuted = false
    playerView.player?.isMuted = false
  }
    
}
