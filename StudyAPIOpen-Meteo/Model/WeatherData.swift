//
//  WeatherData.swift
//  StudyAPIOpen-Meteo
//
//  Created by AMTK on 2025/07/07.
//

import Foundation

//Codable structs for the Weather response from API
struct WeatherData: Decodable {
    let current: CurrentWeather
}

struct CurrentWeather: Decodable {
    let temperature_2m: Double
    let wind_speed_10m: Double
}
