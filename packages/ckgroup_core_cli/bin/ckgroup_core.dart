import 'dart:io';

import 'package:args/args.dart';
import 'package:ckgroup_core_cli/ckgroup_core_cli.dart';

const String _version = '0.1.0';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print the tool version.',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show usage information.',
    )
    ..addCommand(AddCommand.name, AddCommand.buildParser());

  ArgResults results;
  try {
    results = parser.parse(arguments);
  } on FormatException catch (e) {
    _printUsage(parser, error: e.message);
    exit(64); // EX_USAGE
  }

  if (results['version'] as bool) {
    print('ckgroup-core v$_version');
    exit(0);
  }

  if (results['help'] as bool || results.command == null) {
    _printUsage(parser);
    exit(0);
  }

  final command = results.command!;

  switch (command.name) {
    case AddCommand.name:
      final code = AddCommand.run(command);
      exit(code);
    default:
      _printUsage(parser, error: 'Unknown command: ${command.name}');
      exit(64);
  }
}

void _printUsage(ArgParser parser, {String? error}) {
  if (error != null) {
    stderr.writeln('Error: $error\n');
  }
  print('CKGroup Core CLI — adaptive UI platform tooling\n');
  print('Usage: ckgroup-core <command> [options]\n');
  print('Commands:');
  print('  add    ${AddCommand.description}\n');
  print('Global options:');
  print(parser.usage);
  print('\nRun "ckgroup-core add --help" for add-command options.');
}
