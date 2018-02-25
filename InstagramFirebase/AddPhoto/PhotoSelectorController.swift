//
//  PhotoSelectorController.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 2/25/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import UIKit

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.backgroundColor = .yellow
		
		setupNavigationButtons()
		
		collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (view.frame.width / 4)  - 2
		return CGSize(width: width, height: width)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
		
		cell.backgroundColor = .blue
		
		return cell
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	fileprivate func setupNavigationButtons() {
		navigationController?.navigationBar.tintColor = .black
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
	}
	
	@objc func handleCancel() {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func handleNext() {
		print("Handling Next")
	}
}
