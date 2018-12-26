// 
// Colo
// 
// Copyright © 2018 Owehmgee. All rights reserved.
// 

import UIKit

class PaletteCell: UICollectionViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var paletteNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        containerView.subviews.forEach { $0.removeFromSuperview() }
    }
    func populateCell(_ palette: Palette) {
        paletteNameLabel.text = palette.title
        
        let width = containerView.frame.width / CGFloat(palette.colors.count)
        var x: CGFloat = 0.0
        for color in palette.colors {
            let colorView = UIView(frame: CGRect(x: x, y: 0.0, width: width, height: containerView.frame.height))
            colorView.backgroundColor = UIColor(hex: color)
            containerView.addSubview(colorView)
            x += width
        }
    }
}
