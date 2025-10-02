import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_hurdle/wordle_view.dart';

import 'helper_functions.dart';
import 'hurdle_provider.dart';
import 'keyboard_view.dart';

class WordHurdlePage extends StatefulWidget {
  const WordHurdlePage({super.key});

  @override
  State<WordHurdlePage> createState() => _WordHurdlePageState();
}

class _WordHurdlePageState extends State<WordHurdlePage> {
  @override
  void didChangeDependencies() {
    Provider.of<HurdleProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Word Hurdle")),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.70,
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) =>
                      GridView.builder(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                        ),
                        itemCount: provider.hurdleBoard.length,
                        itemBuilder: (context, index) {
                          final wordle = provider.hurdleBoard[index];
                          return WordleView(wordle: wordle);
                        },
                      ),
                ),
              ),
            ),

            Consumer<HurdleProvider>(
              builder: (context, provider, child) =>
                  KeyboardView(
                    excludedLetters: provider.excludeLetters,
                    onPressed: (value) {
                      provider.inputLetter(value);
                    },
                  ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<HurdleProvider>(
                builder: (context, provider, child) =>
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            provider.deleteInputLetters();
                          },
                          child: Text("Delete"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (!provider.isAValidWord) {
                              showMessage(
                                context: context,
                                message: "Not a word in my dictionary",
                              )
                              ;
                              return;
                            }

                            if (provider.shouldCheckForAnswer) {
                              provider.checkAnswer();
                            }

                            if (provider.wins) {
                              showResult(
                                context: context,
                                title: "You win !!!",
                                body: "The word was ${provider.targetWord}",
                                onPlayAgain: () {
                                  Navigator.pop(context);
                                  provider.reset();
                                },
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                              );
                            } else if (provider.noAttemptsLeft) {
                              showResult(context: context,
                                  title: "You lost!!",
                                  body: "The word was ${provider.targetWord}",
                                  onPlayAgain: () {
                                    Navigator.pop(context);
                                    provider.reset();
                                  },
                                  onCancel: () {
                                    Navigator.pop(context);
                                  }
                              );
                            }
                          },
                          child: Text("Submit"),
                        ),
                      ],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
