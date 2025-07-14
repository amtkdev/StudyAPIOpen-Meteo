//
//  WeatherViewModel.swift
//  StudyAPIOpen-Meteo
//
//  Created by AMTK on 2025/07/07.
//

import Foundation
import OpenMeteoSdk

class WeatherViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentWeather: CurrentWeather?
    @Published var currentUnits: CurrentUnits?
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Constants
    private let baseUrl = "https://api.open-meteo.com/v1/forecast"
    
    // MARK: - Methods
    func fetchWeather(latitude: Double = 34.62, longitude: Double = 136.50) async {
        // 1. Configure initial state
        isLoading = true
        errorMessage = nil
        
        // 2. Build the URL
        //&format=flatbuffers has deleted to avoid flatbuffers format instead of JSON
        let urlString = "\(baseUrl)?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,relative_humidity_2m,is_day,precipitation,rain,wind_speed_10m,wind_direction_10m"
        
        // 3. Verify the URL
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        // 4. Requisition
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            //Debug: show RAW JSON in console
            //print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
            
            // 5. Decode JSON
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
            
            // 6. Update state on main thread
            DispatchQueue.main.async {
                self.currentWeather = decodedData.current
                self.currentUnits = decodedData.current_units
                self.isLoading = false
            }
        } catch {
            // 7. errors
            DispatchQueue.main.async {
                self.errorMessage = "Failed to decode weather data: \(error.localizedDescription)"
                self.isLoading = false
                print("Decoding error details: \(error)")
            }
        }
    }
}
