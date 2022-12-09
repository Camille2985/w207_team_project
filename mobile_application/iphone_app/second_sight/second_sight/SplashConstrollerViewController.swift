//
//  SplashConstrollerViewController.swift
//  second_sight
//
//  Created by Camille Church on 12/4/22.
//

import UIKit
import AVFoundation


class SplashConstrollerViewController: UIViewController {
    let synthesizer = AVSpeechSynthesizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = hexStringToUIColor(hex: "#1c3464")
        
        //inform user they are on a loading screen
        // what make siri say the text label
        let utterance = AVSpeechUtterance(string: "Application is Loading")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5
        utterance.volume = 1.0
        self.synthesizer.speak(utterance)
        
        
        
        //wait 2 seconds after load
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.performSegue(withIdentifier: "OpenMain", sender: nil)
            
            
            
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
