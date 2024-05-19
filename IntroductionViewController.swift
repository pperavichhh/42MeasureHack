import SwiftUI
import UIKit

class IntroductionViewController: UIViewController {

    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // Navigate to the next page
        let arViewContainer = ARViewContainer()
        let arView = UIHostingController(rootView: arViewContainer)
        navigationController?.pushViewController(arView, animated: true)
    }
}
