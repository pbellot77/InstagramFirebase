//
//  CommentCell.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 3/14/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
	
	var comment: Comment? {
		didSet {
			textLabel.text = comment?.text
		}
	}
	
	let textLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.numberOfLines = 0
		label.backgroundColor = .lightGray
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(textLabel)
		textLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
