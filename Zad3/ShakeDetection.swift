import UIKit

extension NSNotification.Name {
    public static let deviceDidShakeNotification = NSNotification.Name("DeviceShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            NotificationCenter.default.post(name: .deviceDidShakeNotification, object: event)
        }
    }
}
