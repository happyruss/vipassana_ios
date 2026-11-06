import XCTest
@testable import Vipassana

class AudioManifestCheckTests: XCTestCase {

    private var audioDirectory: URL!

    override func setUp() {
        super.setUp()
        audioDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try? FileManager.default.createDirectory(at: audioDirectory, withIntermediateDirectories: true)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: audioDirectory)
        super.tearDown()
    }

    func testMissingNameFails() {
        let source = factorySource(names: ["IntroBell"])
        XCTAssertThrowsError(try AudioManifestCheck.validate(factorySource: source, audioDirectory: audioDirectory)) { error in
            XCTAssertEqual(error as? AudioManifestCheckError, .missingResources(["IntroBell"]))
        }
    }

    func testPresentNamePasses() throws {
        try writeAudio(named: "IntroBell")
        XCTAssertNoThrow(try AudioManifestCheck.validate(factorySource: factorySource(names: ["IntroBell"]), audioDirectory: audioDirectory))
    }

    func testDirectoryWithAudioNameStillFails() throws {
        let url = audioDirectory.appendingPathComponent("IntroBell.m4a", isDirectory: true)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        XCTAssertThrowsError(try AudioManifestCheck.validate(factorySource: factorySource(names: ["IntroBell"]), audioDirectory: audioDirectory)) { error in
            XCTAssertEqual(error as? AudioManifestCheckError, .missingResources(["IntroBell"]))
        }
    }

    func testNoResourceNamesFailsClosed() {
        XCTAssertThrowsError(try AudioManifestCheck.validate(factorySource: "let unused = 1", audioDirectory: audioDirectory)) { error in
            XCTAssertEqual(error as? AudioManifestCheckError, .noResourceNames)
        }
    }

    func testFileOnDiskStillFailsWhenMissingFromCopyBundleResources() throws {
        try writeAudio(named: "IntroBell")
        let project = "464A063E1FF6EFDB008D8AB4 /* ClosingBell.m4a in Resources */,"
        XCTAssertThrowsError(try AudioManifestCheck.validate(factorySource: factorySource(names: ["IntroBell"]), audioDirectory: audioDirectory, projectSource: project)) { error in
            XCTAssertEqual(error as? AudioManifestCheckError, .missingFromCopyBundleResources(["IntroBell"]))
        }
    }

    func testPresentFilePassesWhenListedInCopyBundleResources() throws {
        try writeAudio(named: "IntroBell")
        let project = "464A063E1FF6EFDB008D8AB4 /* IntroBell.m4a in Resources */,"
        XCTAssertNoThrow(try AudioManifestCheck.validate(factorySource: factorySource(names: ["IntroBell"]), audioDirectory: audioDirectory, projectSource: project))
    }

    func testDuplicateNamesAreReportedOnce() {
        let source = factorySource(names: ["IntroBell", "IntroBell"])
        XCTAssertEqual(AudioManifestCheck.resourceNames(inFactorySource: source), ["IntroBell"])
        XCTAssertThrowsError(try AudioManifestCheck.validate(factorySource: source, audioDirectory: audioDirectory)) { error in
            XCTAssertEqual(error as? AudioManifestCheckError, .missingResources(["IntroBell"]))
        }
    }

    private func factorySource(names: [String]) -> String {
        names.map { name in
            "Bundle.main.path(forResource: \"\(name)\", ofType: \"m4a\")!"
        }.joined(separator: "\n")
    }

    private func writeAudio(named name: String) throws {
        let url = audioDirectory.appendingPathComponent(name).appendingPathExtension("m4a")
        try Data([0]).write(to: url)
    }
}
