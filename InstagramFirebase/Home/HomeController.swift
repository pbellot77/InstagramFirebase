//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 3/2/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	let cellId = "cellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
		
		collectionView?.backgroundColor = .white
		collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
		
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
		collectionView?.refreshControl = refreshControl
		
		setupNavigationItems()
		
		fetchAllPosts()
	}
	
	@objc func handleUpdateFeed() {
		handleRefresh()
	}
	
	@objc func handleRefresh() {
		print("handle refresh")
		posts.removeAll()
		fetchAllPosts()
	}
	
	fileprivate func fetchAllPosts() {
		fetchPosts()
		fetchFollowingUserIds()
	}
	
	fileprivate func fetchFollowingUserIds() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
	
			guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
			
			userIdsDictionary.forEach({ (key, value) in
				Database.fetchUserWithUID(uid: key, completion: { (user) in
					self.fetchPostsWithUser(user: user)
				})
			})
		}) { (err) in
			print("Failded to fetch following user ids:", err)
		}
	}
	
	private func setupNavigationItems() {
		navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
	}
	
	var posts = [Post]()
	fileprivate func fetchPosts() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		Database.fetchUserWithUID(uid: uid) { (user) in
			self.fetchPostsWithUser(user: user)
		}
	}
	
	fileprivate func fetchPostsWithUser(user: User) {
		let ref = Database.database().reference().child("posts").child(user.uid)
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			
			self.collectionView?.refreshControl?.endRefreshing()
			
			guard let dictionaries = snapshot.value as? [String: Any] else { return }
			
			dictionaries.forEach({ (key, value) in
				
				guard let dictionary = value as? [String: Any] else { return }
				
				let post = Post(user: user, dictionary: dictionary)
				self.posts.append(post)
			})
			
			self.posts.sort(by: { (p1, p2) -> Bool in
				return p1.creationDate.compare(p2.creationDate) == .orderedDescending
			})
			self.collectionView?.reloadData()
			
		}) { (err) in
			print("Failed to fetch posts:", err)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var height: CGFloat = 40 + 8 + 8
		height += view.frame.width
		height += 50
		height += 60
		
		return CGSize(width: view.frame.width, height: height)
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
		cell.post = posts[indexPath.item]
		return cell
	}
}
