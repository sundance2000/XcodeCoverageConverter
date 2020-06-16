import ArgumentParser
import Core

struct Xcc: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to convert xccov outputs into continuous integration friendly formats",
        version: "0.1",
        subcommands: [Generate.self],
        defaultSubcommand: Generate.self)

    init() { }
}

struct Generate: ParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Generates a converted file from xccov results")

    @Argument(help: "The full path to the json file to convert")
    private var jsonFile: String

    @Argument(help: "The path of the output file")
    private var outputPath: String

    @Argument(help: "The output formats")
    private var outputFormats: [Xccov.Commands.Generate.Output]

    @Option(help: "The targets to exclude")
    private var excludeTargets: [String]

    @Option(help: "The packages to exclude")
    private var excludePackages: [String]

    @Flag(name: .long, help: "Show extra logging for debugging purposes")
    private var verbose: Bool

    func run() throws {
        let result = Xccov.Commands.Generate.execute(jsonFile: jsonFile,
                                                     outputPath: outputPath,
                                                     outputs: outputFormats,
                                                     excludeTargets: excludeTargets,
                                                     excludePackages: excludePackages,
                                                     verbose: verbose)

        switch result {
        case .success(_):
            throw CleanExit.message("All good")
        case .failure(_):
            throw ExitCode.failure
        }
    }


}

Xcc.main()
