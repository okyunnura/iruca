//
//  ViewController.swift
//  Iruca
//
//  Created by 奥村健一 on 2017/01/10.
//  Copyright © 2017年 Tagbangers,inc. All rights reserved.
//

import UIKit
import Alamofire
import CRToast
import XCGLogger

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	private let logger = XCGLogger.default

	let array = ["在席", "離席", "取り込み中", "退社"]

	@IBOutlet weak var pickerView: UIPickerView!

	@IBOutlet weak var idValueLabel: UILabel!

	@IBOutlet weak var nameValueLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		initViews();
		NotificationCenter.default.addObserver(self, selector: #selector(self.doSomething(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
	}

	override func viewDidDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
		super.viewDidDisappear(animated)
	}

	@objc func doSomething(_ notification: Notification) {
		initViews();
	}

	func initViews() {
		let ud = UserDefaults.standard
		let id = ud.integer(forKey: "id_preference")
		let name = ud.string(forKey: "name_preference");

		idValueLabel.text = id <= 0 ? "未設定" : String(id);
		nameValueLabel.text = name == nil || (name?.isEmpty)! ? "未設定" : name;
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1;
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return array.count;
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return array[row];
	}

	@IBAction func updateClick(_ sender: UIButton) {
		let ud = UserDefaults.standard
		let id = ud.integer(forKey: "id_preference")
		let name = ud.string(forKey: "name_preference");

		if (id <= 0 || name == nil || (name?.isEmpty)!) {
			let obtions = [
					kCRToastTextKey: "未設定な項目があります",
					kCRToastBackgroundColorKey: UIColor.yellow,
					kCRToastNotificationTypeKey: 2 as NSNumber,
					kCRToastNotificationPreferredHeightKey: 50 as NSNumber,
					kCRToastAnimationInDirectionKey: 0 as NSNumber,
					kCRToastAnimationOutDirectionKey: 0 as NSNumber,
			] as [String: Any]
			CRToastManager.showNotification(options: obtions, completionBlock: nil)
			return;
		}

		let parameters: Parameters = ["name": ud.string(forKey: "name_preference")!, "status": array[pickerView.selectedRow(inComponent: 0)]]
		Alamofire.request("https://iruca.co/api/rooms/12ebc2b1-695b-4291-ba21-c8c948308ad7/members/" + ud.string(forKey: "id_preference")!, method: .put, parameters: parameters)
				.response { response in
					if (response.response?.statusCode != 200 || response.error != nil) {
						let obtions = [
								kCRToastTextKey: "error",
								kCRToastBackgroundColorKey: UIColor.red,
								kCRToastNotificationTypeKey: 2 as NSNumber,
								kCRToastNotificationPreferredHeightKey: 50 as NSNumber,
								kCRToastAnimationInDirectionKey: 0 as NSNumber,
								kCRToastAnimationOutDirectionKey: 0 as NSNumber,
						] as [String: Any]
						CRToastManager.showNotification(options: obtions, completionBlock: nil)
					} else {
						let obtions = [
								kCRToastTextKey: "complete",
								kCRToastBackgroundColorKey: UIColor.green,
								kCRToastNotificationTypeKey: 2 as NSNumber,
								kCRToastNotificationPreferredHeightKey: 50 as NSNumber,
								kCRToastAnimationInDirectionKey: 0 as NSNumber,
								kCRToastAnimationOutDirectionKey: 0 as NSNumber,
						] as [String: Any]
						CRToastManager.showNotification(options: obtions, completionBlock: nil)
					}
				}
	}

}

