//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Dusan Savic on 14/3/21.
//  Copyright © 2021 Dusan Savic. All rights reserved.
//

import UIKit


class WelcomeViewController: UIViewController {
	
	@IBOutlet weak var titleLabel: UILabel!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.isNavigationBarHidden = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.isNavigationBarHidden = false
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		logoAppearing()
		
	}
	
	func logoAppearing() {
		titleLabel.text = ""
		var characterIndex = 0.0
		let titleText = K.appName
		for character in titleText {
			Timer.scheduledTimer(withTimeInterval: 0.1 * characterIndex, repeats: false) { (timer) in
				self.titleLabel.text?.append(character)
			}
			characterIndex += 1
		}
	}
	
}
