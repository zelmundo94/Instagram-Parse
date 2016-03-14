//
//  PhotosCellTableViewCell.swift
//  Instagram
//
//  Created by Denzel Ketter on 3/7/16.
//  Copyright © 2016 Denzel Ketter. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PhotosCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var photoView: PFImageView!

    
    var instagramPost: PFObject! {
        didSet {
            self.captionLabel.text = instagramPost["caption"] as? String
            let photo = instagramPost["photo"] as! PFObject
            self.photoView.file = photo["image"] as? PFFile
            self.photoView.loadInBackground()
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
