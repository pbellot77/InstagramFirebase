//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 3/7/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import UIKit

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	let searchBar: UISearchBar = {
		let sb = UISearchBar()
		sb.placeholder = "Enter username"
		sb.barTintColor = .gray
		UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
		return sb
	}()
	
	let cellId = "cellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.backgroundColor = .white
		
		navigationController?.navigationBar.addSubview(searchBar)
		
		let navBar = navigationController?.navigationBar
		searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
		
		collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
		
		collectionView?.alwaysBounceVertical = true
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
		
	
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: 66)
	}
}
