import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe/utilities/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Game Utilities/GameButton.dart';
import '../utilities/CustomDialog.dart';

class SinglePlayerTicTacToe extends StatefulWidget {
  const SinglePlayerTicTacToe({super.key});

  @override
  State<SinglePlayerTicTacToe> createState() => _SinglePlayerTicTacToeState();
}

class _SinglePlayerTicTacToeState extends State<SinglePlayerTicTacToe> {
  late List<GameButton> buttonsList;
  var player1;
  var player2;
  var activePlayer;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonsList = initMultiPlayerGame();
  }

  List<GameButton> initMultiPlayerGame() {
    player1 = [];
    player2 = [];
    activePlayer = 1;

    var gameButtons = <GameButton>[
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];
    return gameButtons;
  }

  Future<void> winner1Win() async {}

  Future<int> checkWinner() async {
    var winner = -1;
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }

    // row 2
    if (player1.contains(4) && player1.contains(5) && player1.contains(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contains(6)) {
      winner = 2;
    }

    // row 3
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }

    // col 1
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }

    // col 2
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }

    // col 3
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }

    //diagonal
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }

    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }

    if (winner != -1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
      var user = db.collection('users').doc(uid);
      user.get().then((value) {
        int win = value.data()?['win'];
        int loss = value.data()?['loss'];
        if (winner == 1) {
          user.update({'win': win + 1});
          showDialog(
              context: context,
              builder: (_) {
                return CustomDialog("You Won",
                    "Press the reset button to start again.", resetGame);
              });
        } else if (winner == 2) {
          user.update({'loss': loss + 1});
          showDialog(
              context: context,
              builder: (_) {
                return CustomDialog("You Loss",
                    "Press the reset button to start again.", resetGame);
              });
        }
      });
    }

    return winner;
  }

  Future<void> playGame(GameButton gameButton) async {
    // setState(() {
    if (activePlayer == 1) {
      gameButton.text = "X";
      activePlayer = 2;
      player1.add(gameButton.id);
    } else {
      gameButton.text = "0";
      activePlayer = 1;
      player2.add(gameButton.id);
    }
    gameButton.enabled = false;
    int winner = await checkWinner();
    if (winner == -1) {
      if (buttonsList.every((p) => p.text != "")) {
        showDialog(
            context: context,
            builder: (_) {
              return CustomDialog("Game Tied",
                  "Press the reset button to start again.", resetGame);
            });
      } else {
        activePlayer == 2 ? autoPlay() : null;
      }
    }
    // });
    setState(() {});
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = initMultiPlayerGame();
    });
  }

  void autoPlay() {
    var emptyCells = [];
    var list = List.generate(9, (index) => index + 1);
    for (var cellId in list) {
      if (!(player1.contains(cellId) || player2.contains(cellId))) {
        emptyCells.add(cellId);
      }
    }

    var rand = new Random();
    var randIndex = rand.nextInt(emptyCells.length - 1);
    var cellId = emptyCells[randIndex];
    int i = buttonsList.indexWhere((element) => element.id == cellId);
    playGame(buttonsList[i]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toe"),
      ),
      body: Container(
        color: bgColor(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Player 1 Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Player 1 :",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                    Text(
                      "X",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),

                // Player 2 Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Computer :",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                    Text(
                      "0",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Row 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(button: buttonsList[0], playGame: playGame),
                    CustomButton(button: buttonsList[1], playGame: playGame),
                    CustomButton(button: buttonsList[2], playGame: playGame),
                  ],
                ),
                SizedBox(height: 20),

                // Row 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(button: buttonsList[3], playGame: playGame),
                    CustomButton(button: buttonsList[4], playGame: playGame),
                    CustomButton(button: buttonsList[5], playGame: playGame),
                  ],
                ),
                SizedBox(height: 20),

                // Row 3
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(button: buttonsList[6], playGame: playGame),
                    CustomButton(button: buttonsList[7], playGame: playGame),
                    CustomButton(button: buttonsList[8], playGame: playGame),
                  ],
                ),
                SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/mainMenu');
                            },
                            child: Text("Main Menu")))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  late GameButton button;
  final Function(GameButton) playGame;
  double height;
  double width;

  double radius;

  CustomButton(
      {super.key,
      required this.button,
      required this.playGame,
      this.height = 100,
      this.width = 100,
      this.radius = 50});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: button.enabled ? () => this.playGame(this.button) : null,
      child: Container(
        alignment: Alignment.center,
        height: 100,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).primaryColor),
        child: Text(
          button.text,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
}
