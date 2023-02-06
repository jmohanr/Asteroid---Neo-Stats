//
//  NeoStat.swift
//  AsteroidNeo Stats
//
//  Created by Jagan on 05/02/23.
//

import Foundation

struct NeoStat: Decodable {
    let elementCount: Int?
    let nearEarthObjects: NearEarthObjects?
    
    enum CodingKeys: String,CodingKey {
        case elementCount = "element_count"
        case nearEarthObjects = "near_earth_objects"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        elementCount = try values.decodeIfPresent(Int.self, forKey: .elementCount)
        nearEarthObjects = try values.decodeIfPresent(NearEarthObjects.self, forKey: .nearEarthObjects)
        
    }
}


struct NearEarthObjects: Decodable {
    var neoObjects: [String: [NeoObjectData]]
    
    private struct DynamicCodingKeys: CodingKey {
        
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
        
    }


    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        self.neoObjects = [String:[NeoObjectData]]()
        for key in container.allKeys {
            let value = try container.decode([NeoObjectData].self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            self.neoObjects[key.stringValue] = value
        }
    }
}

struct NeoObjectData: Decodable {
    let id : String?
    let neo_reference_id : String?
    let name : String?
    let nasa_jpl_url : String?
    let absolute_magnitude_h : Double?
    let estimated_diameter : Estimated_diameter?
    let is_potentially_hazardous_asteroid : Bool?
    let close_approach_data : [Close_approach_data]?
    let is_sentry_object : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case neo_reference_id = "neo_reference_id"
        case name = "name"
        case nasa_jpl_url = "nasa_jpl_url"
        case absolute_magnitude_h = "absolute_magnitude_h"
        case estimated_diameter = "estimated_diameter"
        case is_potentially_hazardous_asteroid = "is_potentially_hazardous_asteroid"
        case close_approach_data = "close_approach_data"
        case is_sentry_object = "is_sentry_object"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.neo_reference_id = try container.decodeIfPresent(String.self, forKey: .neo_reference_id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.nasa_jpl_url = try container.decodeIfPresent(String.self, forKey: .nasa_jpl_url)
        self.absolute_magnitude_h = try container.decodeIfPresent(Double.self, forKey: .absolute_magnitude_h)
        self.estimated_diameter = try container.decodeIfPresent(Estimated_diameter.self, forKey: .estimated_diameter)
        self.is_potentially_hazardous_asteroid = try container.decodeIfPresent(Bool.self, forKey: .is_potentially_hazardous_asteroid)
        self.close_approach_data = try container.decodeIfPresent([Close_approach_data].self, forKey: .close_approach_data)
        self.is_sentry_object = try container.decodeIfPresent(Bool.self, forKey: .is_sentry_object)
    }
}

struct Miss_distance : Decodable {
    let astronomical : String?
    let lunar : String?
    let kilometers : String?
    let miles : String?
    
    enum CodingKeys: String, CodingKey {
        
        case astronomical = "astronomical"
        case lunar = "lunar"
        case kilometers = "kilometers"
        case miles = "miles"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        astronomical = try values.decodeIfPresent(String.self, forKey: .astronomical)
        lunar = try values.decodeIfPresent(String.self, forKey: .lunar)
        kilometers = try values.decodeIfPresent(String.self, forKey: .kilometers)
        miles = try values.decodeIfPresent(String.self, forKey: .miles)
    }
    
}

struct Relative_velocity : Decodable {
    let kilometers_per_second : String?
    let kilometers_per_hour : String?
    let miles_per_hour : String?
    
    enum CodingKeys: String, CodingKey {
        
        case kilometers_per_second = "kilometers_per_second"
        case kilometers_per_hour = "kilometers_per_hour"
        case miles_per_hour = "miles_per_hour"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kilometers_per_second = try values.decodeIfPresent(String.self, forKey: .kilometers_per_second)
        kilometers_per_hour = try values.decodeIfPresent(String.self, forKey: .kilometers_per_hour)
        miles_per_hour = try values.decodeIfPresent(String.self, forKey: .miles_per_hour)
    }
    
}

struct Miles : Decodable {
    let estimated_diameter_min : Double?
    let estimated_diameter_max : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case estimated_diameter_min = "estimated_diameter_min"
        case estimated_diameter_max = "estimated_diameter_max"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        estimated_diameter_min = try values.decodeIfPresent(Double.self, forKey: .estimated_diameter_min)
        estimated_diameter_max = try values.decodeIfPresent(Double.self, forKey: .estimated_diameter_max)
    }
    
}

struct Estimated_diameter : Decodable {
    let kilometers : Kilometers?
    let meters : Meters?
    let miles : Miles?
    let feet : Feet?
    
    enum CodingKeys: String, CodingKey {
        
        case kilometers = "kilometers"
        case meters = "meters"
        case miles = "miles"
        case feet = "feet"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kilometers = try values.decodeIfPresent(Kilometers.self, forKey: .kilometers)
        meters = try values.decodeIfPresent(Meters.self, forKey: .meters)
        miles = try values.decodeIfPresent(Miles.self, forKey: .miles)
        feet = try values.decodeIfPresent(Feet.self, forKey: .feet)
    }
    
}

struct Close_approach_data : Decodable {
    let close_approach_date : String?
    let close_approach_date_full : String?
    let epoch_date_close_approach : Int?
    let relative_velocity : Relative_velocity?
    let miss_distance : Miss_distance?
    let orbiting_body : String?
    
    enum CodingKeys: String, CodingKey {
        
        case close_approach_date = "close_approach_date"
        case close_approach_date_full = "close_approach_date_full"
        case epoch_date_close_approach = "epoch_date_close_approach"
        case relative_velocity = "relative_velocity"
        case miss_distance = "miss_distance"
        case orbiting_body = "orbiting_body"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        close_approach_date = try values.decodeIfPresent(String.self, forKey: .close_approach_date)
        close_approach_date_full = try values.decodeIfPresent(String.self, forKey: .close_approach_date_full)
        epoch_date_close_approach = try values.decodeIfPresent(Int.self, forKey: .epoch_date_close_approach)
        relative_velocity = try values.decodeIfPresent(Relative_velocity.self, forKey: .relative_velocity)
        miss_distance = try values.decodeIfPresent(Miss_distance.self, forKey: .miss_distance)
        orbiting_body = try values.decodeIfPresent(String.self, forKey: .orbiting_body)
    }
    
}

struct Feet : Decodable {
    let estimated_diameter_min : Double?
    let estimated_diameter_max : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case estimated_diameter_min = "estimated_diameter_min"
        case estimated_diameter_max = "estimated_diameter_max"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        estimated_diameter_min = try values.decodeIfPresent(Double.self, forKey: .estimated_diameter_min)
        estimated_diameter_max = try values.decodeIfPresent(Double.self, forKey: .estimated_diameter_max)
    }
}

struct Kilometers : Decodable {
    let estimated_diameter_min : Double?
    let estimated_diameter_max : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case estimated_diameter_min = "estimated_diameter_min"
        case estimated_diameter_max = "estimated_diameter_max"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        estimated_diameter_min = try values.decodeIfPresent(Double.self, forKey: .estimated_diameter_min)
        estimated_diameter_max = try values.decodeIfPresent(Double.self, forKey: .estimated_diameter_max)
    }
}

struct Meters : Decodable {
    let estimated_diameter_min : Double?
    let estimated_diameter_max : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case estimated_diameter_min = "estimated_diameter_min"
        case estimated_diameter_max = "estimated_diameter_max"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        estimated_diameter_min = try values.decodeIfPresent(Double.self, forKey: .estimated_diameter_min)
        estimated_diameter_max = try values.decodeIfPresent(Double.self, forKey: .estimated_diameter_max)
    }
    
}
