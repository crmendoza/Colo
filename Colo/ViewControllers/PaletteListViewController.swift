// 
// Colo
// 
// Copyright © 2018 Owehmgee. All rights reserved.
// 

import UIKit

class PaletteListViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    
    private var paletteInteractor: PaletteListInteractor!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        paletteInteractor = PaletteListInteractor(networkGateway: NetworkGateway())
        paletteInteractor.delegate = self
        paletteInteractor.fetchPaletteList()
    }
}

extension PaletteListViewController: PaletteListInteractorDelegate {
    func didFinishDataFetch() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension PaletteListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paletteInteractor.itemCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaletteCell", for: indexPath) as! PaletteCell
        cell.populateCell(paletteInteractor.item(at: indexPath.row))
        return cell
    }
}

extension PaletteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaletteViewController") as? PaletteViewController else { return }
        vc.palette = paletteInteractor.item(at: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
}
