//
//  RandomText.swift
//  8Ball
//
//  Created by Mert Nesvat on 10/6/18.
//  Copyright © 2018 Mert Nesvat. All rights reserved.
//
import Foundation

class RandomText {
    var possibleAnswers: NSArray?
    
    init() {
        
        let path = Bundle.path(forResource: "Answers", ofType: "plist", inDirectory: Bundle.main.resourcePath!)
        self.possibleAnswers = NSArray.init(contentsOfFile: path!)

    }
    
    func randomAnswer() -> String {
        let rd = Int.random(in: 0 ..< self.possibleAnswers!.count)
        return self.possibleAnswers![rd] as! String
    }
    
}

protocol Prophecy {
    func randomText() -> String
}

extension Prophecy {
    func randomText() -> String {
        return ""
    }
}
