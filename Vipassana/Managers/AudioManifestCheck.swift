import Foundation

enum AudioManifestCheckError: Error, Equatable {
    case noResourceNames
    case missingResources([String])
    case missingFromCopyBundleResources([String])
}

enum AudioManifestCheck {
    static func resourceNames(inFactorySource source: String) -> [String] {
        let pattern = #"path\(forResource:\s*"([^"]+)",\s*ofType:\s*"m4a"\)"#
        return uniqueMatches(in: source, pattern: pattern)
    }

    static func missingAudioFiles(names: [String], audioDirectory: URL, fileManager: FileManager = .default) -> [String] {
        names.filter { name in
            !isRegularFile(name: name, audioDirectory: audioDirectory, fileManager: fileManager)
        }
    }

    static func copyBundleResourceNames(inProjectSource source: String) -> [String] {
        let pattern = #"/\* ([A-Za-z0-9_]+)\.m4a in Resources \*/,"#
        return uniqueMatches(in: source, pattern: pattern)
    }

    static func validate(factorySource: String, audioDirectory: URL, projectSource: String? = nil, fileManager: FileManager = .default) throws {
        let names = resourceNames(inFactorySource: factorySource)
        if names.isEmpty {
            throw AudioManifestCheckError.noResourceNames
        }
        if let projectSource = projectSource {
            let listed = Set(copyBundleResourceNames(inProjectSource: projectSource))
            let missingFromProject = names.filter { !listed.contains($0) }
            if !missingFromProject.isEmpty {
                throw AudioManifestCheckError.missingFromCopyBundleResources(missingFromProject)
            }
        }
        let missing = missingAudioFiles(names: names, audioDirectory: audioDirectory, fileManager: fileManager)
        if !missing.isEmpty {
            throw AudioManifestCheckError.missingResources(missing)
        }
    }

    private static func uniqueMatches(in source: String, pattern: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }
        let range = NSRange(source.startIndex..<source.endIndex, in: source)
        var names: [String] = []
        var seen = Set<String>()
        regex.enumerateMatches(in: source, options: [], range: range) { match, _, _ in
            guard let match = match, match.numberOfRanges > 1,
                  let nameRange = Range(match.range(at: 1), in: source) else {
                return
            }
            let name = String(source[nameRange])
            if seen.insert(name).inserted {
                names.append(name)
            }
        }
        return names
    }

    private static func isRegularFile(name: String, audioDirectory: URL, fileManager: FileManager) -> Bool {
        let url = audioDirectory.appendingPathComponent(name).appendingPathExtension("m4a")
        var isDirectory: ObjCBool = false
        let exists = fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return exists && !isDirectory.boolValue
    }
}
