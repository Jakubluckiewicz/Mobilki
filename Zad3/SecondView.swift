import SwiftUI
import CoreLocation

struct SecondView: View {
    @Binding var wasShaken: Bool

    @StateObject private var locationManager = LocationManager()
    @State private var color: Color = .white
    @State private var isLocationRequested = false
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var address = ""

    var body: some View {
        VStack(spacing: 10) {
            Button("Get localization") {
                isLocationRequested = true
                locationManager.checkLocationAuthorization()
                updateLocation()
            }
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)

            Text("Latitude: \(latitude)")
                .padding(10)
            Text("Longitude: \(longitude)")
                .padding(10)
            Text("Address: \(address)")
                .multilineTextAlignment(.center)
                .padding(10)

            SimulatorShakeButton()
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color)
        .onAppear {
            color = wasShaken ? ColorHelper.getRandomColor() : .white
        }
        .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
            self.color = ColorHelper.getRandomColor()
        }
        .onReceive(locationManager.$location) { _ in
            if isLocationRequested {
                updateLocation()
            }
        }
    }

    func updateLocation() {
        guard let location = locationManager.location else { return }

        self.latitude = location.coordinate.latitude.description
        self.longitude = location.coordinate.longitude.description

        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            guard let p = placemarks?.first else { return }
            self.address = [
                p.location?.description,
                p.thoroughfare,
                p.subAdministrativeArea,
                p.isoCountryCode,
                p.country
            ]
            .compactMap { $0 }
            .joined(separator: ", ")
        }
        isLocationRequested = false
    }
}

#Preview {
    SecondView(wasShaken: .constant(true))
}
