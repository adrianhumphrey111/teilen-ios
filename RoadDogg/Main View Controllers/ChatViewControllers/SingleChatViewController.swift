//
//  SingleChatViewController.swift
//  Teilen
//
//  Created by Adrian Humphrey on 1/6/18.
//  Copyright © 2018 Adrian Humphrey. All rights reserved.
//

import Foundation
import Firebase
import JSQMessagesViewController

class SingleChatViewController: JSQMessagesViewController
{
    var messages = [JSQMessage]()
    
    var selfUser = RealmManager.shared.selfUser!
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    var user : User!
    
    var chatroomName : String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.title = self.user!.firstName
        
        self.senderId = Auth.auth().currentUser?.uid
        senderDisplayName = selfUser.firstName
        
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        setChatRoomName()
        
        //Check if the chatroom exist
        var ref = Database.database().reference()
        
        ref.child("messages").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(self.chatroomName!){
            }else{
                //Add the room to the messages
                let chatroom = [self.chatroomName!: ""]
                ref.child("messages").child(self.chatroomName!).setValue("")
            }
        })
        
        observeMessages()
    }
    
    func setChatRoomName(){
        var arr : [String] = []
        let friendKey = self.user!.key
        let selfKey = RealmManager.shared.selfUser!.key
        arr.append( friendKey )
        arr.append( selfKey )
        
        //Sort Array
        arr.sorted { $0 < $1 }
        
        self.chatroomName = arr.flatMap({$0}).joined()
    }
    
    private func observeMessages() {
        let query = FirebaseDB.refs.databaseChats.child(self.chatroomName!).queryLimited(toLast: 50)
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let name        = data["name"],
                let text        = data["text"],
                !text.isEmpty
            {
                if let message = JSQMessage(senderId: id, displayName: name, text: text)
                {
                    self?.messages.append(message)
                    self?.finishReceivingMessage()
                }
            }
        })
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    //Hide the users avatars for right now
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    //change text color
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        
        let ref = FirebaseDB.refs.databaseChats.child(chatroomName!).childByAutoId()
        
        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text]
        
        ref.setValue(message)
        
        Network.shared.sendMessage(to: self.user!.key)
        
        finishSendingMessage()
    }
    
    func showTabBar(){
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func hideTabBar(){
        self.tabBarController?.tabBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
}
