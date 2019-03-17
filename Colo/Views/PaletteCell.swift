// 
// Colo
// 
// Copyright © 2018 Owehmgee. All rights reserved.
// 

import UIKit

class PaletteCell: UICollectionViewCell {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var paletteNameLabel: UILabel!
    @IBOutlet private var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyShadow()
        self.clipsToBounds = false
    }
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
            colorView.backgroundColor = color.uicolor
            containerView.addSubview(colorView)
            x += width
        }
    }
    
    private func applyShadow() {
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowRadius = 15
        shadowView.layer.shadowOpacity = 0.25
    }
}
