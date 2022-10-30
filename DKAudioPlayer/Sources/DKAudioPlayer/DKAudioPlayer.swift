//
//  DKAudioPlayer.swift
//  DKAudioPlayer
//
//  Created by Denis Kutlubaev on 02.10.2022.
//

import AVFoundation
import Combine
import UIKit

protocol DKAudioPlayerDelegate: AnyObject {

    /// Called when audio player updates a playback time
    /// - Parameter audioPlayer: Instance of DKAudioPlayer
    func didUpdatePlaybackTime(in audioPlayer: DKAudioPlayer)
}

@objc
public class DKAudioPlayer: UIView {
    weak var delegate: DKAudioPlayerDelegate?

    var volume: Float = 0.5

    var duration: TimeInterval = 0.0

    var currentSecond = 0
    
    @objc
    public init(audioFilePath: String) {
        self.viewModel = DKAudioPlayerViewModel(audioFilePath: audioFilePath)

        super.init(frame: .zero)

        setupUI()
        setupLayout()
        bindViewModel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    public func play() {
        viewModel.play()
    }

    @objc
    public func dismiss() {
        viewModel.pause()
        removeFromSuperview()
    }

    private lazy var timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var bubbleView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true

        return view
    }()

    private lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constants.bubbleImage
        imageView.contentMode = .scaleToFill

        return imageView
    }()

    private lazy var bubbleTimeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = Constants.bubbleTimeLabelFont
        label.text = "22:58"

        return label
    }()

    private lazy var slider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setMaximumTrackImage(Constants.maximumTrackImage, for: .normal)
        slider.setMinimumTrackImage(Constants.minimumTrackImage, for: .normal)
        slider.setThumbImage(Constants.thumbImage, for: .normal)
        slider.minimumValue = 0.0
        slider.maximumValue = Float(viewModel.audioDuration)
        slider.isContinuous = false
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(didBeginDraggingSlider), for: .touchDown)
        slider.addTarget(self, action: #selector(didEndDraggingSlider), for: .valueChanged)

        return slider
    }()

    private lazy var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.backgroundColor

        return view
    }()

    private lazy var playerBgImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Constants.backgroundImage
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var playPauseButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.playImage, for: .normal)
        button.addTarget(self, action: #selector(playOrPauseTapped), for: .touchUpInside)

        return button
    }()

    private lazy var bubbleViewLeadingConstraint: NSLayoutConstraint = {
        let constraint = bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor)
        return constraint
    }()

    private var disposeBag = Set<AnyCancellable>()

    private let viewModel: DKAudioPlayerViewModel

}

// MARK: - Private

private extension DKAudioPlayer {

    static let bundle = Bundle(for: DKAudioPlayer.self)

    enum Constants {
        static let inset = 15 as CGFloat

        static let bubbleTimeLabelFont = UIFont.systemFont(ofSize: 9)

        // TODO: Move color to color assets or use system colors
        static let backgroundColor = UIColor(
            red: 232.0 / 255.0,
            green: 232.0 / 255.0,
            blue: 232.0 / 255.0,
            alpha: 1.0
        )

        static let leftCapWidth = 5
        static let topCapHeight = 5
        static let trackImageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        static let backgroundImage: UIImage? = {
            DKImage(named: "player_player_bg")?
                .stretchableImage(
                    withLeftCapWidth: Constants.leftCapWidth,
                    topCapHeight: Constants.topCapHeight
                )
        }()

        static let playImage: UIImage? = {
            DKImage(named: "player_play")
        }()

        static let pauseImage: UIImage? = {
            DKImage(named: "player_pause")
        }()

        static let maximumTrackImage: UIImage? = {
            DKImage(named: "player_progress_bg")?
                .resizableImage(
                    withCapInsets: Constants.trackImageEdgeInsets
                )
        }()

        static let minimumTrackImage: UIImage? = {
            DKImage(named: "player_progress_blue")?
                .resizableImage(
                    withCapInsets: Constants.trackImageEdgeInsets
                )
        }()

        static let thumbImage: UIImage? = {
            DKImage(named: "player_circle")
        }()

        static let bubbleImage: UIImage? = {
            DKImage(named: "player_bubble")
        }()
    }

    func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(playerBgImageView)
        addSubview(playPauseButton)
        addSubview(slider)
        addSubview(bubbleView)
        bubbleView.addSubview(bubbleImageView)
        bubbleView.addSubview(bubbleTimeLabel)
    }

    func setupLayout() {
        setupPlayerBgImageView()
        setupPlayPauseButton()
        setupSlider()
        setupBubbleView()
        setupBubbleImageView()
        setupBubbleTimeLabel()
    }

    func setupPlayerBgImageView() {
        addConstraints([
            playerBgImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.inset),
            playerBgImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.inset),
            playerBgImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.inset),
            playerBgImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.inset)
        ])
    }

    func setupPlayPauseButton() {
        addConstraints([
            playPauseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.inset),
            playPauseButton.topAnchor.constraint(equalTo: playerBgImageView.topAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: playerBgImageView.bottomAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }

    func setupSlider() {
        addConstraints([
            slider.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor),
            slider.trailingAnchor.constraint(equalTo: playerBgImageView.trailingAnchor, constant: -Constants.inset),
            slider.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func setupBubbleView() {
        addConstraints([
            bubbleView.bottomAnchor.constraint(equalTo: slider.topAnchor),
            bubbleViewLeadingConstraint
        ])
    }

    func setupBubbleImageView() {
        bubbleView.addConstraints([
            bubbleImageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            bubbleImageView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            bubbleImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            bubbleImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor)
        ])
    }

    func setupBubbleTimeLabel() {
        bubbleView.addConstraints([
            bubbleTimeLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 6),
            bubbleTimeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -6),
            bubbleTimeLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 7)
        ])
    }

    @objc
    func playOrPauseTapped(_ sender: UIButton) {
        viewModel.playOrPause()
    }

    @objc
    func sliderValueChanged(_ sender: UISlider) {
        viewModel.updateCurrentTime(to: TimeInterval(sender.value))
    }

    func bindViewModel() {
        viewModel.isPlaying.sink { [unowned self] isPlaying in
            let image = isPlaying ? Constants.pauseImage : Constants.playImage
            self.playPauseButton.setImage(image, for: .normal)
        }
        .store(in: &disposeBag)

        viewModel.currentTime.sink { [unowned self] currentTime in
            self.slider.setValue(Float(currentTime), animated: false)

            if self.bubbleView.bounds.size.width > 0 {
                self.bubbleViewLeadingConstraint.constant = xPositionFromSliderValue(self.slider) - self.bubbleView.bounds.size.width / 2
                self.bubbleView.setNeedsLayout()
                self.bubbleView.layoutIfNeeded()
                self.bubbleView.isHidden = false
            } else {
                self.bubbleView.isHidden = true
            }
        }
        .store(in: &disposeBag)

        viewModel.currentTimeText.sink { [unowned self] currentTimeText in
            self.bubbleTimeLabel.text = currentTimeText
            self.bubbleView.isHidden = currentTimeText.isEmpty || self.bubbleView.bounds.size.width == 0
        }
        .store(in: &disposeBag)
    }

    func xPositionFromSliderValue(_ slider: UISlider) -> CGFloat {
        guard let currentThumbImage = slider.currentThumbImage else { return 0 }

        let sliderRange = slider.frame.size.width - currentThumbImage.size.width
        let sliderOrigin = slider.frame.origin.x + currentThumbImage.size.width / 2.0
        let sliderValueToPixels = (CGFloat((slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue)) * sliderRange) + sliderOrigin

        return CGFloat(sliderValueToPixels)
    }

    @objc
    func didBeginDraggingSlider() {
        bubbleView.isHidden = true
        viewModel.pauseUpdates()
    }

    @objc
    func didEndDraggingSlider() {
        bubbleViewLeadingConstraint.constant = xPositionFromSliderValue(self.slider) - self.bubbleView.bounds.size.width / 2
        bubbleView.setNeedsLayout()
        bubbleView.layoutIfNeeded()
        bubbleView.isHidden = false
        viewModel.resumeUpdates()
    }
    
}
