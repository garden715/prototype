//
//  ShoppingMallCell.swift
//  ZagZig
//
//  Created by seojungwon on 2016. 5. 8..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

import UIKit
import Haneke

class ShoppingMallCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var photo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
