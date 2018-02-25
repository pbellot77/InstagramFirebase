//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 2/20/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
	
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		
		let index = viewControllers?.index(of: viewController)
		if index == 2 {
			
			let layout = UICollectionViewFlowLayout()
			let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
			let navController = UINavigationController(rootViewController: photoSelectorController)
			present(navController, animated: true, completion: nil)
			return false
		}
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.delegate = self
		
		if Auth.auth().currentUser == nil {
			DispatchQueue.main.async {
				let loginController = LoginController()
				let navController = UINavigationController(rootViewController: loginController)
				self.present(navController, animated: true, completion: nil)
			}
			return
		}
		setupViewControllers()
	}
	
	func setupViewControllers() {
		//home
		let homeNavController = templateNavController(unselected: #imageLiteral(resourceName: "home_unselected"), selected: #imageLiteral(resourceName: "home_selected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
		
		//search
		let searchNavController = templateNavController(unselected: #imageLiteral(resourceName: "search_unselected"), selected: #imageLiteral(resourceName: "search_selected"))
		
		//plus
		let plusNavController = templateNavController(unselected: #imageLiteral(resourceName: "plus_unselected"), selected: #imageLiteral(resourceName: "plus_unselected"))
		
		//likes
		let likeNavController = templateNavController(unselected: #imageLiteral(resourceName: "like_unselected"), selected: #imageLiteral(resourceName: "like_selected"))
		
		//user profile
		let layout = UICollectionViewFlowLayout()
		let userProfileController = UserProfileController(collectionViewLayout: layout)
		
		let userProfileNavController = UINavigationController(rootViewController: userProfileController)
		
		userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
		userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
		
		tabBar.tintColor = .black
		
		viewControllers = [homeNavController, searchNavController, plusNavController, likeNavController, userProfileNavController]
		
		// modify tab bar item insets
		guard let items = tabBar.items else { return }
		for item in items {
			item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
		}
	}
	
	fileprivate func templateNavController(unselected: UIImage, selected: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
		let viewController = rootViewController
		let navController = UINavigationController(rootViewController: viewController)
		navController.tabBarItem.image = unselected
		navController.tabBarItem.selectedImage = selected
		return navController
	}
}
