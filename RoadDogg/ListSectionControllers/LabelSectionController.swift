/**
 Copyright (c) 2016-present, Facebook, Inc. All rights reserved.
 
 The examples provided by Facebook are for non-commercial testing and evaluation
 purposes only. Facebook reserves all rights not expressly granted.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import UIKit
import IGListKit
import SDWebImage

final class LabelSectionController: ListSectionController {
    
    private var user: User!
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 80)
    }
    
    override func didSelectItem(at index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier :"FriendProfile") as! FriendProfileViewController
        vc.user = self.user!
        vc.profileArray.append( self.user! as AnyObject )
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellClass : String = LabelCell.reuseIdentifier
        let cell = collectionContext!.dequeueReusableCell(withNibName: cellClass, bundle: Bundle.main, for: self, at: index)
        configureRiderInformationCell(cell: cell)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.user = object as? User
    }
    
    func configureRiderInformationCell( cell: UICollectionViewCell ){
        if let cell = cell as? LabelCell{
            cell.fullNameLabel.text = self.user?.fullName
            cell.userKey = self.user.key
            cell.imageView.sd_setImage(with: URL(string: self.user!.profileUrl), placeholderImage: UIImage(named: "Profile_Placeholder") )
            if (self.user?.isFriend == "friend"){
                cell.status = (user?.isFriend)!
                cell.buttonToUnfriend()
            }
            else if(self.user?.isFriend == "requested"){
                cell.status = (user?.isFriend)!
                cell.buttonToRequested()
            }
            else{
                //This person is not a friend, so add the friend
                cell.status = (self.user?.isFriend)!
                cell.buttonToAddFriend()
            }
        }
    }
    
}
