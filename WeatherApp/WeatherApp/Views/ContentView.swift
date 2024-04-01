//
//  ContentView.swift
//  WeatherApp
//
//  Created by Hordur Thor Jonsson on 24/03/2024.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    // Replace YOUR_API_KEY in WeatherManager with your own API key for the app to work
    @Environment(\.scenePhase) var scenePhase
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    @State var timer: Timer?
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if let weather = weather {
                    WeatherView(weather: weather)
                        .onAppear {
                            print("onAppear")
                            setTimer(location)
                        }
                        .onDisappear {
                        }
                        // https://www.hackingwithswift.com/books/ios-swiftui/how-to-be-notified-when-your-swiftui-app-moves-to-the-background
                        .onChange(of: scenePhase) { oldPhase, newPhase in
                            if newPhase == .active {
                                print("Active")
                                setTimer(location)
                            } else if newPhase == .inactive {
                                print("Inactive")
                            } else if newPhase == .background {
                                print("Background")
                                
                                timer?.invalidate()
                                timer = nil
                            }
                        }
                } else {
                    LoadingView()
                        .task {
                            await fetchWeather(location)
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
    
    func setTimer(_ location: CLLocationCoordinate2D) {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 15*60, repeats: true) { _ in
                Task {
                    await fetchWeather(location)
                    print("fetchWeather")
                }
            }
            Task {
                await fetchWeather(location)
                print("fetchWeather")
            }
        }
    }
    
    func fetchWeather(_ location: CLLocationCoordinate2D) async {
        do {
            weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
        } catch {
            print("Error getting weather: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
