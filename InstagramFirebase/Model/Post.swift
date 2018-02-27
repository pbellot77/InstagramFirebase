//
//  Post.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 2/27/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import Foundation

struct Post {
	let imageUrl: String
	
	init(dictionary: [String: Any]) {
		self.imageUrl = dictionary["imageUrl"] as? String ?? ""
	}
}
