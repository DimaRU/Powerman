/////
////  Preferences.swift
///   Copyright © 2020 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct Preference {
    @UserPreference("ipAddress")
    static var ipAddress: String?

    @UserPreference("Password")
    static var password: String?
}
