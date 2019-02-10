//
//  OrderViewController.swift
//  One Click Order
//
//  Created by Harry Merzin on 2/8/19.
//  Copyright © 2019 Harry Merzin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class OrderViewController: UIViewController {

    var foodsCount = 1
    
    @IBOutlet weak var letsEatButton: UIButton!
    @IBOutlet weak var foodsCountLabel: UILabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodsCountLabel.text = String(foodsCount)
        self.letsEatButton.layer.cornerRadius = 10
        if let orders = UserDefaults.standard.array(forKey: "ordersArray") {
            print(orders)
        } else {
            UserDefaults.standard.setValue([], forKey: "ordersArray")
        }
        //let bgImage = #imageLiteral(resourceName: "48")
        //self.view.backgroundColor = UIColor.init(patternImage: bgImage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let hasEnteredInfo = UserDefaults.standard.value(forKey: "hasEnteredInfo") as? Bool
        if(hasEnteredInfo == nil) {
            let enterInfoVC = storyboard?.instantiateViewController(withIdentifier: "EnterInfoViewController") as! EnterInfoViewController
            enterInfoVC.presenter = self
            self.present(enterInfoVC, animated: true)
        }
        checkOrderStatus()
    }
    
    @IBAction func presentSettings(_ sender: Any) {
        let enterInfoVC = storyboard?.instantiateViewController(withIdentifier: "EnterInfoViewController") as! EnterInfoViewController
        enterInfoVC.presenter = self
        self.present(enterInfoVC, animated: true)
    }
    
    @IBAction func minusPressed(_ sender: Any) {
        if(foodsCount == 1) {
            return
        }
        foodsCount -= 1
        self.foodsCountLabel.text = String(foodsCount)
    }
    
    @IBAction func plusPressed(_ sender: Any) {
        foodsCount += 1
        self.foodsCountLabel.text = String(foodsCount)
    }
    
    func checkOrderStatus() {
        let hasOrder = UserDefaults.standard.value(forKey: "currentOrderApiKey") != nil
        if(hasOrder) {
         let newVC = storyboard?.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        newVC.presenter = self
        self.present(newVC, animated: true)
        }
    }
    
    @IBAction func letsEatPressed(_ sender: Any) {
        print("eatpressed")
        NetworkHelpers.placeOrder(numFoods: self.foodsCount) { orderJSON in
            print(orderJSON)
            var orders = UserDefaults.standard.array(forKey: "ordersArray")!
            UserDefaults.standard.setValue(orders.append(UserDefaults.standard.value(forKey: "currentOrderApiKey")!), forKey: "ordersArray")
            self.checkOrderStatus()
        }
    }
    
}

extension OrderViewController: PresenterDelegate {
    func dismiss(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
