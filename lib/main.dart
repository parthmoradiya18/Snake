import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class box extends StatelessWidget {
  const box({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

class Snake extends StatelessWidget {
  const Snake({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

class Food extends StatelessWidget {
  const Food({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        child: Icon(Icons.fastfood),
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snakeDiraction { left, right, up, down }

class _HomePageState extends State<HomePage> {
  int row_side = 10;

  int total_Squers = 140;

  List<int> snake_ = [0, 1, 2];

  int f_s = 65;

  var Diraction = snakeDiraction.right;

  int Score = 0;

  bool gameHas = false;

  void Game_play() {
    gameHas = true;
    Timer.periodic(
      const Duration(milliseconds: 200),
          (timer) {
        setState(() {
          Move_Snake();

          if (game_Over_()) {
            timer.cancel();
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: OutlineInputBorder(
                      borderSide:
                      BorderSide(width: 5, color: Colors.red.shade900)),
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Game Over !',
                    style: TextStyle(
                        letterSpacing: 0.7,
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    'My score board : ' + Score.toString(),
                    style: const TextStyle(
                      letterSpacing: 0.2,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  actions: [
                    MaterialButton(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      onPressed: () {
                        Navigator.pop(context);
                        Restart();
                        newGame();
                      },
                      child: const Text(
                        'Play Again',
                        style: TextStyle(
                          letterSpacing: 0.4,
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.lightGreen.shade900,
                    ),
                  ],
                );
              },
            );
          }
        });
      },
    );
  }

  void Restart() {}

  void newGame() {
    setState(() {
      snake_ = [0, 1, 2];
      f_s = Random().nextInt(total_Squers);
      Diraction = snakeDiraction.right;
      Score = 0;
      gameHas = false;
    });
  }

  void Food_snake() {
    Score++;
    while (snake_.contains(f_s)) {
      f_s = Random().nextInt(total_Squers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Colors.orangeAccent.shade200,
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  'your score board.',
                  style: TextStyle(
                    letterSpacing: 0.5,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  Score.toString(),
                  style: const TextStyle(
                      letterSpacing: 0.2,
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          preferredSize: Size(0, 70)),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 6,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 && Diraction != snakeDiraction.up) {
                  Diraction = snakeDiraction.down;
                } else if (details.delta.dy < 0 &&
                    Diraction != snakeDiraction.down) {
                  Diraction = snakeDiraction.up;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 && Diraction != snakeDiraction.left) {
                  Diraction = snakeDiraction.right;
                } else if (details.delta.dx < 0 &&
                    Diraction != snakeDiraction.right) {
                  Diraction = snakeDiraction.left;
                }
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: row_side,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: total_Squers,
                itemBuilder: (context, index) {
                  if (snake_.contains(index)) {
                    return const Snake();
                  } else if (f_s == index) {
                    return const Food();
                  } else {
                    return const box();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: MaterialButton(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: const Text(
                    'Start Game',
                    style: TextStyle(
                      wordSpacing: 0.4,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  color: gameHas
                      ? Colors.lightGreen.shade900
                      : Colors.orangeAccent.shade200,
                  onPressed: gameHas ? () {} : Game_play,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void Move_Snake() {
    switch (Diraction) {
      case snakeDiraction.right:
        {
          if (snake_.last % row_side == 9) {
            snake_.add(snake_.last + 1 - row_side);
          } else {
            snake_.add(snake_.last + 1);
          }
        }

        break;
      case snakeDiraction.left:
        {
          if (snake_.last % row_side == 0) {
            snake_.add(snake_.last - 1 + row_side);
          } else {
            snake_.add(snake_.last - 1);
          }
        }

        break;
      case snakeDiraction.up:
        {
          if (snake_.last < row_side) {
            snake_.add(snake_.last - row_side + total_Squers);
          } else {
            snake_.add(snake_.last - row_side);
          }
        }

        break;
      case snakeDiraction.down:
        {
          if (snake_.last + row_side > total_Squers) {
            snake_.add(snake_.last + row_side - total_Squers);
          } else {
            snake_.add(snake_.last + row_side);
          }
        }

        break;

      default:
    }
    if (snake_.last == f_s) {
      Food_snake();
    } else {
      snake_.removeAt(0);
    }
  }

  bool game_Over_() {
    List<int> bodySnake = snake_.sublist(0, snake_.length - 1);

    if (bodySnake.contains(snake_.last)) {
      return true;
    }
    return false;
  }
}
