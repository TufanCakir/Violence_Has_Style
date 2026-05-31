//
//  MusicManager.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 31.05.26.
//

import AVFoundation
import Foundation
import Observation

@MainActor
@Observable
final class MusicManager {
    static let shared = MusicManager()

    private var player: AVQueuePlayer?
    private var currentMode: RunMode?
    private var currentPlaylistIds: [String] = []

    private init() {}

    func configure(isEnabled: Bool, volume: Double) {
        player?.volume = Float(volume)

        if isEnabled {
            player?.play()
        } else {
            player?.pause()
        }
    }

    func play(mode: RunMode?, isEnabled: Bool, volume: Double) {
        play(
            mode: mode,
            isEnabled: isEnabled,
            volume: volume,
            ownedUnlockIds: []
        )
    }

    func play(
        mode: RunMode?,
        isEnabled: Bool,
        volume: Double,
        ownedUnlockIds: [String]
    ) {
        currentMode = mode

        guard isEnabled else {
            player?.pause()
            return
        }

        let tracks = MusicCatalog.shared.playlist(
            for: mode,
            ownedUnlockIds: ownedUnlockIds
        )
        let playlistIds = tracks.map(\.id)

        if playlistIds == currentPlaylistIds, let player {
            player.volume = Float(volume)
            player.play()
            return
        }

        let items = tracks.compactMap { track -> AVPlayerItem? in
            guard let url = RemoteContentStore.shared.contentURL(track.url)
            else { return nil }
            return AVPlayerItem(url: url)
        }

        guard !items.isEmpty else { return }

        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)

        let player = AVQueuePlayer(items: items)
        player.actionAtItemEnd = .advance
        player.volume = Float(volume)
        player.play()

        self.player = player
        currentPlaylistIds = playlistIds
    }

    func stop() {
        player?.pause()
    }
}
