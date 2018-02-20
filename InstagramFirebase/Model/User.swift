//
//  User.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 2/20/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import Foundation

struct User {
	let username: String
	let profileImageUrl: String
	
	init(dictionary: [String: Any]) {
		self.username = dictionary["username"] as? String ?? ""
		self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
	}
}
