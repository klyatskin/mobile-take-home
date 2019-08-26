import UIKit

class EpisodeListViewController: UITableViewController {
    
    static let kEpisodeCellReuseId = "episodeCellReuseId"
    var episodes: [Episode] = []
    var error: Error?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episodes"
        tableView.register(UINib(nibName: "EpisodeCell", bundle: nil), forCellReuseIdentifier: EpisodeListViewController.kEpisodeCellReuseId)
        fetchEpisodes()
    }
    
    func fetchEpisodes() {
        EpisodeService().fetchEpisodes {[weak self] (episodes, error) in
            if let error = error {
                print("\(error)")
            }
            self?.episodes = episodes
            self?.updateUI()
        }
    }

    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


// MARK: - Table datasource

extension EpisodeListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeListViewController.kEpisodeCellReuseId, for: indexPath) as! EpisodeCell
        cell.titleLabel.text = episodes[indexPath.row].name
        return cell
    }
}


// MARK: - Table delegate


extension EpisodeListViewController {
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    guard let characterListViewController = storyboard.instantiateViewController(withIdentifier: "CharacterListViewController") as? CharacterListViewController else { return }

    characterListViewController.episode = episodes[indexPath.row]
    show(characterListViewController, sender: self)
    }
}
