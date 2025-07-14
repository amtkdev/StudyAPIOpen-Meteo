//
//  WeatherData.swift
//  StudyAPIOpen-Meteo
//
//  Created by AMTK on 2025/07/07.
//

import Foundation

//Codable structs for the Weather response from API
struct WeatherData: Codable {
    let current: CurrentWeather         //real values
    let current_units: CurrentUnits?    //units values
}

struct CurrentWeather: Codable {
    let time: String
    let temperature_2m: Double
    let relative_humidity_2m: Double?
    let is_day: Int?
    let precipitation: Double?
    let rain: Double?
    let wind_speed_10m: Double
    let wind_direction_10m: Double?
}

struct CurrentUnits: Codable {
    let time: String?
    let temperature_2m: String?
    let relative_humidity_2m: String?
    let is_day: String?
    let precipitation: String?
    let rain: String?
    let wind_speed_10m: String?
    let wind_direction_10m: String?
}
