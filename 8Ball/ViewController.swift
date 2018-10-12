//
//  ViewController.swift
//  8Ball
//
//  Created by Mert Nesvat on 10/2/18.
//  Copyright © 2018 Mert Nesvat. All rights reserved.
//

import UIKit
import Lottie
import Shimmer

class ViewController: UIViewController, UITextFieldDelegate, SocialShare{
    
    var vBall: LOTAnimationView!
    
    @IBOutlet weak var txWish: UITextField!
    @IBOutlet weak var vBallImageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageVBall: UIImageView!
    @IBOutlet weak var vLottieContainer: UIView!
    @IBOutlet weak var lblEightBall: UILabel!
    @IBOutlet weak var vShimmering: FBShimmeringView!
    @IBOutlet weak var lblAnswer: UILabel!
    var possibleAnswers: NSArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        vShimmering.contentView = lblEightBall
        vShimmering.shimmeringBeginFadeDuration = 0.3
        vShimmering.shimmeringOpacity = 0.3
        
        let animationPath = Bundle.path(forResource: "bubbles", ofType: "json", inDirectory: Bundle.main.resourcePath!)
        self.vBall = LOTAnimationView.init(filePath: animationPath!)
        self.vBall.contentMode = .scaleAspectFill
        self.vLottieContainer.addSubview(self.vBall)
        let rectLottie = CGRect(x: 0, y: 0, width: self.vLottieContainer.bounds.size.width, height: self.vLottieContainer.bounds.size.height)
        self.vBall.frame = rectLottie
        self.vBall.alpha = 0
        
        
        
        let path = Bundle.path(forResource: "Answers", ofType: "plist", inDirectory: Bundle.main.resourcePath!)
        self.possibleAnswers = NSArray.init(contentsOfFile: path!)
        
    }
    
    @IBAction func txWishChanged(_ sender: UITextField) {
        guard let a = sender.text else {
            return
        }
        
        if a.count > 40 {
            let substr = sender.text?.prefix(40)
            sender.text = String(substr!)
        }
    }
    
    func randomAnswer() -> String {
        let rd = Int.random(in: 0 ..< self.possibleAnswers!.count)
        return self.possibleAnswers![rd] as! String
    }
    
    func instagramBackgroundImage(image: NSData, attributionURL: NSString) {
        
        let urlScheme = NSURL.init(string: "instagram-stories://share")
        
        if UIApplication.shared.canOpenURL(urlScheme!.absoluteURL!) {
            
            let pasteboardItems : [[String: Any]] = [["com.instagram.sharedSticker.backgroundImage": image, "com.instagram.sharedSticker.contentURL": attributionURL]]
            let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate : NSDate.init().addingTimeInterval(60 * 5)]
            
            UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
            
            UIApplication.shared.open(urlScheme! as! URL, options:[:]) { (result) in
                print("result = ()")
                
            }
            
        }
    }
    @IBAction func btnInstagramShareClicked(_ sender: Any) {
        let img = self.view.toImage()
        
        let imgData = img.pngData()! as! NSData
        
        self.instagramBackgroundImage(image: imgData, attributionURL: "")

    }
    
    @IBAction func clicked(_ sender: Any) {
        
        guard txWish.text!.count > 0 else {
            self.txWish.becomeFirstResponder()
            return
        }

        _ = self.textFieldShouldReturn(txWish)
        self.vShimmering.isShimmering = true
        self.vBall.alpha = 1
        self.vBall.animationProgress = 0;
        self.vBall.play()

        self.vBallImageWidth.constant = 1000
        UIView.animate(withDuration: Double.random(in: 0.7..<2.0), delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.layoutIfNeeded()
            self.lblAnswer.alpha = 0

        }) { (finished) in
            self.vBall.stop()
            self.vBall.alpha = 0
            self.vBallImageWidth.constant = 0
            self.vShimmering.isShimmering = false
            self.lblAnswer.text = self.randomAnswer()
            self.lblAnswer.text = self.lblAnswer.text?.uppercased()
            UIView.animate(withDuration: Double.random(in: 0.5..<1.4), delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
                self.lblAnswer.alpha = 1
            }, completion: { (finished) in
                //
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let rectLottie = CGRect(x: 0, y: 0, width: self.vLottieContainer.bounds.size.width, height: self.vLottieContainer.bounds.size.height)
        self.vBall.frame = rectLottie
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return image!
    }
}

