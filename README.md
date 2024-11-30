# WeatherApp iOS

A modern iOS weather application built with SwiftUI that provides real-time weather information using the OpenWeather API.

## Features

- Current weather conditions display
- Hourly and weekly forecasts
- Multiple city search functionality
- Geolocation support
- Modern UI with animations and glassmorphism effects
- Accessibility support
- Dark mode support

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern and is built using:

- SwiftUI for UI
- Combine for reactive programming
- CoreLocation for geolocation
- URLSession for networking
- XCTest for unit and integration testing

## Setup

1. Clone the repository
2. Open `weatherapp.xcodeproj` in Xcode
3. Add your OpenWeather API key in `Config.swift`
4. Build and run the project

## Testing

The project includes:
- Unit tests for business logic
- UI tests for interface validation
- Integration tests for API calls

Run tests using Cmd+U in Xcode.

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## License

This project is licensed under the MIT License - see the LICENSE file for details.
