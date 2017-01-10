//
//  ViewController.swift
//  Iruca
//
//  Created by 奥村健一 on 2017/01/10.
//  Copyright © 2017年 Tagbangers,inc. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

	let array = ["在席", "離席", "取り込み中", "退社"]

	@IBOutlet weak var pickerView: UIPickerView!

	@IBOutlet weak var statusLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
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
		let parameters: Parameters = ["name": "ken", "status": array[pickerView.selectedRow(inComponent: 0)]]
		Alamofire.request("https://iruca.co/api/rooms/12ebc2b1-695b-4291-ba21-c8c948308ad7/members/2224", method: .put, parameters: parameters);
	}

}

