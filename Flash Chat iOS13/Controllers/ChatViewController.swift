//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Dusan Savic on 14/3/21.
//  Copyright © 2021 Dusan Savic. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var messageTextfield: UITextField!
	
	let db =  Firestore.firestore()
	
	var messages: [Message] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		logoAppearing()
		tableView.dataSource = self
		navigationItem.hidesBackButton = true
		tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
		
		loadMessages()
	}
	
	//upit ka firestoreu
	func loadMessages() {
		db.collection(K.FStore.collectionName)
			.order(by: K.FStore.dateField)
			.addSnapshotListener { (querySnapshot, error) in
				self.messages = []
				if let e = error {
					print("Error \(e	)")
				} else {
					if let snapshotDocuments =  querySnapshot?.documents {
						for doc in snapshotDocuments {
							let data = doc.data()
							if let messageSender = data[K.FStore.senderField] as? String,
								let messageBody = data[K.FStore.bodyField] as? String {
								let newMessage = Message(sender: messageSender, body: messageBody)
								self.messages.append(newMessage)
								
								//Tableview reload
								DispatchQueue.main.async {
									self.tableView.reloadData()
									let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
									self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
								}
							}
						}
					}
				}
			}
	}
	
	@IBAction func sendPressed(_ sender: UIButton) {
		if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
			db.collection(K.FStore.collectionName).addDocument(data:
			[K.FStore.senderField : messageSender,
			 K.FStore.bodyField: messageBody,
			 K.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
				if let e = error {
					print("Error: \(e)")
				} else {
					DispatchQueue.main.async {
						self.messageTextfield.text = ""
					}
				}
			}
		}
	}
	
	
	@IBAction func logOutPressed(_ sender: UIBarButtonItem) {
		do {
			try Auth.auth().signOut()
			//vraca na pocetni viewcontroler
			navigationController?.popToRootViewController(animated: true)
		} catch let signOutError as NSError {
			print ("Error signing out: %@", signOutError)
		}
		
	}
	
	func logoAppearing() {
		title = ""
		var characterIndex = 0.0
		let titleText = K.appName
		for character in titleText {
			Timer.scheduledTimer(withTimeInterval: 0.1 * characterIndex, repeats: false) { (timer) in
				self.title!.append(character)
			}
			characterIndex += 1
		}
	}
}

//MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let message = messages[indexPath.row]
		
		let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
		cell.label.text = message.body
		
		//message from current user
		if message.sender == Auth.auth().currentUser?.email {
			cell.leftImageView.isHidden = true
			cell.rightImageView.isHidden = false
			cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
			cell.label.textColor = UIColor(named: K.BrandColors.purple)
			
		} else { //message from other user
			cell.leftImageView.isHidden = false
			cell.rightImageView.isHidden = true
			cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
			cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
		}
		
		return cell
	}
}


