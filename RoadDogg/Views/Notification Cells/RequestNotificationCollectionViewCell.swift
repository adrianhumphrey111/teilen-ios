import UIKit
import Reusable

class RequestNotificationCollectionViewCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var acceptButton: UIButton!
    
    var type : String!
    
    var notification : realmNotification!
    
    @IBOutlet weak var acceptedWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightTextViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var denyButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .white
        //Accept Button
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.backgroundColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        acceptButton.layer.cornerRadius = 8
        
        //Deny Button
        let color = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0)
        denyButton.setTitle("Deny", for: .normal)
        denyButton.setTitleColor(color, for: .normal)
        denyButton.backgroundColor = .white
        denyButton.layer.cornerRadius = 8
        denyButton.layer.borderWidth = 1
        denyButton.layer.borderColor = UIColor().colorWithHexString(hex: "#76D2CE", alpha: 1.0).cgColor
    
        //Message text view
        messageTextView.font = UIFont.systemFont(ofSize: 16)
        messageTextView.isUserInteractionEnabled = false
        
        //Round the corners of the notifications
        self.layer.cornerRadius = 8
        
        //Profile image view
        //Make profile image round
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
    }
    
    func configure(){
        //Check if the notification is accepted or denied
        if let notification = self.notification as? realmNotification{
            print(notification)
            if ( notification.accepted == "accepted") {
                self.isAccepted()
            }
            
            if ( notification.accepted == "denied") {
                self.isDenied()
            }
        }
    }
    
    @IBAction func denyAction(_ sender: Any) {
        isDenied()
        RealmManager.shared.updateNotification(notification: self.notification, accepted: "denied" )
        Network.shared.denyRider(notification: self.notification).then { result -> Void in
            print(result)
        }
         print("Deny notification")
    }
    
    func isAccepted(){
        self.acceptedWidthConstraint.constant = 75
        self.denyButton.isHidden = true
        self.acceptButton.setTitle("Accepted", for: .normal)
        self.acceptButton.frame.size.width = self.acceptButton.frame.size.width + 20
        self.acceptButton.isUserInteractionEnabled = false
    }
    
    func isDenied(){
        self.acceptedWidthConstraint.constant = 75
        self.denyButton.isHidden = true
        self.acceptButton.setTitle("Denied", for: .normal)
        self.acceptButton.frame.size.width = self.acceptButton.frame.size.width + 20
        self.acceptButton.isUserInteractionEnabled = false
        self.notification.accepted = "denied"
    }
    
    
    @IBAction func acceptAction(_ sender: Any) {
        self.isAccepted()
        RealmManager.shared.updateNotification(notification: self.notification, accepted: "accepted" )
        Network.shared.acceptRider(notification: self.notification).then { result -> Void in
            //Handle accepting the notification
            if let success = result["success"] as? Bool {
                if success {
                    print("the card was successfully charged")
                }
                else{
                    print("the card was not successfully charged")
                }
            }
            print(result)
        }
        print("Accept notification")
    }
}

