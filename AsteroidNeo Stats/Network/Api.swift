//
//  Api.swift
//  AsteroidNeo Stats
//
//  Created by Jagan on 05/02/23.
//

import UIKit

class APIWrapper {
  
    private static var apiWrapper: APIWrapper = {
    let sharedWrapper = APIWrapper()
        return sharedWrapper
    }()
    
    class func shared() -> APIWrapper {
        return apiWrapper
    }
    
    func getNeoData(_ startDate: String, _ endDate: String) async throws -> NeoStat? {
        var neoStat: NeoStat? = nil
        var baseURL: String = Constants.BASE_URL
        baseURL = baseURL.replacingOccurrences(of: "{startDate}", with: startDate)
        baseURL = baseURL.replacingOccurrences(of: "{endDate}", with: endDate)
        let url = URL(string: baseURL)
        if let ourl = url {
            let req = URLRequest(url: ourl)
            let (data,_) = try await URLSession.shared.data(for: req)
            neoStat = try JSONDecoder().decode(NeoStat.self, from: data)
        }
       
      return neoStat
    }
}
