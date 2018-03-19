//
//  CommentInputAccessoryView.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 3/19/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
	func didSubmit(for comment: String)
}

class CommentInputAccessoryView: UIView {
	
	var delegate: CommentInputAccessoryViewDelegate?
	
	func clearCommentTextField() {
		commentTextField.text = nil
	}
	
	fileprivate let commentTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Enter Comment"
		return textField
	}()
	
	fileprivate let submitButton: UIButton = {
		let sb = UIButton(type: .system)
		sb.setTitle("Submit", for: .normal)
		sb.setTitleColor(.black, for: .normal)
		sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		sb.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
		return sb
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(submitButton)
		submitButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
		
		addSubview(commentTextField)
		commentTextField.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
		
		setupLineSeparatorView()
	}
	
	fileprivate func setupLineSeparatorView() {
		let lineSeparatorView = UIView()
		lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
		addSubview(lineSeparatorView)
		lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
	}
	
	@objc func handleSubmit() {
		print("1,2,3")
		
		guard let commentText = commentTextField.text else { return }
		
		delegate?.didSubmit(for: commentText)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
