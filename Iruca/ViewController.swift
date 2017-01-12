//
//  ViewController.swift
//  Iruca
//
//  Created by 奥村健一 on 2017/01/10.
//  Copyright © 2017年 Tagbangers,inc. All rights reserved.
//

import UIKit
import Alamofire
import XCGLogger
import SVProgressHUD

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	private let logger = XCGLogger.default

	let array = ["在席","離席","外出","休暇","電話中","打ち合わせ中","退社"]

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
		
		SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
		SVProgressHUD.show();

		if (id <= 0 || name == nil || (name?.isEmpty)!) {
			SVProgressHUD.showError(withStatus: "未設定の項目があります")
			return;
		}
		
		let selected = pickerView.selectedRow(inComponent: 0);
		let parameters: Parameters = ["name": ud.string(forKey: "name_preference")!, "status": array[selected]]
		Alamofire.request("https://iruca.co/api/rooms/12ebc2b1-695b-4291-ba21-c8c948308ad7/members/" + ud.string(forKey: "id_preference")!, method: .put, parameters: parameters)
				.response { response in
					if (response.response?.statusCode != 200 || response.error != nil) {
						SVProgressHUD.showError(withStatus:"エラー")
					} else {
						SVProgressHUD.showSuccess(withStatus:"成功!")
						
						switch selected{
						case 0:
							self.pickerView.selectRow(1, inComponent: 0, animated: true)
							break
						case 1:
							self.pickerView.selectRow(0, inComponent: 0, animated: true)
							break
						default:
							break
						}
					}
				}
	}

}

