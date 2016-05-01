//
//  EditorWindow.swift
//  slackMessagecounter
//
//  Created by Andrew Harris on 4/25/16.
//  Copyright © 2016 Andrew Harris. All rights reserved.
//

import Cocoa

class EditorWindow: NSWindow {

    override func keyDown(event: NSEvent) {
        super.keyDown(event)
        Swift.print("Caught a key down: \(event.keyCode)!")
    }

}
