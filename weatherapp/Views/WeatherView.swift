import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(UIColor.systemBackground), Color(UIColor.secondarySystemBackground)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    searchBar
                    
                    if let currentWeather = viewModel.currentWeather {
                        GlassmorphicCard {
                            currentWeatherView(weather: currentWeather)
                        }
                        
                        GlassmorphicCard {
                            weatherDetailsView
                        }

                        GlassmorphicCard {
                            hourlyForecastView
                        }
                    } else if viewModel.isLoading {
                        ProgressView()
                    }
                }
                .padding()
            }
        }
        .onAppear {
            if let location = locationManager.location {
                viewModel.fetchWeather(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                viewModel.fetch24HourForecast(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
            }
        }
        .onChange(of: locationManager.location) { location in
            if let location = location {
                viewModel.fetchWeather(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                viewModel.fetch24HourForecast(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
            }
        }
    }
    
    private var searchBar: some View {
        GlassmorphicCard {
            TextField("Search city...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: searchText) { query in
                    viewModel.searchCity(query: query)
                }
        }
    }
    
    private func currentWeatherView(weather: Main) -> some View {
        VStack(alignment: .center, spacing: 10) {
            Text(viewModel.formatTemperature(weather.temp))
                .font(.system(size: 72, weight: .bold))
                .foregroundColor(Color.primary)
            
            Text("Feels like \(viewModel.formatTemperature(weather.feels_like))")
                .font(.title3)
                .foregroundColor(Color.secondary)
            
            HStack {
                Label("\(weather.humidity)%", systemImage: "humidity")
                Spacer()
                Label("\(Int(weather.pressure)) hPa", systemImage: "barometer")
            }
            .padding(.top)
            .foregroundColor(Color.secondary)
        }
    }
    
    private var weatherDetailsView: some View {
        VStack {
            ForEach(viewModel.weatherDetails, id: \.id) { detail in
                HStack {
                    Text(detail.main)
                    Spacer()
                    Text(detail.description.capitalized)
                }
                .padding(.vertical, 5)
                .foregroundColor(Color.primary)
            }
        }
    }

    private var hourlyForecastView: some View {
        VStack(alignment: .leading) {
            Text("24-Hour Forecast")
                .font(.headline)
                .padding(.bottom, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(viewModel.hourlyForecast, id: \.dt) { forecast in
                        VStack {
                            Text(viewModel.formatTime(forecast.dt))
                                .font(.caption)
                            Text(viewModel.formatTemperature(forecast.main.temp))
                                .font(.headline)
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground).opacity(0.7))
                        .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
    }
}
