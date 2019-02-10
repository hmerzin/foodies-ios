//
//  NetworkHelpers.swift
//  One Click Order
//
//  Created by Harry Merzin on 2/9/19.
//  Copyright © 2019 Harry Merzin. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkHelpers {
    
    //static let baseURL = "http://ec2-3-83-84-98.compute-1.amazonaws.com:9004/api"
    //static let baseURL = "http://localhost:9004/api"
     static let baseURL = "http://localhost:3000"
    static func getPreferencesList(completion: @escaping (([String]) -> Void)) {
        let url = "https://stormy-cliffs-62076.herokuapp.com/categories"
        Alamofire.request(url).responseJSON {dataResponse in
            if let responseJSON = dataResponse.result.value as? [String: Any] {
                completion(responseJSON["categories"] as! [String])
            }
        }
    }
    
    static func postUser(completion: @escaping (([String: Any]) -> Void)) {
        let user = UserDefaults.standard.dictionary(forKey: "preferences")!
        Alamofire.request(baseURL + "/users", method: .post, parameters: user, encoding: JSONEncoding.default, headers: nil).responseJSON {dataResponse in
            if let responseJSON = dataResponse.result.value as? [String : Any] {
                print(responseJSON)
                completion(responseJSON)
            }
        }
    }
    
    static func patchUser(completion: @escaping (([String: Any]) -> Void)) {
        let user = UserDefaults.standard.dictionary(forKey: "preferences")!
        Alamofire.request(baseURL + "/users", method: .patch, parameters: user, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: "token")!)"]).responseJSON {dataResponse in
            print(dataResponse.result)
            if let responseJSON = dataResponse.result.value as? [String : Any] {
                print(responseJSON)
                completion(responseJSON)
            }
        }
    }
    
    static func login(completion: @escaping ((String) -> Void)) {
        if let user = UserDefaults.standard.dictionary(forKey: "preferences") {
            
            Alamofire.request(baseURL + "/auth/sign-in", method: .post, parameters: ["email": user["email"]], encoding: JSONEncoding.default, headers: nil).responseData {dataResponse in
                if let data = dataResponse.data, let token = String(data: data, encoding: .utf8) {
                    completion(token)
                    UserDefaults.standard.setValue(token, forKey: "token")
                }
            }
        }
    }
        
    static func placeOrder(completion: @escaping (([String: Any]) -> Void)) {
        if let prefs = UserDefaults.standard.value(forKey: "preferences") as? [String: Any] {
            Alamofire.request(baseURL + "/orders", method: HTTPMethod.post, parameters: prefs, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer \(UserDefaults.standard.value(forKey: "token")!)"]).responseJSON {res in
                if let order = res.result.value as? [String: Any] {
                    print(order)
                    completion(order)
                }
            }
        }
    }
    
    /*
     card:
     {
        cardholderName: 'Harry Merzin',
        cardholderStreetAddress: '204 Christian Avenue, Stony Brook NY',
        cardholderZip: '11790',
        lastFour: '1023',
        expirationMonth: 12,
        expirationYear: 2022 },
     address: {
        streetAddress: '25 Thomson Place',
        city: 'Boston',
        state: 'MA',
        zip: '02210',  } },
     recipient: {firstName: "", lastName: "", phone: "", email: ""}
     */
    
    static func placeOrder(numFoods: Int, completion: @escaping (([String: Any]) -> Void)) {
        if let prefs = UserDefaults.standard.value(forKey: "preferences") as? [String: Any] {
            getMenuItems(numFoods: numFoods) {menuInfo in
                if(menuInfo["status"] as? String == "no data") {return}
                let menuItems = (menuInfo["menuItems"] as! [String]).map {item in
                    return ["apiKey": item]
                }
                let card = [
                    "cardholderName": prefs["cardholderName"],
                    "cardholderStreetAddress": (prefs["cardholderAddress"] as! String) + (prefs["cardholderCity"] as! String) + (prefs["cardholderState"] as! String),
                    "cardholderZip": prefs["cardholderZip"],
                    "cardNumber": prefs["cardNumber"],
                    "expirationMonth": (prefs["expiration"] as! String).split(separator: "/")[0],
                    "expirationYear": (prefs["expiration"] as! String).split(separator: "/")[1]
                ]
                let address = [
                    "streetAddress": prefs["address"],
                    "city": prefs["city"],
                    "state": prefs["state"],
                    "zip": prefs["zip"]
                ]
                let recipient = [
                    "firstName": (prefs["firstLast"] as! String).split(separator: " ")[0],
                    "lastName": (prefs["firstLast"] as! String).split(separator: " ")[1],
                    "phone": prefs["phoneNumber"],
                    "email": prefs["email"]
                ]
                let orderData = [
                    "restaurantApiKey": menuInfo["restaurantKey"],
                    "items": menuItems,
                    "method":"delivery",
                    "payment":"card",
                    "tip":"3",
                    "card": card,
                    "address": address,
                    "recipient": recipient
                    
                ]
                let request = Alamofire.request("https://api.eatstreet.com/publicapi/v1/send-order", method: .post, parameters: orderData, encoding: JSONEncoding.default, headers: ["X-Access-Token": "bba78694cd46693c"]).responseJSON {res in
                    print(try! JSONSerialization.jsonObject(with: (res.request?.httpBody)!, options: .allowFragments))
                    let orderObject = res.result.value as! [String: Any?]
                    print(orderObject)
                    if let orderApiKey = orderObject["apiKey"] {
                        UserDefaults.standard.setValue(orderApiKey, forKey: "currentOrderApiKey")
                        completion(orderObject)
                    }
                }
               
            }
        }
    }
    
    static func getMenuItems(numFoods: Int, completion: @escaping (([String: Any]) -> Void)) {
        if let prefs = UserDefaults.standard.value(forKey: "preferences") as? [String: Any] {
        let categories = (UserDefaults.standard.value(forKey: "preferences") as! [String: Any])["categories"] as! [String: Any]
        var queryItems: [URLQueryItem] = []
        for(key, value) in categories {
            if(value as! Int) == 1 {
                queryItems.append(URLQueryItem(name: key, value: "true"))
            }
        }
            //http://localhost:3000/menus
            //https://stormy-cliffs-62076.herokuapp.com/menus
            var components = URLComponents(url: URL(string:"https://stormy-cliffs-62076.herokuapp.com/menus")!, resolvingAgainstBaseURL: false)
        queryItems.append (URLQueryItem(name: "address", value: "\(prefs["address"] ?? "")+\(prefs["city"] ?? "")+ \(prefs["state"] ?? "")&foods=\(numFoods)"))
        queryItems.append(URLQueryItem(name: "foods", value: "\(numFoods)"))
            components?.queryItems = queryItems
            let request = NSMutableURLRequest(url:try! components?.asURL() as! URL)

        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                let data = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                if let completionData = data as? [String: Any] {
                    completion(completionData)
                } else {
                    completion(["status": "no data"])
                }
            }
        })
        
        dataTask.resume()
 
        /*
            Alamofire.request("http://localhost:3000/menus?address=\(prefs["address"] ?? "")+\(prefs["city"] ?? "")+ \(prefs["state"] ?? "")&foods=\(numFoods)", method: HTTPMethod.get, parameters: ["preferences": (prefs["categories"] as! [String: Any])], encoding: JSONEncoding.default, headers: nil).responseJSON {response in
                if let info = response.result.value as? [String: Any] {
                    completion(info)
                }
            }*/
        }
    }
    
    static func statusTransform(status: String) -> String {
        switch(status) {
        case "PROCESSING":
            return "Processing your order"
        case "AWAITING_PREPARATION":
            return "Awaiting order preparation"
        case "PREPARING":
            return "Preparing your order"
        case "PREPARING_AND_DELIVERING":
            return "Prepping your order for delivery"
        case "OUT_FOR_DELIVERY":
            return "Your order is out for delivery"
        case "READY_FOR_PICKUP":
            return "Your order is ready to be picked up"
        case "DELIVERED":
            UserDefaults.standard.setValue(nil, forKey: "currentOrderApiKey")
            return "Your order has been delivered"
        case "CANCELLED":
            UserDefaults.standard.setValue(nil, forKey: "currentOrderApiKey")
            return "Your order has been cancelled"
        default:
            return status
        }
    }
    
    static func orderStatus(completion: @escaping ((String) -> Void)) {
        let order = UserDefaults.standard.string(forKey: "currentOrderApiKey")
        Alamofire.request("https://api.eatstreet.com/publicapi/v1/order/\(order ?? "")/statuses", method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: ["X-Access-Token": "bba78694cd46693c"]).responseJSON {response in
            if let statuses = response.result.value as? [[String: Any]] {
                if(statuses.count > 0) {
                completion(statuses.map {status -> String in
                    if let status = status["status"] {
                        return status as! String
                    } else {
                        return ""
                    }
                }.map(statusTransform)[statuses.count - 1])
                } else {
                    completion("No Status")
                }
            }
        }
    }
}
    

