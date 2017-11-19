import Foundation
import ILLoginKit
import FBSDKLoginKit
import FBSDKCoreKit
import FacebookCore

class LoginCoordinator: ILLoginKit.LoginCoordinator {
    
    // MARK: - LoginCoordinator
    
    override func start() {
        super.start()
        configureAppearance()
    }
    
    override func finish() {
        super.finish()
    }
    
    // MARK: - Setup
    
    // Customize LoginKit. All properties have defaults, only set the ones you want.
    func configureAppearance() {
        // Customize the look with background & logo images
        // backgroundImage = #imageLiteral(resourceName: "Background")
        // mainLogoImage =
        // secondaryLogoImage =
        
        // Change colors
        tintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
        errorTintColor = UIColor(red: 253.0/255.0, green: 227.0/255.0, blue: 167.0/255.0, alpha: 1)
        
        // Change placeholder & button texts, useful for different marketing style or language.
        loginButtonText = "Sign In"
        signupButtonText = "Create Account"
        facebookButtonText = "Continue with Facebook"
        forgotPasswordButtonText = "Forgot password?"
        recoverPasswordButtonText = "Recover"
        namePlaceholder = "Full Name"
        emailPlaceholder = "E-Mail"
        passwordPlaceholder = "Password!"
        repeatPasswordPlaceholder = "Confirm password!"
    }
    
    // MARK: - Completion Callbacks
    
    // Handle login via your API
    override func login(email: String, password: String) {
        Network.shared.login(email: email, password: password).then { result -> Void in
            let success = result["result"] as! Bool
            if ( success ){
                let user = result["user"] as! [String: AnyObject]
                let userKey = user["user_key"] as! String
                let stripeAccountId = user["stripe_account_id"] as! String
                let customerId = user["customer_id"] as! String
                var loggedinUser = User()
                loggedinUser.firstName = user["first_name"] as! String
                loggedinUser.lastName = user["last_name"] as! String
                loggedinUser.rating = user["rating"] as! Float
                loggedinUser.email = user["email"] as! String
                loggedinUser.numberOfTrips = user["numberOfCompletedTrips"] as! Int
                
                //Save user to persistence
                self.saveUserToDatabase(user: loggedinUser, userKey: userKey, accId: stripeAccountId, custId: customerId)
                
                //Either way show the new screen
                let root = self.rootViewController as! InitialViewController
                root.showMainViewController()
            }
            else{
                let error = result["error"] as! String
                print("There was an error while loggin in => ", error )
            }
        }.catch(execute: { (error) in
            print(error) //error with teilen api creating user
        })
    }
    
    // Handle signup via your API
    override func signup(name: String, email: String, password: String) {
        print("Signup with: name = \(name) email =\(email) password = \(password)")
        var fullNameArr = parseName(name: name)
        var user = User()
        user.firstName = fullNameArr[0]
        user.lastName = (fullNameArr.count > 1 ? fullNameArr[1] : nil)!
        user.email = email
        user.password = password
        
        Network.shared.createUser(user: user).then { json -> Void in
            let userKey = json["user_key"] as! String
            let stripeAccountId = json["stripe_account_id"] as! String
            let customerId = json["customer_id"] as! String
            //Save user to persistence
            self.saveUserToDatabase(user: user, userKey: userKey, accId: stripeAccountId, custId: customerId)
            
            //Either way show the new screen
            let root = self.rootViewController as! InitialViewController
            root.showMainViewController()
            
        }.catch(execute: { (error) in
            print(error) //error with teilen api creating user
        })
    }
    
    // Handle Facebook login/signup via your API
    override func enterWithFacebook(profile: FacebookProfile) {
        print("Login/Signup via Facebook with: FB profile =\(profile)")
        
    }
    
    // Handle password recovery via your API
    override func recoverPassword(email: String) {
        //Implement Later once I have emails set up.
        print("Recover password with: email =\(email)")
    }
    
    override func didSelectFacebook(_ viewController: UIViewController) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self.rootViewController) { (result , error) in
            if ( error == nil ){
                Network.shared.retriveUserFromFacebook().then { user -> Void in
                    Network.shared.createUser(user: user).then { json -> Void in
                        //Either this is a new user, or this user already exist
                        let userKey = json["user_key"] as! String
                        let stripeAccountId = json["stripe_account_id"] as! String
                        let customerId = json["customer_id"] as! String
                        
                        //Save user to persistence
                        self.saveUserToDatabase(user: user, userKey: userKey, accId: stripeAccountId, custId: customerId)
                        
                        //Either way show the new screen
                        let root = self.rootViewController as! InitialViewController
                        root.showMainViewController()
                        }.catch(execute: { (error) in
                            print("ERROR: Teilen APi creating User => ", error) //error with teilen api creating user
                        })
                }.catch(execute: { (error) in
                    print("ERROR: Retreieving user from facebook => ", error) //Error with retrieving user from facebook
                })
            
            }
            else{
                print("ERROR: Logging In With Facebook => " , error as Any)
            }
        }
    }
    
    func parseName(name: String) -> [String]{
        return name.components(separatedBy: " ")
    }
    
    func saveUserToDatabase(user: User, userKey: String, accId: String, custId: String){
        //Get the current notification token
        let token = RealmManager.shared.getSavedNotificationToken()
        
        //Create a user to save in the datebase
        var userSelf = loggedInUser()
        userSelf.firstName = user.firstName
        userSelf.lastName = user.lastName
        userSelf.email = user.email
        userSelf.facebookId = user.facebookId
        userSelf.key = userKey
        userSelf.stripeAccountId = accId
        userSelf.numberOfTrips = 0
        userSelf.customerId = custId
        userSelf.notificationToken = token
        
        //Save logged in user to database
        RealmManager.shared.saveLoggedInUser(user: userSelf)
        
        //Set the Network key to the saved user
        Network.shared.setUserKey()
        
        //Save the users Notification Token Here
        RealmManager.shared.saveNotificationToken(tokenstring: token)
        
    }
    
}
