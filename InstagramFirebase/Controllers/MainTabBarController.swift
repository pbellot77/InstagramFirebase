//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 2/20/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let redVc = UIViewController()
		redVc.view.backgroundColor = .red
		
		let layout = UICollectionViewFlowLayout()
		let userProfileController = UserProfileController(collectionViewLayout: layout)
		
		let navController = UINavigationController(rootViewController: userProfileController)
		
		navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
		navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
		
		tabBar.tintColor = .black
		
		viewControllers = [navController]
	}
}
