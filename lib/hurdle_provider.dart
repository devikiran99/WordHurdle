import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:english_words/english_words.dart' as words;
import 'package:word_hurdle/wordle.dart';

class HurdleProvider extends ChangeNotifier {
  final random = Random.secure();
  List<String>  totalWords = [];
  List<String> rowInputs = [];
  List<String> excludeLetters = [];
  List<Wordle> hurdleBoard = [];
  String targetWord = "";
  final lettersPerRow = 5;
  int index = 0;
  bool wins = false;
  final totalAttempts = 6;
  int attempts = 0;


  bool get isAValidWord => totalWords.contains(rowInputs.join('').toLowerCase());
  bool get shouldCheckForAnswer => rowInputs.length == lettersPerRow;

  bool get noAttemptsLeft => totalAttempts == attempts;

  void init(){
    totalWords = words.all.where((element) => element.length == 5).toList();
    generateBoard();
    generateRandomWord();
  }

  void generateBoard(){
    hurdleBoard = List.generate(30, (index) => Wordle(letter: ""));
  }

  void generateRandomWord(){
    targetWord = totalWords[random.nextInt(totalWords.length)].toUpperCase();
  }

  void inputLetter(String letter) {
    if(rowInputs.length < 5){
      rowInputs.add(letter);
      hurdleBoard[index] = Wordle(letter: letter);
      index++;
      notifyListeners();
    }
  }

  void deleteInputLetters(){
    if(rowInputs.isNotEmpty){
      hurdleBoard[index - 1] = Wordle(letter: "");
      index--;
      rowInputs.removeAt(rowInputs.length - 1);
    }
    notifyListeners();
  }


  void checkAnswer(){
    final input = rowInputs.join("");
    if(targetWord == input){
      wins = true;
    }else{
      _markLetterOnBoard();
      if(attempts < totalAttempts){
        _goToNextRow();
      }
    }
  }

  void _markLetterOnBoard() {
    for(int i = 0; i< hurdleBoard.length; i++){
      if(hurdleBoard[i].letter.isNotEmpty && targetWord.contains(hurdleBoard[i].letter)){
        hurdleBoard[i].existsInTarget = true;
      }else if(hurdleBoard[i].letter.isNotEmpty && !targetWord.contains(hurdleBoard[i].letter)){
        hurdleBoard[i].doesNotExistsInTarget = true;
        excludeLetters.add(hurdleBoard[i].letter);
      }
    }
    notifyListeners();
  }

  void _goToNextRow() {
    attempts++;
    rowInputs.clear();
  }

  void reset(){
    index = 0;
    rowInputs.clear();
    hurdleBoard.clear();
    excludeLetters.clear();
    attempts = 0;
    wins = false;
    targetWord = "";
    generateBoard();
    generateRandomWord();
    notifyListeners();
  }
}