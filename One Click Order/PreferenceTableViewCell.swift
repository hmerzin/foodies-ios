//
//  PreferenceTableViewCell.swift
//  One Click Order
//
//  Created by Harry Merzin on 2/8/19.
//  Copyright © 2019 Harry Merzin. All rights reserved.
//

import UIKit

class PreferenceTableViewCell: UITableViewCell {

    var preferenceInputView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.addSubview(preferenceInputView!)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
