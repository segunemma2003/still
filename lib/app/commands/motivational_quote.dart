import 'package:nylo_framework/metro/ny_cli.dart';

void main(arguments) => _MotivationalQuoteCommand(arguments).run();

/// Motivational Quote Command
///
/// Usage:
///   [From Terminal] dart run nylo_framework:main motivational:quote
///   [With Metro]    metro motivational:quote
class _MotivationalQuoteCommand extends NyCustomCommand {
  _MotivationalQuoteCommand(super.arguments);

  @override
  CommandBuilder builder(CommandBuilder command) => command;

  @override
  Future<void> handle(CommandResult result) async {
    // prompt for input
    final responseName = prompt("Hello, what's your name?");
    if (responseName.isEmpty) {
      error('Please provide a valid name.');
      return;
    }

    // confirmation prompt
    final response = confirm('$responseName, would you like to get a motivational quote?');
    if (response == false) {
      print('No problem, have a great day!');
      return;
    }

    // show a spinner while fetching the quote
    await withSpinner(
      task: () async {
        final List<dynamic>? data = await api((request) => request.get('https://zenquotes.io/api/today'));

        if (data == null || data.isEmpty) {
          error('\nNo data found');
          return;
        }

        print("\n");

        printQuote(
          quote: data[0]['q'],
          author: data[0]['a'],
        );

        print("\n");
      },
      message: 'Fetching motivational quote...',
      successMessage: 'Quote fetched successfully!',
      errorMessage: 'Failed to fetch quote.',
    );
  }
}


/// Example extension to add a printQuote method to NyCustomCommand
extension QuoteFormatter on NyCustomCommand {
  /// Prints a beautifully formatted quote in the console
  void printQuote({
    required String quote,
    required String author,
    String borderColor = '\x1B[36m', // Cyan
    String quoteColor = '\x1B[33m',   // Yellow
    String authorColor = '\x1B[35m',  // Magenta
    int maxWidth = 60,
  }) {
    // Reset code
    final reset = '\x1B[0m';

    // Format the quote by wrapping text to fit within maxWidth
    final wrappedQuote = _wrapText(quote, maxWidth - 4); // -4 for padding

    // Calculate width based on the longest line in the wrapped quote
    int width = 0;
    for (final line in wrappedQuote) {
      if (line.length > width) width = line.length;
    }

    // Add buffer for pretty formatting
    width += 4; // 2 spaces on each side

    // Prepare the author text
    final authorText = '— $author '; // Note the space after author name

    // Ensure width is at least as wide as the author text plus padding
    if (width < authorText.length + 2) {
      width = authorText.length + 2;
    }

    // Top border
    final topBorder = '$borderColor╭${'─' * (width)}╮$reset';
    print(topBorder);

    // Empty line
    final emptyLine = '$borderColor│${' ' * width}│$reset';
    print(emptyLine);

    // Quote content with rainbow effect if requested
    for (final line in wrappedQuote) {
      // Ensure exact padding to maintain alignment
      final paddingRight = width - line.length - 2;
      final paddedLine = ' $line${' ' * paddingRight} ';

      print('$borderColor│$quoteColor$paddedLine$reset$borderColor│$reset');
    }

    // Empty line
    print(emptyLine);

    // Author line
    final authorPadding = width - authorText.length;
    final authorLine = '$borderColor│${' ' * authorPadding}$authorColor$authorText$reset$borderColor│$reset';
    print(authorLine);

    // Bottom border
    final bottomBorder = '$borderColor╰${'─' * (width)}╯$reset';
    print(bottomBorder);
  }

  /// Wrap text to fit within maxWidth
  List<String> _wrapText(String text, int maxWidth) {
    final words = text.split(' ');
    final result = <String>[];
    String currentLine = '';

    for (final word in words) {
      if (currentLine.isEmpty) {
        currentLine = word;
      } else if (currentLine.length + word.length + 1 <= maxWidth) {
        currentLine += ' $word';
      } else {
        result.add(currentLine);
        currentLine = word;
      }
    }

    if (currentLine.isNotEmpty) {
      result.add(currentLine);
    }

    return result;
  }
}