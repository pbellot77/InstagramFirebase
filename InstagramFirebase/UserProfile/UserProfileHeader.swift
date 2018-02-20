//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 2/20/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
	
	let profileImageView: UIImageView = {
		let iv = UIImageView()
		iv.backgroundColor = .red
		iv.layer.cornerRadius = 40
		iv.clipsToBounds = true
		return iv
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .blue
		
		addSubview(profileImageView)
		profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
		
	}
	
	var user: User? {
		didSet {
			setupProfileImage()
		}
	}
	
	fileprivate func setupProfileImage() {
		guard let profileImageUrl = user?.profileImageUrl else { return }
		
		guard let url = URL(string: profileImageUrl) else { return }
		
		URLSession.shared.dataTask(with: url) { (data, response, err) in
			if let err = err {
				print("Failed to fetch profile image:", err)
				return
			}
			guard let data = data else { return }
			
			let image = UIImage(data: data)
			
			DispatchQueue.main.async {
				self.profileImageView.image = image
			}
		}.resume()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
