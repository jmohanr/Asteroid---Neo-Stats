//
//  ViewModel.swift
//  AsteroidNeo Stats
//
//  Created by Jagan on 05/02/23.
//

import Foundation

class ViewModel {
    var statsData:((NeoObjectData,NeoObjectData,[NeoObjectData])->Void)?
    
    var neoObjectData: [NeoObjectData]? = nil {
        didSet {
            if let objects = neoObjectData {
                
                let fastest = objects.map { Double($0.close_approach_data?[0].relative_velocity?.kilometers_per_hour ?? "") ?? 0.0  }.max()
                
                let closest = objects.map { Double($0.close_approach_data?[0].miss_distance?.kilometers ?? "") ?? 0.0  }.min()
                
                let fatestObjc = objects.filter({$0.close_approach_data?[0].relative_velocity?.kilometers_per_hour == "\(fastest ?? 0.0)"}).first
                
                
                let closestObjc = objects.filter({$0.close_approach_data?[0].miss_distance?.kilometers == "\(closest ?? 0.0)"}).first
                
                if let fast = fatestObjc, let close = closestObjc {
                    statsData?(fast,close,objects)
                }
            }
        }
        
    }
    
    func fetchData(_ startDate: String, _ endDate: String) async  {
        
        do {
            let value = try await APIWrapper.shared().getNeoData(startDate, endDate)
            self.neoObjectData = value?.nearEarthObjects?.neoObjects.flatMap({$0.value})
            
        } catch let error {
            print(error)
        }
    }
    
    func daysDiffer(_ startDate: String, _ endDate: String) -> Int? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date1 = formatter.date(from:startDate)
        let date2 = formatter.date(from:endDate)
        if let start = date1, let end = date2 {
            let days = Calendar.current.numberOfDaysBetween(start, and: end)
            return days
        }
        
        return nil
    }
}
