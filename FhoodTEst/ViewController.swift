//
//  ViewController.swift
//  FhoodTEst
//
//  Created by admin on 12/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtAmountField: UITextField!
    
    var alertTextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func authorizeCoinbase(_ sender: Any) {
        AppManager.startOAuthAuthentication("wallet:user:read wallet:user:email wallet:contacts:read wallet:accounts:read wallet:payment-methods:read wallet:payment-methods:delete wallet:payment-methods:limits wallet:transactions:read wallet:transactions:request wallet:buys:read wallet:sells:read wallet:addresses:read wallet:addresses:create wallet:orders:read wallet:checkouts:read wallet:deposits:read wallet:withdrawals:read wallet:notifications:read wallet:accounts:update wallet:accounts:create wallet:accounts:delete wallet:buys:create wallet:sells:create wallet:orders:create wallet:deposits:create wallet:withdrawals:create wallet:user:update wallet:checkouts:create wallet:orders:refund wallet:transactions:transfer wallet:transactions:send", meta: ["send_limit_amount": "1.00", "send_limit_currency": "USD", "send_limit_period": "day"])
    }
    
    @IBAction func sendMoney(_ sender: Any) {
        
        self.view.endEditing(true)
        
        AppManager.getAccounts({ (accounts) in
            AppManager.shared.accounts = accounts
            self.showActionSheet(accounts)
        })
    }
    
    func showAlertWithError(_ message: String) {
        let alertControl = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertControl.addAction(okAction)
        
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func showAlertWith(_ message: String) {
        let alertControl = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertControl.addAction(okAction)
        
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func showActionSheet(_ accounts: [CBAccount]) {
        let alertControl = UIAlertController(title: "Select Account", message: nil, preferredStyle: .actionSheet)
        for account in accounts {
            let action = UIAlertAction(title: "\(account.name ?? "")\(account.balance?.amount ?? ""))", style: .default, handler: { (action) in
                AppManager.sendMoney(account.id ?? "", fAToken: nil, isConfirm: false, completionBlock: { (error) in
                    if let error = error {
                        self.showAlertWithError(error.localizedDescription)
                    } else {
                        let alertControl1 = UIAlertController(title: nil, message: "Coinbase just send the sms to your phonenumber. Please enter code", preferredStyle: .alert)
                        alertControl1.addTextField(configurationHandler: { (textField) in
                            self.alertTextView = textField;
                        })
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            AppManager.sendMoney(account.id ?? "\(account.name ?? "" + "-" + (account.balance?.amount ?? ""))", fAToken: self.alertTextView.text ?? "", isConfirm: false, completionBlock: { (error) in
                                self.showAlertWith("You send 0.00001 BTC to youngk4u@gmail.com successfully.")
                            })
                        })
                        alertControl1.addAction(okAction)
                        self.present(alertControl1, animated: true, completion: nil)
                    }
                })
            })
            
            alertControl.addAction(action)
        }
        
        alertControl.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertControl, animated: true, completion: nil)
    }
    
}

