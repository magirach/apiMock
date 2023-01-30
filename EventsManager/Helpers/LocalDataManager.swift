//
//  LocalDataManager.swift
//  EventManager
//
//  Created by Moinuddin Girach on 02/08/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import Foundation

struct LocalDataManager {
    static var authObject: AuthObject? {
        set {
            if newValue != nil {
                let encoder = JSONEncoder()
                let authData = try? encoder.encode(newValue)
                UserDefaults.standard.setValue(authData, forKey: "authObject")
            } else {
                UserDefaults.standard.removeObject(forKey: "authObject")
            }
            UserDefaults.standard.synchronize()
        }
        get {
            var authObj: AuthObject? = nil
            guard let authData = UserDefaults.standard.object(forKey: "authObject") as? Data else { return nil }
            let decoder = JSONDecoder()
            authObj = try? decoder.decode(AuthObject.self, from: authData)
            return authObj
        }
    }
}
