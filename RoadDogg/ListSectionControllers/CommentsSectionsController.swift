//
//  CommentsSectionsController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 11/26/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import Foundation
import IGListKit

class CommentsSectionsController : ListSectionController{
    
    var comment: Comment!
    
    override init(){
        super.init()
        inset =  UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
}

extension CommentsSectionsController {
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        //Get estimation of the height of the cell
        let cellWidth = ((collectionContext?.containerSize.width)! - 20)
        var estimatedWidth = cellWidth - 70
        let text = self.comment.text
        let size = CGSize(width: estimatedWidth, height: 1000)
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18 )]
        let estiamtedFrame = NSString( string: text ).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let estimatedHeight = estiamtedFrame.height
        return CGSize(width: cellWidth, height: estiamtedFrame.height + 40)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellClass : String = CommentCollectionViewCell.reuseIdentifier
        let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
        configureCommentCell( cell: cell, ndx: index )
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.comment = object as? Comment
    }
    
    override func didSelectItem(at index: Int) {
        switch index{
        case 0:
            print("header view")
        default:
            return
        }
    }
    
    func configureCommentCell(cell: UICollectionViewCell, ndx: Int){
        if let cell = cell as? CommentCollectionViewCell{
            cell.textView.font = UIFont.systemFont(ofSize: 18)
            cell.textView.text = self.comment.text
            cell.timeStamp.text = self.comment.createdAt
            cell.imageView.sd_setImage(with: URL(string: self.comment.user!.profileUrl), placeholderImage: UIImage(named: "Profile_Placeholder") )
        }
    }
    
}
