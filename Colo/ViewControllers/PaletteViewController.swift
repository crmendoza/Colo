// 
// Colo
// 
// Copyright © 2019 Owehmgee. All rights reserved.
// 

import UIKit

class PaletteViewController: UIViewController {
    
    var palette: Palette?
    
    @IBOutlet private var shadowView: UIView!
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        showNavigationBar()
        applyGradientBackground()
        applyShadow()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }
    
    private func showNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
    }
    
    private func applyGradientBackground() {
        guard let palette =  self.palette else { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = palette.colors.map { $0.uicolor.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        
        view.bringSubview(toFront: shadowView)
    }
    
    private func applyShadow() {
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowRadius = 15
        shadowView.layer.shadowOpacity = 0.25
    }
}

extension PaletteViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return palette != nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return palette?.colors.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell") as! ColorCell
        if let color = palette?.colors[indexPath.row] {
            cell.setup(color)
        }
        return cell
    }
}

extension PaletteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let standardHeight = tableView.bounds.size.height / CGFloat(palette?.colors.count ?? 1)
        if let index = tableView.indexPathForSelectedRow?.row {
            let selectedHeight = standardHeight * 2
            let unselectedHeight = (tableView.bounds.size.height - selectedHeight) / CGFloat((palette?.colors.count ?? 1) - 1)
            return indexPath.row == index ? selectedHeight : unselectedHeight
        } else {
            return standardHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
