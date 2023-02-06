//
//  Constatnts.swift
//  AsteroidNeo Stats
//
//  Created by Jagan on 05/02/23.
//

import Foundation
import Charts

struct Constants {

    static let BASE_URL = "https://api.nasa.gov/neo/rest/v1/feed?start_date={startDate}&end_date={endDate}&api_key=\(Constants.DEMO_KEY)"
    
    static let DEMO_KEY = "N5XX8gLefYMakv20A1iLj4LurtJSf09tWcu0cKfK"
    static let DAYS_LIMIT: Int = 5
    
}

class BarValueFormatter: ValueFormatter {
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.2f", value)
    }
}

struct NeoItemData {
    let index: Int
    let date: String
    let limit: Double
    
    func transformToBarChartDataEntry() -> BarChartDataEntry {
        let entry = BarChartDataEntry(x: Double(index), y: limit)
        return entry
    }
}

func getFormattedItemValue(_ rawValues: [String]) -> [NeoItemData] {
       var items = [NeoItemData]()
       var index = 0
       
       for i in rawValues {
           let valuePair = i.components(separatedBy: ",")
           let date = valuePair[0]
           let limit = valuePair[1]
           
           let limitRate = Double(limit) ?? 0.0

           items.append(NeoItemData(index: index, date: date, limit: limitRate))
           index += 1
       }
       return items
   }
