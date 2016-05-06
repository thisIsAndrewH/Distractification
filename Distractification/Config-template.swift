//
//  Config-template.swift
//  Distractification
//
//  Created by Andrew Harris on 5/6/16.
//  Copyright © 2016 Andrew Harris. All rights reserved.
//
//  Make a copy of this and name the file Config.swift
//  Rname struct Config_template to Config
//

import Cocoa

struct Config_template {
    static let slackApiToken = "xoxp-2279670432-2741918533-39834281856-05e7769512"
    static let googleAnalyticsToken = ""
    static let thresholdLimit = 200 //number of messages sent a day - over produces notification
    static let timerSeconds: Double = 60*15
}
