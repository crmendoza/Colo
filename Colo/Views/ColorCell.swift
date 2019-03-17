// 
// Colo
// 
// Copyright © 2019 Owehmgee. All rights reserved.
// 

import UIKit

class ColorCell: UITableViewCell {

    @IBOutlet private var colorLabel: UILabel!
    @IBOutlet private var rgbLabel: UILabel!
    @IBOutlet private var hsvLabel: UILabel!
    
    func setup(_ color: RGBColor) {
        let foregroundColor = color.foregroundColor
        self.contentView.backgroundColor = color.uicolor
        self.colorLabel.text = "#" + color.hex
        self.colorLabel.textColor = foregroundColor
        self.rgbLabel.text = color.rgbDescription
        self.rgbLabel.textColor = foregroundColor
        self.hsvLabel.text = HSVColor(rgb: color).hsvDescription
        self.hsvLabel.textColor = foregroundColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.2) {
            self.rgbLabel.alpha = selected ? 1.0 : 0.0
            self.rgbLabel.isHidden = !selected
            
            self.hsvLabel.alpha = selected ? 1.0 : 0.0
            self.hsvLabel.isHidden = !selected
        }
    }
}
