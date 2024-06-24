//
//  PostModelRealm.swift
//  Created by GaliSrikanth on 24/06/24.

import Foundation
import RealmSwift

class PostModelRealm: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
}
