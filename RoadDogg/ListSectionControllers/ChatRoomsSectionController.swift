//
//  ChatRoomsSectionController.swift
//  Teilen
//
//  Created by Adrian Humphrey on 1/9/18.
//  Copyright © 2018 Adrian Humphrey. All rights reserved.
//

import Foundation
import IGListKit
import Firebase
import JSQMessagesViewController

class ChatRoomsSectionController : ListSectionController{
    
    var user: User!
    
    var lastMessge : String!
    
    var chatroomName : String!
    
    override init(){
        super.init()
        inset =  UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        //Set chatroom name
        setChatRoomName()
        
        //Get Last message
        let query = FirebaseDB.refs.databaseChats.child(self.chatroomName!).queryLimited(toLast: 1)
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let name        = data["name"],
                let text        = data["text"],
                !text.isEmpty
            {
                if let message = JSQMessage(senderId: id, displayName: name, text: text)
                {
                    self?.lastMessge = text
                }
            }
        })
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
}

extension ChatRoomsSectionController {
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        //Get estimation of the height of the cell
        let cellWidth = ((collectionContext?.containerSize.width)! )
        return CGSize(width: cellWidth, height: 150)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellClass : String = ChatRoomCollectionViewCell.reuseIdentifier
        let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
        configureChatRoomCell( cell: cell, ndx: index )
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.user = object as? User
    }
    
    override func didSelectItem(at index: Int) {
        let vc = SingleChatViewController()
        vc.user = self.user
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureChatRoomCell(cell: UICollectionViewCell, ndx: Int){
        if let cell = cell as? ChatRoomCollectionViewCell{
            cell.nameLabel.font = UIFont.systemFont(ofSize: 18)
            cell.nameLabel.text = self.user.fullName
            cell.lastMessageLabel.text = self.lastMessge
            cell.profileImageView.sd_setImage(with: URL(string: self.user!.profileUrl), placeholderImage: UIImage(named: "Profile_Placeholder") )
        }
    }
    
}

