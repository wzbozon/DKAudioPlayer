//
//  AVAudioPlayer+Extensions.swift
//  DKAudioPlayer
//
//  Created by Denis Kutlubaev on 02.10.2022.
//

import AVFoundation
import Foundation

extension AVAudioPlayer {

    var audioDurationText: String {
        AVAudioPlayer.durationFormatter.allowedUnits = duration < Constants.oneHour ? [.minute, .second] : [.hour, .minute, .second]
        return AVAudioPlayer.durationFormatter.string(from: duration) ?? ""
    }

    var currentTimeText: String {
        AVAudioPlayer.durationFormatter.allowedUnits = currentTime < Constants.oneHour ? [.minute, .second] : [.hour, .minute, .second]
        return AVAudioPlayer.durationFormatter.string(from: currentTime) ?? ""
    }

    private static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()

    private enum Constants {
        static let oneHour: TimeInterval = 3_600
    }

}
