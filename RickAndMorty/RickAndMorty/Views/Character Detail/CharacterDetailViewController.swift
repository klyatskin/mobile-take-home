import Foundation
import UIKit

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var killButton: UIView!
    
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        imageView.loadImageUsingCache(withUrl: character!.image)
        nameLabel.text = character!.name
        speciesLabel.text = character!.species
        originLabel.text = character!.origin.name
        genderLabel.text = character!.gender
        locationLabel.text = character!.location.name
        createdLabel.text = character?.created.description
        updateStatus()
    }
    
    func updateStatus() {
        let status = CharacterManager.shared.status(of: character!)
        killButton.isHidden = status == Character.LiveStatus.dead
        statusLabel.text = status
    }
    
    @IBAction func killCharacterDidTap(_ sender: Any) {
        presentKillOption(character!)
    }
}

// MARK: - Actions

extension CharacterDetailViewController {
    func presentKillOption(_ character: Character) {
        let alert = UIAlertController(title: "Kill " + character.name, message: "Should we kill " + character.name + "?", preferredStyle: .alert)
        let killAction = UIAlertAction(title: "Kill " + character.name + "!", style: .destructive) { (action) in
            self.kill(character)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alert.addAction(killAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func kill(_ character: Character) {
        CharacterManager.shared.kill(character)
        updateStatus()
    }
}
