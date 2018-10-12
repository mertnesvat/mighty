//
//  InterfaceController.swift
//  watch Extension
//
//  Created by Mert Nesvat on 10/2/18.
//  Copyright © 2018 Mert Nesvat. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, SessionCommands {

    @IBOutlet weak var lblText: WKInterfaceLabel!
    
    private var command: Command!
    
    var randomTex = RandomText()
    

    @IBAction func nextText(_ sender: Any) {
//        let a: [String : Any] = updateAppContext()
        self.lblText.setText(randomTex.randomAnswer())
        
//        self.lblText.setText()
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        guard command != nil else { return } // For first-time loading do nothing.
        
        // For .updateAppContext, retrieve the receieved app context if any and update the UI.
        // For .transferFile and .transferUserInfo, log the outstanding transfers if any.
        //
        if command == .updateAppContext {
            let timedColor = WCSession.default.receivedApplicationContext
            if timedColor.isEmpty == false {
                var commandStatus = CommandStatus(command: command, phrase: .received)
                commandStatus.timedColor = TimedColor(timedColor)
                self.lblText.setText(commandStatus.command.rawValue)
            }
        } else if command == .transferFile {
            let transferCount = WCSession.default.outstandingFileTransfers.count
            if transferCount > 0 {
                let commandStatus = CommandStatus(command: .transferFile, phrase: .finished)
//                logOutstandingTransfers(for: commandStatus, outstandingCount: transferCount)
            }
        } else if command == .transferUserInfo {
            let transferCount = WCSession.default.outstandingUserInfoTransfers.count
            if transferCount > 0 {
                let commandStatus = CommandStatus(command: .transferUserInfo, phrase: .finished)
//                logOutstandingTransfers(for: commandStatus, outstandingCount: transferCount)
            }
        }
        
        // Update the status group background color.
        //
        if command != .transferFile && command != .transferUserInfo {
//            statusGroup.setBackgroundColor(.black)
        }
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
