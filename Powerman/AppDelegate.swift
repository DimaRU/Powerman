//
//  AppDelegate.swift
//  Powerman
//
//  Created by Dmitriy Borovikov on 14.06.2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    @IBAction func showPreferences(_ sender: Any) {
        let mainStoryboard = NSStoryboard.init(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = mainStoryboard.instantiateController(withIdentifier: "PreferncesWindowController") as! NSWindowController
        windowController.showWindow(sender)
    }
}

