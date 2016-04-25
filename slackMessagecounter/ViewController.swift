//
//  ViewController.swift
//  slackMessagecounter
//
//  Created by Andrew Harris on 4/25/16.
//  Copyright © 2016 Andrew Harris. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBOutlet weak var KeyCountField: NSTextField!

    @IBAction func someButton(sender: AnyObject) {
        let txt = "something"
        KeyCountField.stringValue = txt
    }
    
    
    
    
    //Is this in the wrong place?
    var direction:String = ""
    
    override func keyDown(theEvent: NSEvent) // A key is pressed
    {
        var keyNumber = theEvent.keyCode
        
        KeyCountField.stringValue = String(keyNumber)
        
        if theEvent.keyCode == 123
        {
            direction = "left" //get the pressed key
        }
        else if theEvent.keyCode == 124
        {
            direction = "right" //get the pressed key
        }
        else if theEvent.keyCode == 126
        {
            print("jump")
        }
    }
    
}