//
//  OrderDetailsViewController.swift
//  One Click Order
//
//  Created by Harry Merzin on 2/10/19.
//  Copyright © 2019 Harry Merzin. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class OrderDetailsViewController: UIViewController {

    weak var presenter: PresenterDelegate!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.dismissButton.layer.cornerRadius = 10
        activityIndicator.type = .pacman
        activityIndicator.startAnimating()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaults.standard.value(forKey: "currentOrderApiKey"))
        activityIndicator.type = .pacman
        activityIndicator.startAnimating()
        checkStatus()
        let statusTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(checkStatus), userInfo: nil, repeats: true)
    }
    
    @objc func checkStatus() {
        NetworkHelpers.orderStatus {status in
            self.statusLabel.text = status
            if(UserDefaults.standard.value(forKey: "currentOrderApiKey")) == nil {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.dismissButton.isHidden = false
                return
            }
        }
    }
    
    @IBAction func dismissPressed(_ sender: Any) {
        UserDefaults.standard.setValue(nil, forKey: "currentOrderApiKey")
        presenter.dismiss(controller: self)
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
