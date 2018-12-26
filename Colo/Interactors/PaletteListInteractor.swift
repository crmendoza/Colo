// 
// Colo
// 
// Copyright © 2018 Owehmgee. All rights reserved.
// 

import Foundation

protocol PaletteListInteractorDelegate {
    func didFinishDataFetch()
}

class PaletteListInteractor {
    
    let networkGateway: NetworkGateway
    var delegate: PaletteListInteractorDelegate?
    private var paletteArray = [Palette]()
    private var currentPage = 0
    
    init(networkGateway: NetworkGateway) {
        self.networkGateway = networkGateway
    }
    
    func fetchPaletteList(mode: String = "") {
        let paletteRequest = "http://www.colourlovers.com/api/palettes" + mode + "&format=json"
        print(paletteRequest)
        self.networkGateway.fetchData(urlString: paletteRequest) { [weak self] (data, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                guard let data = data else {
                    print("data doesn't exist")
                    return
                }
                do {
                    self?.paletteArray = try JSONDecoder().decode([Palette].self, from: data)
                    self?.delegate?.didFinishDataFetch()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func fetchNewPaletteList() {
        fetchPaletteList(mode: "/top")
    }
    
    func fetchTopPaletteList() {
        fetchPaletteList(mode: "/new")
    }
    
    func itemCount() -> Int {
        return paletteArray.count
    }
    
    func item(at index: Int) -> Palette {
        return paletteArray[index]
    }
}
