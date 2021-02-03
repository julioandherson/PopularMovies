import UIKit

/// The protocol responsible to display a error alert.
protocol DialogProtocol{}

extension DialogProtocol {
    /// Show error alert.
    /// - Parameters:
    ///   - controller: The controller to show dialog.
    ///   - title: The dialog title.
    ///   - message: The dialog body message.
    ///   - completionHandler: The callback after 'ok' tapped.
    func showErrorAlert(controller: UIViewController,
                   title: String = "DialogTitle".localized(),
                   message: String = "DialogMessage".localized(),
                   completionHandler: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok".localized(), style: .default, handler: {_ in
            if let callback = completionHandler {
                callback()
            }
        }))

        DispatchQueue.main.async {
            controller.present(alert, animated: true, completion: nil)
        }
    }
}
