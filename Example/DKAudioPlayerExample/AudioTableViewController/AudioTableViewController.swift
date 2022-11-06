//
//  AudioTableViewController.swift
//  DKAudioPlayerExample
//
//  Created by Denis Kutlubaev on 06.11.2022.
//

import DKAudioPlayer
import UIKit

@objc
class AudioTableViewController: UITableViewController {

    override init(style: UITableView.Style) {
        super.init(style: style)

        tabBarItem.title = "Table View"
        tabBarItem.image = UIImage(named: "259-list")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // By default first audio file is set up to play
        setAudioPlayer(for: tableData[0])
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier)
        }

        cell?.textLabel?.text = tableData[indexPath.row]

        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Removing current audioplayer
        audioPlayer.dismiss()

        // Setting audio player as a table header view for current file
        setAudioPlayer(for: tableData[indexPath.row])

        // Automatically staring playing that file
        audioPlayer.play()
    }

    // Reinitialize audioPlayer for each file
    // This is not optimal, but simple solution
    private func setAudioPlayer(for fileName: String) {
        guard let audioFilePath = Bundle.main.path(forResource: fileName, ofType: nil)
        else { return }

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80))
        containerView.backgroundColor = .systemBackground

        audioPlayer = DKAudioPlayer(audioFilePath: audioFilePath)
        audioPlayer.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(audioPlayer)
        containerView.addConstraints([
            audioPlayer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            audioPlayer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            audioPlayer.topAnchor.constraint(equalTo: containerView.topAnchor),
            audioPlayer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        tableView.tableHeaderView = containerView
    }

    private var audioPlayer: DKAudioPlayer!

    private let tableData: [String] = ["sample.mp3", "sample1.mp3", "sample2.mp3"]

    private let cellReuseIdentifier = "CellReuseIdentifier"
}
