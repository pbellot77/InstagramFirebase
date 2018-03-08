//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 3/7/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
	
	var user: User? {
		didSet {
			usernameLabel.text = user?.username
			
			guard let profileImageUrl = user?.profileImageUrl else { return }
			
			profileImageView.loadImage(urlString: profileImageUrl)
		}
	}
	
	let profileImageView: CustomImageView = {
		let iv = CustomImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.layer.cornerRadius = 25
		return iv
	}()
	
	let usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "Username"
		label.font = UIFont.boldSystemFont(ofSize: 14)
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(profileImageView)
		profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
		profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		
		addSubview(usernameLabel)
		usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
		let separatorView = UIView()
		separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
		addSubview(separatorView)
		separatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
