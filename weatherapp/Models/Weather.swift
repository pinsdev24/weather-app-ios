import Foundation

struct WeatherResponse: Codable {
    let coord: Coord
    let weather: [WeatherDetail]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: TimeInterval
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
    let sea_level: Int?
    let grnd_level: Int?
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

struct WeatherDetail: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct City: Codable, Identifiable {
    let id = UUID()
    let name: String
    let lat: Double
    let lon: Double
}

struct ForecastWeatherResponse: Codable {
    let list: [Forecast]
}

struct Forecast: Codable {
    let dt: TimeInterval
    let main: ForecastMain
    let weather: [WeatherDetail]
}

struct ForecastMain: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}
