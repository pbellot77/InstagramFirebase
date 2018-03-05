//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 2/20/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	let cellId = "CellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView?.backgroundColor = .white
		
		navigationItem.title = Auth.auth().currentUser?.uid
		
		fetchUser()
		
		collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
		collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
		
		setupLogOutButton()
		
		fetchOrderedPosts()
	}
	
	var posts = [Post]()
	
	fileprivate func fetchOrderedPosts() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let ref = Database.database().reference().child("posts").child(uid)
		
		ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
			guard let dictionary = snapshot.value as? [String: Any] else { return }
			
			guard let user = self.user else { return }
			
			let post = Post(user: user, dictionary: dictionary)
			
			self.posts.insert(post, at: 0)
			self.collectionView?.reloadData()
		}) { (err) in
			print("Failed to fetch ordered posts:", err)
		}
	}
	
	fileprivate func setupLogOutButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
	}
	
	@objc func handleLogOut() {
		let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		
		alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
			
			do {
			  try	Auth.auth().signOut()
				let loginController = LoginController()
				let navController = UINavigationController(rootViewController: loginController)
				self.present(navController, animated: true, completion: nil)
			} catch let signOutErr {
				print("Failed to sign out:", signOutErr)
			}
		}))
		
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		present(alertController, animated: true, completion: nil)
	}

	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
		
		cell.post = posts[indexPath.item]
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (view.frame.width - 2) / 3
		return CGSize(width: width, height: width)
	}
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
		
		header.user = self.user 
		
		return header
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: view.frame.width, height: 200)
	}
	
	var user: User?
	fileprivate func fetchUser() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		
		Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
			print(snapshot.value ?? "")
			
			guard let dictionary = snapshot.value as? [String: Any] else { return }
			
			self.user = User(dictionary: dictionary)
			self.navigationItem.title = self.user?.username
			self.collectionView?.reloadData()
			
		}) { (err) in
			print("Failed to fetch user:", err)
		}
	}
}
