// 
// Colo
// 
// Copyright © 2018 Owehmgee. All rights reserved.
// 

import Foundation

class NetworkGateway {
    
    func fetchData(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: urlString) {
                let task = URLSession.shared.dataTask(with: url, completionHandler: { (requestData, requestResponse, error) in
                    completion(requestData, error)
                })
                task.resume()
            }
        }
    }
}
