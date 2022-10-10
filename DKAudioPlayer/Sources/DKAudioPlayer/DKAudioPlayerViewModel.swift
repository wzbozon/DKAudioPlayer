//
//  DKAudioPlayerViewModel.swift
//  DKAudioPlayer
//
//  Created by Denis Kutlubaev on 02.10.2022.
//

import AVFoundation
import Combine
import Foundation

class DKAudioPlayerViewModel {

    var audioDurationText: String {
        audioPlayer.audioDurationText
    }

    var audioDuration: TimeInterval {
        audioPlayer.duration
    }

    var currentTimeText: AnyPublisher<String, Never> {
        return _currentTimeText.eraseToAnyPublisher()
    }

    var isPlaying: AnyPublisher<Bool, Never> {
        return _isPlaying.eraseToAnyPublisher()
    }

    var currentTime: AnyPublisher<TimeInterval, Never> {
        return _currentTime.eraseToAnyPublisher()
    }

    // MARK: - Init

    init(audioData: Data) {
        self.audioData = audioData
        audioFilePath = nil

        updateState()
    }

    init(audioFilePath: String) {
        self.audioFilePath = audioFilePath
        audioData = nil

        updateState()
    }

    // MARK: - Public methods

    func play() {
        guard !audioPlayer.isPlaying else { return }

        audioPlayer.play()
        _isPlaying.send(true)

        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    }

    func pause() {
        guard audioPlayer.isPlaying else { return }

        audioPlayer.pause()
        _isPlaying.send(false)

        timer?.invalidate()
        timer = nil
    }

    func playOrPause() {
        if audioPlayer.isPlaying {
            pause()
        } else {
            play()
        }
    }

    func pauseUpdates() {
        isUpdatesPaused = true
    }

    func resumeUpdates() {
        isUpdatesPaused = false
    }

    func updateCurrentTime(to currentTime: TimeInterval) {
        audioPlayer.currentTime = currentTime
        updateState()
    }

    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback)
        try? audioSession.setActive(true)
    }

    // MARK: - Private

    private lazy var audioPlayer: AVAudioPlayer = {
        if let audioData = self.audioData {
            do {
                let player = try AVAudioPlayer(data: audioData)
                return player
            } catch {
                print("Error: \(error)")
            }
        }

        if let audioFilePath = self.audioFilePath {
            do {
                let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioFilePath))
                return player
            } catch {
                print("Error: \(error)")
            }
        }

        assertionFailure("[DKAudioPlayer] Failed to initialize AVAudioPlayer")

        return AVAudioPlayer()
    }()
    
    private let audioData: Data?
    private let audioFilePath: String?

    private let _totalDurationText = CurrentValueSubject<String, Never>("")
    private let _currentTimeText = CurrentValueSubject<String, Never>("")
    private let _isPlaying = CurrentValueSubject<Bool, Never>(false)
    private let _currentTime = CurrentValueSubject<TimeInterval, Never>(0)

    private var timer: Timer?
    private var isUpdatesPaused: Bool = false

    // TODO: Draw class diagram View - ViewModel - Model (AVAudioPlayer) with data bindings
}

// MARK: - Private

private extension DKAudioPlayerViewModel {

    @objc
    func onTimer(_ sender: Timer) {
        guard !isUpdatesPaused else { return }

        updateState()
    }

    func updateState() {
        _currentTime.send(audioPlayer.currentTime)

        let timeText = audioPlayer.currentTimeText + " / " + audioPlayer.audioDurationText
        _currentTimeText.send(timeText)
    }

}

// MARK: - AVAudioPlayerDelegate

extension DKAudioPlayer: AVAudioPlayerDelegate {

}
