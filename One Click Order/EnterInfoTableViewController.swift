////
////  EnterInfoViewController.swift
////  One Click Order
////
////  Created by Harry Merzin on 2/8/19.
////  Copyright © 2019 Harry Merzin. All rights reserved.
////
//
//import UIKit
//
//
//class EnterInfoTableViewController: UITableViewController {
//
//    weak var presenter: PresenterDelegate!
//    let items = [
//        PreferenceItem(preferenceType: PreferenceType.label, fieldName: "Profile"),
//        PreferenceItem(preferenceType: PreferenceType.input, fieldName: "First and Last Name"), PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Street Address"), PreferenceItem(preferenceType: PreferenceType.input, fieldName: "City"), PreferenceItem(preferenceType: PreferenceType.input, fieldName: "State"),
//                 PreferenceItem(preferenceType: PreferenceType.input, fieldName: "ZipCode"),
//                 PreferenceItem(preferenceType: PreferenceType.label, fieldName: "Credit Card"),
//                 PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Cardholder Name"),
//                 PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Card Number"),
//                 PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Expiration"),
//                 PreferenceItem(preferenceType: PreferenceType.input, fieldName: "CVV"),
//                 PreferenceItem(preferenceType: PreferenceType.label, fieldName: "Category"),
//                 PreferenceItem(preferenceType: PreferenceType.checkbox, fieldName: "Asian"),
//                 PreferenceItem(preferenceType: PreferenceType.checkbox, fieldName: "Italian"),
//                 PreferenceItem(preferenceType: PreferenceType.button, fieldName: "Save")
//    ]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let bgImage = #imageLiteral(resourceName: "48-2.pdf")
//        self.view.backgroundColor = UIColor.init(patternImage: bgImage)
//        self.tableView.backgroundColor = UIColor.init(patternImage: bgImage)
//        self.tableView.separatorStyle = .none
//        tableView.allowsSelection = false
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let preferenceItem = items[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "EnterInfoCell")
//        cell!.backgroundColor = UIColor.clear
//        if((cell?.subviews.count)! > 2) {return cell!}
//        switch (preferenceItem.preferenceType) {
//        case .label:
//            let label = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 45))
//            label.textColor = UIColor.white
//            label.text = preferenceItem.fieldName
//            label.font = UIFont.boldSystemFont(ofSize: 24.0)
//            cell?.addSubview(label)
//        case .input:
//           // let textField = MDCTextInputControllerFilled(textInput: textInput)
//            textInput.placeholderLabel.text = preferenceItem.fieldName
//            textInput.placeholderLabel.textColor = UIColor.white
//            textInput.underline?.color = UIColor.white
//            textInput.underline?.lineHeight = 2.0
//            textInput.textColor = UIColor.white
//            //textInput.font = UIFont.systemFont(ofSize: 16)
//            //textInput.floatingPlaceholderNormalColor = UIColor.white
//            cell?.addSubview(textInput)
//            break
//        case .checkbox:
//            let checkbox = GDCheckbox()
//            cell?.addSubview(checkbox)
//            break
//        case .button:
//            let button = UIButton()
//            button.titleLabel?.text = preferenceItem.fieldName
//            break
//        }
//        return cell!
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
///*let textField = SkyFloatingLabelTextField(frame: CGRect(x: 10, y: 10, width: 200, height: 45))
// textField.placeholder = preferenceItem.fieldName
// textField.title = preferenceItem.fieldName
// textField.tintColor = UIColor.white
// textField.textColor = UIColor.white
// textField.lineColor = UIColor.white
// textField.selectedTitleColor = UIColor.white
// textField.titleColor = UIColor.white
// textField.placeholderColor = UIColor.white
// textField.selectedLineColor = UIColor.white
// textField.lineHeight = 2.0
// textField.selectedLineHeight = 2.0
// cell?.addSubview(textField)*/
