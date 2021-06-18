//
//  PreferencesViewController.swift
//  Powerman
//
//  Created by Dmitriy Borovikov on 15.06.2021.
//

import Cocoa

class PreferencesViewController: NSViewController, NSTextFieldDelegate {
    @IBOutlet weak var ipAddressLabel: NSTextField!
    @IBOutlet weak var passwordLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        ipAddressLabel.stringValue = Preference.ipAddress ?? ""
        passwordLabel.stringValue = Preference.password ?? ""
    }

    override func viewDidDisappear() {
            Preference.ipAddress = ipAddressLabel.stringValue
            Preference.password = passwordLabel.stringValue
        print(passwordLabel.stringValue)
    }
}
