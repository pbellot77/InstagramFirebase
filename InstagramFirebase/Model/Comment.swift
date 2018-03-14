//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 3/14/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import Foundation

struct Comment {
	let text: String
	let uid: String
	
	init(dictionary: [String: Any]) {
		self.text = dictionary["text"] as? String ?? ""
		self.uid = dictionary["uid"] as? String ?? ""
	}
}
