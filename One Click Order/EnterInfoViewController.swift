//
//  EnterInfoViewController.swift
//  One Click Order
//
//  Created by Harry Merzin on 2/9/19.
//  Copyright © 2019 Harry Merzin. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields

class EnterInfoViewController: UIViewController {

    weak var presenter: PresenterDelegate!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var items = [
        PreferenceItem(preferenceType: PreferenceType.label, fieldName: "Profile"),
        PreferenceItem(preferenceType: PreferenceType.input, fieldName: "First and Last Name", fieldKey: "firstLast"),
        PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Phone Number", fieldKey: "phoneNumber"),
        PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Email", fieldKey: "email"),

PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Street Address", fieldKey: "address"), PreferenceItem(preferenceType: PreferenceType.input, fieldName: "City", fieldKey: "city"), PreferenceItem(preferenceType: PreferenceType.input, fieldName: "State", fieldKey: "state"),
        PreferenceItem(preferenceType: PreferenceType.input, fieldName: "ZipCode", fieldKey: "zip"),
        PreferenceItem(preferenceType: PreferenceType.label, fieldName: "Credit Card"),
        PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Cardholder Name", fieldKey: "cardholderName"),
        PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Cardholder Address", fieldKey: "cardholderAddress"), PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Cardholder City", fieldKey: "cardholderCity"), PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Cardholder State", fieldKey: "cardholderState"),
        PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Cardholder ZipCode", fieldKey: "cardholderZip"),
        PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Card Number", fieldKey: "cardNumber"),
        PreferenceItem(preferenceType: PreferenceType.input, fieldName: "Expiration", fieldKey: "expiration"),
        PreferenceItem(preferenceType: PreferenceType.input, fieldName: "CVV", fieldKey: "cvv"),
        PreferenceItem(preferenceType: PreferenceType.label, fieldName: "Categories"),
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: scrollView.bounds.height * 2.5)
        
        let cancelButton = UIButton(frame: CGRect(x: self.view.frame.width - 30, y: 15, width: 20, height: 20))
        cancelButton.addTarget(self, action: #selector(cancelPressed(sender:)), for: .touchUpInside)
        cancelButton.setImage(#imageLiteral(resourceName: "cancel.pdf"), for: .normal)
        scrollView.addSubview(cancelButton)
        
        //self.view.backgroundColor = UIColor.init(patternImage: bgImage)
        //self.scrollView.backgroundColor = UIColor.init(patternImage: bgImage)
        //self.view.backgroundColor = bgColor
        //self.scrollView.backgroundColor = bgColor
        
        NetworkHelpers.getPreferencesList() {preferencesList in
            print(preferencesList)
            preferencesList.forEach {preference in
                self.items.append(PreferenceItem(preferenceType: PreferenceType.checkbox, fieldName: preference))
            }
            self.items.append(PreferenceItem(preferenceType: .button, fieldName: "Save"))
            self.renderForm()
        }
    }
    
    func renderForm() {
        for(i, item) in items.enumerated() {
            switch (item.preferenceType) {
            case .label:
                let label = UILabel(frame: CGRect(x: 10, y: i * 45, width: 200, height: 45))
                label.textColor = UIColor.white
                label.text = item.fieldName
                label.font = UIFont.boldSystemFont(ofSize: 24.0)
                label.tag = i
                scrollView.addSubview(label)
            case .input:
                let width = view.frame.width - 20
                let textInput = MDCTextField(frame: CGRect(x: 10, y: i * 45 - 15, width: Int(width), height: 45))
                //let heightConstraint = NSLayoutConstraint(item: textInput, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 45)
                //textInput.addConstraint(heightConstraint)
                textInput.placeholder = item.fieldName
                if let preferences = UserDefaults.standard.value(forKey: "preferences") as? [String: Any] {
                    if let defaultText = (preferences[item.fieldKey] as? String) {
                        textInput.text = defaultText
                    }
                }
                textInput.placeholderLabel.textColor = UIColor.white
                textInput.underline?.color = UIColor.white
                textInput.underline?.lineHeight = 2.0
                textInput.textColor = UIColor.white
                //textInput.font = UIFont.systemFont(ofSize: 16)
                //textInput.floatingPlaceholderNormalColor = UIColor.white
                textInput.tag = i
                scrollView.addSubview(textInput)
                break
            case .checkbox:
                let checkbox = GDCheckbox(frame: CGRect(x: 10, y: i * 45 + 5, width: 15, height: 15))
                let label = UILabel(frame: CGRect(x: 45, y: i * 45 + 10, width: 100, height: 50))
                label.textColor = UIColor.white
                label.text = item.fieldName
                label.sizeToFit()
                checkbox.containerColor = UIColor.white
                checkbox.checkColor = UIColor.white
                checkbox.tag = i
                if let preferences = UserDefaults.standard.value(forKey: "preferences") as? [String: Any] {
                    if let categories = preferences["categories"] as? [String: Any] {
                        if let foodItem = categories[item.fieldName] as? Bool {
                            checkbox.isOn = foodItem
                        }
                    }
                }
                scrollView.addSubview(checkbox)
                scrollView.addSubview(label)
                break
            case .button:
                let button = UIButton(frame: CGRect(x: Int(self.scrollView.center.x) - 150, y:  i * 45, width: 300, height: 40))
                button.backgroundColor = UIColor.white
                button.layer.cornerRadius = 10
                button.setTitle(item.fieldName, for: .normal)
                button.setTitleColor(UIColor.init(red: 231/255, green: 89/255, blue: 94/255, alpha: 1.0), for: .normal)
                button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
                button.addTarget(self, action: #selector(saveInfo(sender:)), for: .touchUpInside)
                button.tag = i
                scrollView.addSubview(button)
                break
            }
        }
    }
    
    @objc func saveInfo(sender: Any) {
        UserDefaults.standard.setValue(generateKeyValues(), forKey: "preferences")
        if UserDefaults.standard.value(forKey: "hasEnteredInfo") == nil {
            NetworkHelpers.postUser { user in
                
            }
        } else {
            NetworkHelpers.postUser { user in //SHOULD BE A PATCH
                
            }
        }
        UserDefaults.standard.setValue(true, forKey: "hasEnteredInfo")
        print(UserDefaults.standard.value(forKey: "preferences"))
        presenter.dismiss(controller: self)
    }
    
    @objc
    func cancelPressed(sender: UIButton) {
        self.presenter.dismiss(controller: self)
    }
    
    func generateKeyValues() -> [String: Any] {
        var dict = [String: Any]()
        var preferences = [String: Any]()
        for (index, item) in items.enumerated() {
            switch (item.preferenceType) {
            case .input:
                let (key, value) = generateKeyValue(view: self.scrollView.viewWithTag(index)!, item: item)
                dict[key] = value
            case .checkbox:
                let (key, value) = generateKeyValue(view: self.scrollView.viewWithTag(index)!, item: item)
                preferences[key] = value
            case .button:
                break
            case .label:
                break
            }
        }
        dict["categories"] = preferences
        return dict
    }
    
    func generateKeyValue(view: UIView, item: PreferenceItem) -> (String, Any) {
        switch (item.preferenceType) {
        case .button:
            return (item.fieldKey, item.fieldName)
        case .input:
            return (item.fieldKey, (view as! MDCTextInput).text)
        case .checkbox:
            return (item.fieldKey, (view as! GDCheckbox).isOn)
        case .label:
            return (item.fieldKey, item.fieldName)
        }
        return (item.fieldName, 5)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
