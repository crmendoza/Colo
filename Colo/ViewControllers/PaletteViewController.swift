// 
// Colo
// 
// Copyright © 2019 Owehmgee. All rights reserved.
// 

import UIKit

class PaletteViewController: UIViewController {
    
    var palette: Palette?
    
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.reloadData()
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
        let x = self.view.frame.size.height - tableView.contentInset.bottom - tableView.contentInset.top
        let y = palette?.colors.count ?? 1
        
        return x / CGFloat(y)
    }
}
