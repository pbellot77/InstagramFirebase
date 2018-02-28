//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 2/28/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
	
	var lastURLUsedToLoadImage: String?
	
	func loadImage(urlString: String) {
		print("Loading image...")
		
		lastURLUsedToLoadImage = urlString
		
		guard let url = URL(string: urlString) else { return }
		
		URLSession.shared.dataTask(with: url) { (data, response, err) in
			if let err = err {
				print("Failed to fetch post image:", err)
				return
			}
			
			if url.absoluteString != self.lastURLUsedToLoadImage {
				return
			}
			
			guard let imageData = data else { return }
			
			let photoImage = UIImage(data: imageData)
			DispatchQueue.main.async {
				self.image = photoImage
			}
		}.resume()
	}
}
