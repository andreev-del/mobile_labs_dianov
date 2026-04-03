import 'package:command_runner/command_runner.dart';

const version = '0.0.1';

void main(List<String> arguments) {
  final commandRunner = CommandRunner(
    // Красивая печать с задержкой
    onOutput: (String output) async {
      await write(output);
    },
    onError: (Object error) {
      if (error is Error) {
        throw error;
      }
      if (error is Exception) {
        print(error);
      }
    },
  )..addCommand(HelpCommand());

  commandRunner.run(arguments);
}