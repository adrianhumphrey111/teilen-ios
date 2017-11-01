//
//  TripViewController.swift
//  RoadDogg
//
//  Created by Adrian Humphrey on 10/31/17.
//  Copyright © 2017 Adrian Humphrey. All rights reserved.
//

import UIKit

class TripViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var post : Post!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Trip"
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TripViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let estimatedTextHeight = self.post?.getEstimatedTextViewSize(width: view.frame.width - 20)
        let postHeight : CGFloat = 200
        let allPostHeight = postHeight + estimatedTextHeight!
        return CGSize(width: view.frame.width, height: allPostHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "postViewCell", for: indexPath) as! PostViewCell
        
        cell.post = post
        cell.profileImageView.backgroundColor = .black
        cell.fullNameLabel.text = (post?.user.firstName)! + " " + (post?.user.lastName)!
        cell.userNameLabel.text = "username here"
        
        //Create TextView in Post Cell
        let estimatedHeight = (self.post?.getEstimatedTextViewSize(width: view.frame.width))! + 10.0
        let textView = UITextView(frame: CGRect(x: 10, y: 0, width: view.frame.width - 20, height: cell.textAreaView.frame.height))
        textView.text = post?.text
        textView.font = UIFont.systemFont(ofSize: (post?.fontSize)!)
        cell.textAreaView.addSubview( textView )
        
        
        cell.timeStampLabel.text = post?.createdAt
        cell.numberOfLikesLabel.text = post?.likeCountString
        cell.numberOfCommentsLabel.text = post?.commentCountString
        
        //Set Like Label
        if ( post.isLiked ){
            cell.likeButton.setTitle("UnLike", for: .normal)
        }
        else{
            cell.likeButton.setTitle("Like", for: .normal)
        }
        
        return cell
    }
}
