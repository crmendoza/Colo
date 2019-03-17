// 
// Colo
// 
// Copyright © 2019 Owehmgee. All rights reserved.
// 

import UIKit

class ColorCell: UITableViewCell {

    @IBOutlet private var colorLabel: UILabel!
    
    func setup(_ color: RGBColor) {
        self.contentView.backgroundColor = color.uicolor
        self.colorLabel.text = "#" + color.hex
        self.colorLabel.textColor = color.foregroundColor
    }
}
