//
//  UserRealm.swift
//  Maps
//
//  Created by Roman Kolosov on 08.04.2021.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""

    override class func primaryKey() -> String? {
        "login"
    }

    override static func indexedProperties() -> [String] {
        ["login"]
    }

    required init(login: String, password: String) {
        self.login = login
        self.password = password
    }

    override required init() {
        super.init()
    }

}
