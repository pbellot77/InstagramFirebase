//
//  User.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 2/20/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import Foundation

struct User {
	let uid: String
	let username: String
	let profileImageUrl: String
	
	init(uid: String, dictionary: [String: Any]) {
		self.uid = uid
		self.username = dictionary["username"] as? String ?? ""
		self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
	}
}
