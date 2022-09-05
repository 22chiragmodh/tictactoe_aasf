import 'package:flutter/material.dart';
import '../colortheme.dart';
import '../Models/game_model.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PlayGame extends StatefulWidget {
  const PlayGame({Key? key}) : super(key: key);

  @override
  State<PlayGame> createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  String turnvar = 'X';
  String turnds = 'Your';
  int turn = 0;
  String result = '';
  bool gameover = false;
  int totalgame = 0;
  int wingame = 0;
  int lossgame = 0;
// UserCredential user =await FirebaseAuth.instance.currentUser!();
  List<int> scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
  Game game = Game();

  @override
  void initState() {
    super.initState();

    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardwidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.pink, // Navigation bar
            statusBarColor: Colors.indigo, // Status bar
          ),
          title: const Text("Let's Play TicTacToe Game",
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: [
            DropdownButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                items: [
                  DropdownMenuItem(
                      value: 'logout',
                      child: Row(children: const [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ])),
                 
                ],
                onChanged: (itemindetifier) {
                  if (itemindetifier == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                
                }),
          ],
        ),
        backgroundColor: Colortheme.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("It's $turnds turn".toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 30)),
            const SizedBox(height: 20),
            SizedBox(
              width: boardwidth,
              height: boardwidth,
              child: GridView.count(
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                crossAxisCount: Game.boardlength ~/ 3,
                children: List.generate(Game.boardlength, (index) {
                  return InkWell(
                    onTap: gameover
                        ? null
                        : () {
                            if (game.board![index] == '') {
                              setState(() {
                                game.board![index] = turnvar;
                                turn++;
                                gameover = game.Winnercheck(
                                    turnvar, index, scoreboard, 3);

                                if (gameover) {
                                  totalgame++;

                                  if (turnvar == 'X') {
                                    result = 'You win the game';
                                    wingame++;
                                    double winrate =
                                        wingame * 100 / totalgame * 1.0;

                                    FirebaseFirestore.instance
                                        .collection('GamePlayer')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      "total_pgame": "$totalgame",
                                      "wingame": "$wingame",
                                      "lossgame": "$lossgame",
                                      "winrate": "$winrate %",
                                    });
                                  } else {
                                    result = 'You loss the game!';

                                    lossgame++;
                                    double winrate =
                                        wingame * 100 / totalgame * 1.0;

                                    FirebaseFirestore.instance
                                        .collection('GamePlayer')
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .update({
                                      "total_pgame": "$totalgame",
                                      "wingame": "$wingame",
                                      "lossgame": "$lossgame",
                                      "winrate": "$winrate %",
                                    });
                                  }
                                }

                                if (turnvar == 'X') {
                                  turnvar = 'O';
                                  turnds = 'Computer';
                                } else {
                                  turnvar = 'X';
                                  turnds = 'Your';
                                }
                              });
                            }
                          },
                    child: Container(
                      width: Game.blocsize,
                      height: Game.blocsize,
                      decoration: BoxDecoration(
                        color: Colortheme.secondaryColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          game.board![index],
                          style: TextStyle(
                              color: game.board![index] == 'X'
                                  ? Colors.blue
                                  : Colors.pink,
                              fontSize: 64),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              result,
              style: TextStyle(
                  color:
                      result == "You win the game" ? Colors.green : Colors.red,
                  fontSize: 30),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  game.board = Game.initGameBoard();
                  turnvar = 'X';
                  turnds = 'Your';
                  gameover = false;

                  turn = 0;
                  result = "";
                  scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                });
              },
              icon: const Icon(Icons.replay),
              label: const Text('Reset Game'),
              style: ButtonStyle(),
            )
          ],
        ));
  }
}
