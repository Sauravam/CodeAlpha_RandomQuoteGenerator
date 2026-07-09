import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const QuoteApp());
}

class QuoteApp extends StatelessWidget {
  const QuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Quote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.black,
        useMaterial3: true,
        fontFamily: 'Inter', // Default to a clean sans-serif like behavior
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.white,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String quote = "";
  String author = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/quotes/random'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          quote = data['quote'];
          author = data['author'];
          isLoading = false;
        });
      } else {
        setState(() {
          quote = "Could not fetch a quote. Please try again.";
          author = "";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        quote = "An error occurred. Check your internet connection.";
        author = "";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final authorColor = isDark ? Colors.white54 : Colors.black54;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.05),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: isLoading && quote.isEmpty
                    ? const Center(
                        key: ValueKey('loading'),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Column(
                        key: ValueKey<String>(quote),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '"$quote"',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                  color: textColor,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            author.isNotEmpty ? "- $author" : "",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: authorColor,
                                  fontWeight: FontWeight.w400,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
              const Spacer(),
              SizedBox(
                height: 56,
                child: FilledButton(
                  onPressed: isLoading ? null : fetchQuote,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                  ),
                  child: isLoading && quote.isNotEmpty
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDark ? Colors.black : Colors.white,
                          ),
                        )
                      : const Text(
                          'New Quote',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
