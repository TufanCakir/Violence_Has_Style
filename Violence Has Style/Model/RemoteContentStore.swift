//
//  RemoteContentStore.swift
//  Violence Has Style
//
//  Created by Tufan Cakir on 30.05.26.
//

import Foundation
import Observation

@Observable
final class RemoteContentStore {
    static let shared = RemoteContentStore()

    static let manifestURL = URL(
        string: "https://remoterviolencehasstyle.tufancakir.com/manifest.json"
    )!

    private(set) var enemyDefinitions: [String: EnemyDefinition] = [:]
    private(set) var levelDefinitions: [LevelDefinition] = []
    private(set) var characterDefinitions: [PlayerCharacter] = []
    private(set) var rewardDefinitions: [RunReward] = []
    private(set) var eventDefinitions: [EventDefinition] = []
    private(set) var storyChapters: [StoryChapter] = []
    private(set) var musicTracks: [MusicTrack] = []
    private(set) var themeDefinitions: [ThemeDefinition] = []
    private(set) var stylePassDefinitions: [StylePassDefinition] = []
    private(set) var premiumStoreProducts: [PremiumStoreProduct] = []
    private(set) var enemyAvatarDefinitions: [EnemyAvatarDefinition] =
        EnemyAvatarDefinition.fallback
    private(set) var loginCampaignDefinitions: [LoginCampaignDefinition] =
        LoginCampaignDefinition.fallback
    private(set) var giftDefinitions: [GiftDefinition] = GiftDefinition.fallback
    private(set) var styleAwakeningDefinitions: [StyleAwakeningDefinition] =
        StyleAwakeningDefinition.fallback
    private(set) var uiConfig = UIConfig.fallback
    private(set) var gameConfig = GameConfig.fallback
    private(set) var isOnline = false
    private(set) var statusMessage = "CONNECTING TO STYLE SERVER"
    private(set) var loadingProgress = 0.0
    private(set) var loadedItemCount = 0
    private(set) var totalItemCount = 1
    private(set) var downloadedBytes = 0
    private(set) var totalBytes = 0

    private var assetsBaseURL: URL?
    private var musicBaseURL: URL?
    private var assetURLs: [String: URL] = [:]
    private var musicURLs: [String: URL] = [:]
    private var warmedURLStrings: Set<String> = []
    private let urlSession: URLSession

    private init() {
        let cache = URLCache(
            memoryCapacity: 40 * 1024 * 1024,
            diskCapacity: 180 * 1024 * 1024
        )
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.timeoutIntervalForRequest = 12
        configuration.timeoutIntervalForResource = 24
        urlSession = URLSession(configuration: configuration)
    }

    @MainActor
    func refresh() async {
        beginLoading(totalItems: 15, status: "LOADING MANIFEST")

        guard
            let manifest: RemoteManifest = await loadJSON(
                from: Self.manifestURL
            )
        else {
            resetRemoteContent(status: "MANIFEST REQUIRED")
            return
        }
        advanceLoading(status: "MANIFEST LOADED")

        assetsBaseURL = resolvedURL(
            manifest.assetsBaseURL
        )

        musicBaseURL = resolvedURL(
            manifest.musicBaseURL
        )

        assetURLs = mediaURLMap(
            from: manifest.assets,
            baseURL: assetsBaseURL
        )

        musicURLs = mediaURLMap(
            from: manifest.music,
            baseURL: musicBaseURL
        )
        musicTracks = manifest.music.map { file in
            MusicTrack(
                id: file.id,
                title: file.title ?? file.id.uppercased(),
                url: musicURLs[file.id]?.absoluteString ?? file.url,
                mode: file.mode,
                requiredUnlock: file.requiredUnlock
            )
        }

        guard
            let enemyURL = manifest.dataURL(
                for: "enemies",
                baseURL: Self.manifestURL
            ),
            let levelURL = manifest.dataURL(
                for: "levels",
                baseURL: Self.manifestURL
            ),
            let characterURL = manifest.dataURL(
                for: "characters",
                baseURL: Self.manifestURL
            ),
            let rewardURL = manifest.dataURL(
                for: "rewards",
                baseURL: Self.manifestURL
            ),
            let eventURL = manifest.dataURL(
                for: "events",
                baseURL: Self.manifestURL
            ),
            let storyURL = manifest.dataURL(
                for: "story",
                baseURL: Self.manifestURL
            ),
            let configURL = manifest.dataURL(
                for: "config",
                baseURL: Self.manifestURL
            ),
            let themeURL = manifest.dataURL(
                for: "themes",
                baseURL: Self.manifestURL
            ),
            let stylePassURL = manifest.dataURL(
                for: "stylePasses",
                baseURL: Self.manifestURL
            )
        else {
            resetRemoteContent(status: "MANIFEST DATA IDS MISSING")
            return
        }

        let uiConfigURL = manifest.dataURL(
            for: "uiConfig",
            baseURL: Self.manifestURL
        )
        let premiumStoreURL = manifest.dataURL(
            for: "premiumStore",
            baseURL: Self.manifestURL
        )
        let enemyAvatarURL = manifest.dataURL(
            for: "enemyAvatars",
            baseURL: Self.manifestURL
        )
        let loginCampaignURL = manifest.dataURL(
            for: "dailyLogins",
            baseURL: Self.manifestURL
        )
        let giftURL = manifest.dataURL(
            for: "gifts",
            baseURL: Self.manifestURL
        )
        let styleAwakeningsURL = manifest.dataURL(
            for: "styleAwakenings",
            baseURL: Self.manifestURL
        )

        async let enemies: [EnemyDefinition]? = loadJSON(from: enemyURL)
        async let levels: [LevelDefinition]? = loadJSON(from: levelURL)
        async let characters: [PlayerCharacter]? = loadJSON(from: characterURL)
        async let rewards: [RunReward]? = loadJSON(from: rewardURL)
        async let events: [EventDefinition]? = loadJSON(from: eventURL)
        async let story: [StoryChapter]? = loadJSON(from: storyURL)
        async let themes: [ThemeDefinition]? = loadJSON(from: themeURL)
        async let stylePasses: [StylePassDefinition]? = loadJSON(
            from: stylePassURL
        )
        async let loadedUIConfigTask: UIConfig? = loadOptionalUIConfig(
            from: uiConfigURL
        )
        async let premiumStore: [PremiumStoreProduct]? =
            loadOptionalPremiumStore(from: premiumStoreURL)
        async let enemyAvatars: [EnemyAvatarDefinition]? =
            loadOptionalEnemyAvatars(from: enemyAvatarURL)
        async let loginCampaigns: [LoginCampaignDefinition]? =
            loadOptionalLoginCampaigns(from: loginCampaignURL)
        async let gifts: [GiftDefinition]? =
            loadOptionalGifts(from: giftURL)
        async let styleAwakenings: [StyleAwakeningDefinition]? =
            loadOptionalStyleAwakenings(from: styleAwakeningsURL)
        let remoteConfig: GameConfig? = await loadJSON(from: configURL)

        let loadedEnemies =
            await enemies
            ?? fallbackEnemyDefinitions
        let loadedLevels =
            await levels
            ?? loadBundledJSON("LevelDefinitions", fallback: [])
        let loadedCharacters =
            await characters
            ?? loadBundledJSON("CharacterDefinitions", fallback: [])
        let loadedRewards =
            await rewards
            ?? loadBundledJSON("RewardDefinitions", fallback: [])
        let loadedEvents =
            await events
            ?? loadBundledJSON("EventDefinitions", fallback: [])
        let loadedStory =
            await story
            ?? loadBundledJSON("StoryDefinitions", fallback: [])
        let loadedThemes =
            await themes
            ?? loadBundledJSON(
                "ThemeDefinition",
                fallback: ThemeDefinition.fallbackThemes
            )
        let loadedStylePasses =
            await stylePasses
            ?? loadBundledJSON("StylePassDefinitions", fallback: [])
        let loadedUIConfig = await loadedUIConfigTask ?? .fallback
        let loadedPremiumStore = await premiumStore ?? []
        let loadedEnemyAvatars =
            await enemyAvatars
            ?? EnemyAvatarDefinition.fallback
        let loadedLoginCampaigns =
            await loginCampaigns
            ?? LoginCampaignDefinition.fallback
        let loadedGifts = await gifts ?? GiftDefinition.fallback
        let loadedStyleAwakenings =
            await styleAwakenings
            ?? StyleAwakeningDefinition.fallback
        let loadedConfig =
            remoteConfig
            ?? loadBundledJSON("GameConfig", fallback: GameConfig.fallback)

        guard !loadedEnemies.isEmpty, !loadedLevels.isEmpty,
            !loadedCharacters.isEmpty, !loadedRewards.isEmpty,
            !loadedStory.isEmpty, !loadedThemes.isEmpty
        else {
            resetRemoteContent(status: "CONTENT FILES MISSING")
            return
        }

        enemyDefinitions = Dictionary(
            uniqueKeysWithValues: loadedEnemies.map { ($0.id, $0) }
        )
        levelDefinitions = loadedLevels.sorted {
            $0.requiredFight < $1.requiredFight
        }
        characterDefinitions = loadedCharacters
        rewardDefinitions = loadedRewards
        eventDefinitions = loadedEvents
        storyChapters = loadedStory.sorted {
            $0.requiredChapter < $1.requiredChapter
        }
        themeDefinitions = loadedThemes
        stylePassDefinitions = loadedStylePasses
        premiumStoreProducts = loadedPremiumStore
        enemyAvatarDefinitions =
            loadedEnemyAvatars.isEmpty
            ? EnemyAvatarDefinition.fallback : loadedEnemyAvatars
        loginCampaignDefinitions =
            loadedLoginCampaigns.isEmpty
            ? LoginCampaignDefinition.fallback : loadedLoginCampaigns
        giftDefinitions =
            loadedGifts.isEmpty ? GiftDefinition.fallback : loadedGifts
        styleAwakeningDefinitions =
            loadedStyleAwakenings.isEmpty
            ? StyleAwakeningDefinition.fallback : loadedStyleAwakenings
        uiConfig = loadedUIConfig
        gameConfig = loadedConfig
        isOnline = true
        statusMessage = "GAME CONTENT READY"
        finishLoading(status: "GAME CONTENT READY")
    }

    func assetURL(named name: String, fileExtension: String = "png") -> URL {
        if let url = assetURLs[name] {
            return url
        }

        if let assetsBaseURL {
            return assetsBaseURL.appendingPathComponent(
                "\(name).\(fileExtension)"
            )
        }

        return Self.manifestURL
    }

    func musicURL(named name: String, fileExtension: String) -> URL {
        if let url = musicURLs[name] {
            return url
        }

        if let musicBaseURL {
            return musicBaseURL.appendingPathComponent(
                "\(name).\(fileExtension)"
            )
        }

        return Self.manifestURL
    }

    func contentURL(_ value: String) -> URL? {
        resolvedURL(value)
    }

    func warmStartupMedia() async {
        await MainActor.run {
            beginLoading(totalItems: 4, status: "CACHING STARTUP MEDIA")
        }

        let startupAssetIds = Set(
            CharacterCatalog.shared.defaultCharacter.attackFrames
                + [CharacterCatalog.shared.defaultCharacter.idleAsset]
                + ["logo_vhs"]
        )

        let startupMusicURLs = MusicCatalog.shared.playlist(for: nil)
            .filter { $0.requiredUnlock == nil }
            .prefix(1)
            .compactMap { contentURL($0.url) }

        let urls =
            startupAssetIds.compactMap { assetURLs[$0] }
            + Array(startupMusicURLs)

        await warmURLs(urls)

        await MainActor.run {
            finishLoading(status: "STARTUP MEDIA READY")
        }
    }

    func warmAllRemoteMediaInBackground() {
        let urls =
            Array(assetURLs.values) + Array(musicURLs.values)
            + musicTracks.compactMap { contentURL($0.url) }

        Task.detached(priority: .background) { [weak self] in
            await self?.warmURLs(urls)
        }
    }

    private func warmURLs(_ urls: [URL]) async {
        let urls =
            urls
            .filter { warmedURLStrings.insert($0.absoluteString).inserted }

        await MainActor.run {
            totalItemCount = max(totalItemCount, loadedItemCount + urls.count)
            totalBytes = max(totalBytes, urls.count * 600_000)
        }

        await withTaskGroup(of: Void.self) { group in
            for url in urls.prefix(8) {
                group.addTask {
                    var request = URLRequest(url: url)
                    request.cachePolicy = .returnCacheDataElseLoad
                    if let (data, _) = try? await self.urlSession.data(
                        for: request
                    ) {
                        await MainActor.run {
                            self.downloadedBytes += data.count
                            self.advanceLoading(status: "CACHING MEDIA")
                        }
                    }
                }
            }
        }
    }

    private func loadJSON<T: Decodable>(from url: URL) async -> T? {
        do {
            var request = URLRequest(url: url)
            request.cachePolicy = .returnCacheDataElseLoad
            let (data, response) = try await urlSession.data(for: request)

            guard let http = response as? HTTPURLResponse else {
                return nil
            }

            guard (200..<300).contains(http.statusCode) else {
                return nil
            }

            let decoded = try JSONDecoder().decode(T.self, from: data)
            await MainActor.run {
                downloadedBytes += data.count
                advanceLoading(status: "LOADED \(url.lastPathComponent)")
            }
            return decoded
        } catch {
            return nil
        }
    }

    private func loadBundledJSON<T: Decodable>(
        _ resourceName: String,
        fallback: T
    ) -> T {
        guard
            let url = Bundle.main.url(
                forResource: resourceName,
                withExtension: "json"
            )
        else {
            return fallback
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return fallback
        }
    }

    private var fallbackEnemyDefinitions: [EnemyDefinition] {
        EnemyType.allCases.map { EnemyCatalog.shared.definition(for: $0) }
    }

    private func loadOptionalUIConfig(from url: URL?) async -> UIConfig? {
        guard let url else {
            return .fallback
        }

        return await loadJSON(from: url) ?? .fallback
    }

    private func loadOptionalPremiumStore(
        from url: URL?
    ) async -> [PremiumStoreProduct]? {
        guard let url else {
            return []
        }

        return await loadJSON(from: url) ?? []
    }

    private func loadOptionalEnemyAvatars(
        from url: URL?
    ) async -> [EnemyAvatarDefinition]? {
        guard let url else {
            return EnemyAvatarDefinition.fallback
        }

        let avatars: [EnemyAvatarDefinition]? = await loadJSON(from: url)
        return avatars?.isEmpty == false
            ? avatars : EnemyAvatarDefinition.fallback
    }

    private func loadOptionalLoginCampaigns(
        from url: URL?
    ) async -> [LoginCampaignDefinition]? {
        guard let url else {
            return LoginCampaignDefinition.fallback
        }

        let campaigns: [LoginCampaignDefinition]? = await loadJSON(from: url)
        return campaigns?.isEmpty == false
            ? campaigns : LoginCampaignDefinition.fallback
    }

    private func loadOptionalGifts(from url: URL?) async -> [GiftDefinition]? {
        guard let url else {
            return GiftDefinition.fallback
        }

        let gifts: [GiftDefinition]? = await loadJSON(from: url)
        return gifts?.isEmpty == false ? gifts : GiftDefinition.fallback
    }

    private func loadOptionalStyleAwakenings(
        from url: URL?
    ) async -> [StyleAwakeningDefinition]? {
        guard let url else {
            return StyleAwakeningDefinition.fallback
        }

        let awakenings: [StyleAwakeningDefinition]? = await loadJSON(from: url)
        return awakenings?.isEmpty == false
            ? awakenings : StyleAwakeningDefinition.fallback
    }

    private func resetRemoteContent(status: String) {
        enemyDefinitions = [:]
        levelDefinitions = []
        characterDefinitions = []
        rewardDefinitions = []
        eventDefinitions = []
        storyChapters = []
        musicTracks = []
        themeDefinitions = []
        stylePassDefinitions = []
        premiumStoreProducts = []
        enemyAvatarDefinitions = EnemyAvatarDefinition.fallback
        loginCampaignDefinitions = LoginCampaignDefinition.fallback
        giftDefinitions = GiftDefinition.fallback
        styleAwakeningDefinitions = StyleAwakeningDefinition.fallback
        uiConfig = .fallback
        gameConfig = .fallback
        assetsBaseURL = nil
        musicBaseURL = nil
        assetURLs = [:]
        musicURLs = [:]
        isOnline = false
        statusMessage = status
        loadingProgress = 0
        loadedItemCount = 0
        totalItemCount = 1
        downloadedBytes = 0
        totalBytes = 0
    }

    @MainActor
    private func beginLoading(totalItems: Int, status: String) {
        loadedItemCount = 0
        totalItemCount = max(1, totalItems)
        downloadedBytes = 0
        totalBytes = max(totalBytes, totalItems * 45_000)
        loadingProgress = 0
        statusMessage = status
    }

    @MainActor
    private func advanceLoading(status: String) {
        loadedItemCount = min(totalItemCount, loadedItemCount + 1)
        loadingProgress = min(
            0.98,
            Double(loadedItemCount) / Double(totalItemCount)
        )
        statusMessage = status
    }

    @MainActor
    private func finishLoading(status: String) {
        loadedItemCount = max(loadedItemCount, totalItemCount)
        loadingProgress = 1
        statusMessage = status
    }

    private func resolvedURL(_ value: String?) -> URL? {

        guard let value,
            !value.isEmpty
        else {
            return nil
        }

        return URL(
            string: value,
            relativeTo: Self.manifestURL
        )?.absoluteURL
    }

    private func mediaURLMap(
        from files: [RemoteManifestMediaFile],
        baseURL: URL?
    ) -> [String: URL] {

        Dictionary(
            uniqueKeysWithValues: files.compactMap { file in

                let url: URL?

                if let baseURL {

                    url =
                        URL(
                            string: file.url,
                            relativeTo: baseURL
                        )?.absoluteURL

                } else {

                    url = resolvedURL(file.url)
                }

                guard let url else {
                    return nil
                }

                return (file.id, url)
            }
        )
    }
}

struct RemoteManifest: Codable {
    let version: Int
    let assetsBaseURL: String?
    let musicBaseURL: String?
    let data: [RemoteManifestDataFile]
    let assets: [RemoteManifestMediaFile]
    let music: [RemoteManifestMediaFile]

    enum CodingKeys: String, CodingKey {
        case version
        case assetsBaseURL
        case musicBaseURL
        case data
        case assets
        case music
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decodeIfPresent(Int.self, forKey: .version) ?? 1
        assetsBaseURL = try container.decodeIfPresent(
            String.self,
            forKey: .assetsBaseURL
        )
        musicBaseURL = try container.decodeIfPresent(
            String.self,
            forKey: .musicBaseURL
        )
        data = try container.decode(
            [RemoteManifestDataFile].self,
            forKey: .data
        )
        assets =
            try container.decodeIfPresent(
                [RemoteManifestMediaFile].self,
                forKey: .assets
            ) ?? []
        music =
            try container.decodeIfPresent(
                [RemoteManifestMediaFile].self,
                forKey: .music
            ) ?? []
    }

    func dataURL(for id: String, baseURL: URL) -> URL? {
        guard let file = data.first(where: { $0.id == id }) else { return nil }
        return URL(string: file.url, relativeTo: baseURL)?.absoluteURL
    }
}

struct RemoteManifestDataFile: Codable, Equatable {
    let id: String
    let url: String
}

struct RemoteManifestMediaFile: Codable, Equatable {
    let id: String
    let url: String
    let title: String?
    let mode: String?
    let requiredUnlock: String?
}
