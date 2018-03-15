//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Patrick Bellot on 2/14/18.
//  Copyright © 2018 Polestar Interactive LLC. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	let plusPhotoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
		button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
		return button
	}()
	
	@objc func handlePlusPhoto() {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.allowsEditing = true
		
		present(imagePickerController, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
		if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
			plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
		} else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
			plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
		}
		
		plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
		plusPhotoButton.layer.masksToBounds = true
		plusPhotoButton.layer.borderColor = UIColor.black.cgColor
		plusPhotoButton.layer.borderWidth = 3
		
		dismiss(animated: true, completion: nil)
	}
	
	let emailTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Email"
		tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
		tf.borderStyle = .roundedRect
		tf.font = UIFont.systemFont(ofSize: 14)
		tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return tf
	}()
	
	@objc func handleTextInputChange() {
		let isFormValid = emailTextField.text?.count ?? 0 > 0 &&
			usernameTextField.text?.count ?? 0 > 0 &&
			passwordTextField.text?.count ?? 0 > 0
		if isFormValid {
			signUpButton.isEnabled = true
			signUpButton.backgroundColor = .mainBlue()
		} else {
			signUpButton.isEnabled = false
			signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
		}
	}
	
	let usernameTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Username"
		tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
		tf.borderStyle = .roundedRect
		tf.font = UIFont.systemFont(ofSize: 14)
		tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return tf
	}()
	
	let passwordTextField: UITextField = {
		let tf = UITextField()
		tf.placeholder = "Password"
		tf.isSecureTextEntry = true
		tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
		tf.borderStyle = .roundedRect
		tf.font = UIFont.systemFont(ofSize: 14)
		tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
		return tf
	}()
	
	let signUpButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Sign Up", for: .normal)
		button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
		button.layer.cornerRadius = 5
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(.white, for: .normal)
		button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
		
		button.isEnabled = false
		return button
	}()
	
	let alreadyHaveAccountButton: UIButton = {
		let button = UIButton(type: .system)
		
		let attributtedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray ])
		
		attributtedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
		button.setAttributedTitle(attributtedTitle, for: .normal)
		
		button.setTitle("Don't have an account? Sign Up.", for: .normal)
		button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
		return button
	}()
	
	@objc func handleAlreadyHaveAccount() {
		navigationController?.popViewController(animated: true)
	}
	
	@objc func handleSignUp() {
		guard let email = emailTextField.text, email.count > 0 else { return }
		guard let username = usernameTextField.text, username.count > 0 else { return }
		guard let password = passwordTextField.text, password.count > 0 else { return }
		
		Auth.auth().createUser(withEmail: email, password: password) { (user: Firebase.User?, error: Error?) in
			if let err = error {
				print("Failed to create user:", err)
				return
			}
			print("Successfully created user:", user?.uid ?? "")
			
			guard let image = self.plusPhotoButton.imageView?.image else { return }
			guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
			
			let filename = UUID().uuidString.lowercased()
			Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, err) in
				if let err = err {
					print("Failed to upload profile image:", err)
				}
				guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
				
				print("Successfully uploaded profile image:", profileImageUrl)
				
				guard let uid = user?.uid else { return }
				let dictionaryValues: Dictionary<String, Any> = ["username": username, "profileImageUrl": profileImageUrl]
				let values = [uid: dictionaryValues]
				
				Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
					if let err = error {
						print("Failed to save user info into db:", err)
					}
					print("Successfully saved user info to db")
					
					guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
					
					mainTabBarController.setupViewControllers()
					
					self.dismiss(animated: true, completion: nil)
				})
			})
			
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(alreadyHaveAccountButton)
		alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
		
		view.backgroundColor = .white
		
		view.addSubview(plusPhotoButton)
		
		plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil,
													 paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
													 width: 140, height: 140)
		
		plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		
		setupInputFields()
	}
	
	fileprivate func setupInputFields() {
		
		let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
		
		stackView.distribution = .fillEqually
		stackView.axis = .vertical
		stackView.spacing = 10
		
		view.addSubview(stackView)
		
		stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
	}
}























