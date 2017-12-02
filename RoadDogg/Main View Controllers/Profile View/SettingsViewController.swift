
import UIKit
import Eureka
import Alamofire
import Stripe

typealias Emoji = String
let 👦🏼 = "👦🏼", 🍐 = "🍐", 💁🏻 = "💁🏻", 🐗 = "🐗", 🐼 = "🐼", 🐻 = "🐻", 🐖 = "🐖", 🐡 = "🐡", 👨🏻 = "👨🏻", 👨🏼 = "👨🏼", 👨🏽 = "👨🏽", 👨🏾 = "👨🏾", 👨🏿 = "👨🏿", 👩🏻 = "👩🏻", 👩🏼 = "👩🏼", 👩🏽 = "👩🏽", 👩🏾 = "👩🏾", 👩🏿 = "👩🏿"

class SettingsViewController : FormViewController, PopupDelegate, SettingsDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the title to the settings page
        self.title = "Settings"
        
        
        //Set the user that is saved in the database
        var user = RealmManager.shared.selfUser!
        
        form +++ Section("Account")
            <<< TextRow(){ row in
                row.title = "First Name"
                row.value = user.firstName
            }
            
            <<< TextRow(){ row in
                row.title = "Last Name"
                row.value = user.lastName
            }
            
            <<< TextRow(){ row in
                row.title = "Email"
                row.value = user.email
            }
            
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Get Paid ( Driver )"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.showPayment()
            }
            
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Payment ( Rider )"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.showPayment()
            }
            
            +++ Section("Notifications")
            <<< SwitchRow() {
                $0.title = "Likes"
                $0.value = true
            }
            
            <<< SwitchRow() {
                $0.title = "Comments"
                $0.value = true
            }
            
            <<< SwitchRow() {
                $0.title = "Trip Updates"
                $0.value = true
            }
            
            <<< SwitchRow() {
                $0.title = "Friend Request"
                $0.value = true
            }
            
            <<< SwitchRow() {
                $0.title = "Friend Approvals"
                $0.value = true
            }
            
            +++ Section("Notifications")
            <<< LabelRow () {
                $0.title = "Terms"
                }
                .onCellSelection { cell, row in
                    //self.performSegue(withIdentifier: "yourSegue", sender: self)
            }
            
            <<< LabelRow () {
                $0.title = "Privacy Policy"
                }
                .onCellSelection { cell, row in
                    //self.performSegue(withIdentifier: "yourSegue", sender: self)
            }
            
            +++ Section("")
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Logout"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.logout()
            }
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Delete Account"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.deleteAccount()
        }
        
    }
    
    func goToPaymentController() {
        showPayment()
    }
    
    func showPayment(){
        //Setup payment methods view controller
        let vc = STPPaymentMethodsViewController(configuration: STPPaymentConfiguration.shared(), theme: STPTheme.default(), customerContext: PaymentManager.shared.customerContext, delegate: self)
        self.tabBarController?.tabBar.isHidden = true
        
        // Present add card view controller
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteAccount(){
        //Show the user a popup and confirm that they want to delete the account
        var vc = PopupManager.shared.deleteAccount()
        if let deleteVC = vc.viewController as? DeleteAccountPopupViewController{
            deleteVC.delegate = self
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func showStartScreen(){
        //Log the user out of the app and show the initial log in page
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        //Login View
        let login = InitialViewController()
        appdelegate.window!.rootViewController = login
    }
    
    func logout(){
        //Show the user a popup and confirm that they want to delete the account
        var vc = PopupManager.shared.logout()
        if let logoutVC = vc.viewController as? LogoutPopupViewController{
            logoutVC.delegate = self
        }
        self.present(vc, animated: true, completion: nil)
    }
    
}


// MARK: STPPaymentMethodsViewControllerDelegate
extension SettingsViewController: STPPaymentMethodsViewControllerDelegate{
    
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didFailToLoadWithError error: Error) {
        // Dismiss payment methods view controller
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
        // Present error to user...
    }
    
    func paymentMethodsViewControllerDidCancel(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        // Dismiss payment methods view controller
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func paymentMethodsViewControllerDidFinish(_ paymentMethodsViewController: STPPaymentMethodsViewController) {
        // Dismiss payment methods view controller
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func paymentMethodsViewController(_ paymentMethodsViewController: STPPaymentMethodsViewController, didSelect paymentMethod: STPPaymentMethod) {
        // Save selected payment method
        RealmManager.shared.paymentVerified()
    }
    
    
}
