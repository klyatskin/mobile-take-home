import Foundation
import UIKit


class CharacterListViewController: UITableViewController {
    
    var episode: Episode?
    static let kCharacterCellReuseId = "characterCellReuseId"
    private var fetchedCharacters: [Character] = []
    private var aliveCharacters: [Character] = []
    private var deadCharacters: [Character] = []

// MARK: - VC lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Characters"
        tableView.register(UINib(nibName: "CharacterCell", bundle: nil), forCellReuseIdentifier: CharacterListViewController.kCharacterCellReuseId)
        fetchCharacters()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        sortCharacters()
        tableView.reloadData()
    }
}


// MARK: - Table datasource

extension CharacterListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? Character.LiveStatus.alive: Character.LiveStatus.dead
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? aliveCharacters.count : deadCharacters.count
     }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let character = (indexPath.section == 0) ? aliveCharacters[indexPath.row] : deadCharacters[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterListViewController.kCharacterCellReuseId, for: indexPath) as! CharacterCell
        cell.character = character
        cell.nameLabel.text = character.name
        let status = CharacterManager.shared.status(of: character)
        cell.statusLabel.text = status
        cell.statusLabel.textColor = status == Character.LiveStatus.alive ? .black : .red
        return cell
    }
}


// MARK: - Table delegate

extension CharacterListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let character = (indexPath.section == 0) ? aliveCharacters[indexPath.row] : deadCharacters[indexPath.row]
        guard let characterViewController = storyboard.instantiateViewController(withIdentifier: "CharacterDetailViewController") as? CharacterDetailViewController else { return }
        characterViewController.character = character
        show(characterViewController, sender: nil)
    }
}


// MARK: - Helpers

extension CharacterListViewController {

    func fetchCharacters() {
        fetchedCharacters = []
        let characterService = CharacterService()
        
        var charactersToFetch: [String] = []
        episode?.characters.forEach { (url) in
            if let id = url.components(separatedBy: "/").last {
                charactersToFetch.append(id)
            }
        }
        
        for id in charactersToFetch {
            characterService.fetchCharacters(id: id) { (character, error) in
                if let character = character {
                    DispatchQueue.main.async {
                        self.fetchedCharacters.append(character)
                        self.updateUI()
                    }
                }
            }
        }
    }
    
    func sortCharacters() {
        aliveCharacters = fetchedCharacters.filter {
            CharacterManager.shared.status(of: $0) == Character.LiveStatus.alive
        }
        deadCharacters = fetchedCharacters.filter {
            CharacterManager.shared.status(of: $0) == Character.LiveStatus.dead
        }
        aliveCharacters.sort { (character1, character2) -> Bool in
            return character1.created < character2.created
        }
        deadCharacters.sort { (character1, character2) -> Bool in
            return character1.created < character2.created
        }
    }
}
