//
//  ViewController.swift
//  DKAudioPlayerExample
//
//  Created by Denis Kutlubaev on 22.11.2022.
//

import DKAudioPlayer
import UIKit

class ViewController: UIViewController {
    private var audioPlayer: DKAudioPlayer?
    @IBOutlet private weak var audioPlayerContainerView: UIView!
    @IBOutlet private weak var audioPlayerContainerViewBottomConstraint: NSLayoutConstraint!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        tabBarItem.title = "View"
        tabBarItem.image = UIImage(named: "42-photos")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAudioPlayer()
    }

    func setupAudioPlayer() {
        guard let audioFilePath = Bundle.main.path(forResource: "sample.mp3", ofType: nil) else {
            return
        }

        audioPlayer = DKAudioPlayer(audioFilePath: audioFilePath)
        if let audioPlayer {
            audioPlayerContainerView.addSubview(audioPlayer)
        }
        audioPlayer?.translatesAutoresizingMaskIntoConstraints = false
        audioPlayerContainerView.addConstraints(
            [
                audioPlayer?.leadingAnchor.constraint(equalTo: audioPlayerContainerView.leadingAnchor),
                audioPlayer?.trailingAnchor.constraint(equalTo: audioPlayerContainerView.trailingAnchor),
                audioPlayer?.bottomAnchor.constraint(equalTo: audioPlayerContainerView.bottomAnchor),
                audioPlayer?.topAnchor.constraint(equalTo: audioPlayerContainerView.topAnchor)
            ].compactMap { $0 })
    }

    @IBAction func showHideButtonTapped(_ sender: Any) {
        // You can show or hide your player as you want
        // This is just an example
        // When you hide it this way, the music doesn't stop
        // If you want to stop a music, use a dismiss method or pause
        UIView.animate(withDuration: 0.4, animations: { [self] in
            if audioPlayerContainerViewBottomConstraint.constant != 0 {
                audioPlayerContainerViewBottomConstraint.constant = 0
            } else {
                let bottomInset = keyWindow?.safeAreaInsets.bottom ?? 0.0
                audioPlayerContainerViewBottomConstraint.constant = -(audioPlayerContainerView.bounds.size.height + bottomInset)
            }
            view.setNeedsLayout()
            view.layoutIfNeeded()
        })
    }

    var keyWindow: UIWindow? {
        var foundWindow: UIWindow? = nil
        let windows = UIApplication.shared.windows

        for window in windows {
            if window.isKeyWindow {
                foundWindow = window
                break
            }
        }

        return foundWindow
    }
}
