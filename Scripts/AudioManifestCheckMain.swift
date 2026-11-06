import Foundation

@main
struct AudioManifestCheckMain {
    static func main() {
        var factoryPath: String?
        var audioDirectoryPath: String?
        var projectPath: String?
        var index = 1
        let arguments = CommandLine.arguments
        while index < arguments.count {
            let argument = arguments[index]
            if argument == "--factory", index + 1 < arguments.count {
                factoryPath = arguments[index + 1]
                index += 2
            } else if argument == "--audio-dir", index + 1 < arguments.count {
                audioDirectoryPath = arguments[index + 1]
                index += 2
            } else if argument == "--project", index + 1 < arguments.count {
                projectPath = arguments[index + 1]
                index += 2
            } else {
                fputs("error: unknown argument \(argument)\n", stderr)
                exit(2)
            }
        }

        guard let factoryPath = factoryPath, let audioDirectoryPath = audioDirectoryPath else {
            fputs("error: --factory and --audio-dir are required\n", stderr)
            exit(2)
        }

        let source: String
        do {
            source = try String(contentsOfFile: factoryPath, encoding: .utf8)
        } catch {
            fputs("error: unable to read \(factoryPath)\n", stderr)
            exit(1)
        }

        let projectSource: String?
        if let projectPath = projectPath {
            do {
                projectSource = try String(contentsOfFile: projectPath, encoding: .utf8)
            } catch {
                fputs("error: unable to read \(projectPath)\n", stderr)
                exit(1)
            }
        } else {
            projectSource = nil
        }

        do {
            try AudioManifestCheck.validate(
                factorySource: source,
                audioDirectory: URL(fileURLWithPath: audioDirectoryPath),
                projectSource: projectSource
            )
        } catch AudioManifestCheckError.noResourceNames {
            fputs("error: no Bundle audio names found in \(factoryPath)\n", stderr)
            exit(1)
        } catch AudioManifestCheckError.missingResources(let names) {
            for name in names {
                fputs("error: missing bundled audio \(name).m4a\n", stderr)
            }
            exit(1)
        } catch AudioManifestCheckError.missingFromCopyBundleResources(let names) {
            for name in names {
                fputs("error: audio not in Copy Bundle Resources \(name).m4a\n", stderr)
            }
            exit(1)
        } catch {
            fputs("error: \(error)\n", stderr)
            exit(1)
        }
    }
}
