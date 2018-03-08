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
	
	var user: User? {
		didSet {
			guard let profileImageUrl = user?.profileImageUrl else { return }
			profileImageView.loadImage(urlString: profileImageUrl)
			
			usernameLabel.text = user?.username
			
			setupEditFollowButton()
		}
	}
	
	fileprivate func setupEditFollowButton() {
		guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
		guard let userId = user?.uid else { return }
		
		if currentLoggedInUserId == userId {
			//edit profile
		} else {
			// check if following
			Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observe(.value, with: { (snapshot) in
				
				if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
					self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
				} else {
					self.setupFollowStyle()
				}
			}) { (err) in
				print("Failed to check if following:", err)
			}
		}
	}
	
	@objc func handleEditProfileOrFollow() {
		print("Execute edit profile / follow / unfollow logic....")
		guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
		guard let userId = user?.uid else { return }
		
		if editProfileFollowButton.titleLabel?.text == "Unfollow" {
			Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue { (err, ref) in
				// unfollow
				if let err = err {
					print("Failed to unfollow user:", err)
					return
				}
				print("Successfully unfollow user:", self.user?.username ?? "")
				self.setupFollowStyle()
			}
		} else {
			// follow logic
			let ref = Database.database().reference().child("following").child(currentLoggedInUserId)
			let values = [userId: 1]
			ref.updateChildValues(values) { (err, ref) in
				if let err = err {
					print("Failed to follow user:", err)
				}
				print("Successfully followed user:", self.user?.username ?? "")
				self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
				self.editProfileFollowButton.backgroundColor = .white
				self.editProfileFollowButton.setTitleColor(.black, for: .normal)
			}
		}
	}
	
	fileprivate func setupFollowStyle() {
		self.editProfileFollowButton.setTitle("Follow", for: .normal)
		self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
		self.editProfileFollowButton.setTitleColor(.white, for: .normal)
		self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
	}
	
	let profileImageView: CustomImageView = {
		let iv = CustomImageView()
		iv.backgroundColor = .red
		iv.layer.cornerRadius = 40
		iv.clipsToBounds = true
		return iv
	}()
	
	let gridButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
		return button
	}()
	
	let listButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
		button.tintColor = UIColor(white: 0, alpha: 0.1)
		return button
	}()
	
	let bookmarkButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
		button.tintColor = UIColor(white: 0, alpha: 0.1)
		return button
	}()
	
	let usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "username"
		label.font = UIFont.boldSystemFont(ofSize: 14)
		return label
	}()
	
	let postsLabel: UILabel = {
		let label = UILabel()
		let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
		
		attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 14)]))
		
		label.attributedText = attributedText
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	let followersLabel: UILabel = {
		let label = UILabel()
		let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
		
		attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 14)]))
		
		label.attributedText = attributedText
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	let followingLabel: UILabel = {
		let label = UILabel()
		let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
		
		attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray, .font: UIFont.systemFont(ofSize: 14)]))
		
		label.attributedText = attributedText
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	lazy var editProfileFollowButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Edit Profile", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.layer.borderColor = UIColor.lightGray.cgColor
		button.layer.borderWidth = 1
		button.layer.cornerRadius = 3
		button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(profileImageView)
		profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
		
		setupBottomToolBar()
		
		addSubview(usernameLabel)
		usernameLabel.anchor(top: profileImageView.bottomAnchor, left: self.leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
		
		setupUsersStatsView()
		
		addSubview(editProfileFollowButton)
		editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
	}
	
	fileprivate func setupUsersStatsView() {
		let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
		
		stackView.distribution = .fillEqually
		
		addSubview(stackView)
		stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
	}
	
	fileprivate func setupBottomToolBar() {
		let topDividerView = UIView()
		topDividerView.backgroundColor = UIColor.lightGray
		
		let bottomDividerView = UIView()
		bottomDividerView.backgroundColor = UIColor.lightGray
		
		let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
		
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		
		addSubview(stackView)
		addSubview(topDividerView)
		addSubview(bottomDividerView)
		
		stackView.anchor(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
		topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
		bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
