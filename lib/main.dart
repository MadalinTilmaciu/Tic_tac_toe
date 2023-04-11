import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeGame());
}

class TicTacToeGame extends StatelessWidget {
  const TicTacToeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tic Tac Toe',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.yellow,
          centerTitle: true,
        ),
        body: const Center(child: GameBoard()),
      ),
    );
  }
}

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  List<List<String>> _board =
      List<List<String>>.generate(3, (_) => List<String>.filled(3, ''));
  bool _playerTurn = true; // true for 'X', false for 'O'

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: _board
            .asMap()
            .entries
            .map(
              (MapEntry<int, List<String>> e) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: e.value
                    .asMap()
                    .entries
                    .map(
                      (MapEntry<int, String> e2) => GestureDetector(
                        onTap: () => _onTileTap(e.key, e2.key),
                        child: AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 400,
                          ),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            color: _getColorForTile(
                              e.key,
                              e2.key,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }

  void _onTileTap(int row, int col) {
    if (_board[row][col] != '') {
      return;
    }

    setState(() {
      _board[row][col] = _playerTurn ? 'X' : 'O';
      _playerTurn = !_playerTurn;
    });

    if (_checkWinner(row, col)) {
      _showEndGameDialog('Player ${_playerTurn ? 'O' : 'X'} wins!');
    } else if (_isBoardFull()) {
      _showEndGameDialog('The game is a draw!');
    }
  }

  Color _getColorForTile(int row, int col) {
    if (_board[row][col] == 'X') {
      return Colors.green;
    } else if (_board[row][col] == 'O') {
      return Colors.red;
    }
    return Colors.white;
  }

  bool _checkWinner(int row, int col) {
    final String currentPlayer = _board[row][col];

    // Check row
    bool rowWin = true;
    for (int i = 0; i < 3; i++) {
      if (_board[row][i] != currentPlayer) {
        rowWin = false;
        break;
      }
    }

    // Check column
    bool colWin = true;
    for (int i = 0; i < 3; i++) {
      if (_board[i][col] != currentPlayer) {
        colWin = false;
        break;
      }
    }

    // Check diagonal
    bool diagonalWin = false;
    if (row == col) {
      diagonalWin = true;
      for (int i = 0; i < 3; i++) {
        if (_board[i][i] != currentPlayer) {
          diagonalWin = false;
          break;
        }
      }
    }

    // Check anti-diagonal
    bool antiDiagonalWin = false;
    if (row + col == 2) {
      antiDiagonalWin = true;
      for (int i = 0; i < 3; i++) {
        if (_board[i][2 - i] != currentPlayer) {
          antiDiagonalWin = false;
          break;
        }
      }
    }

    return rowWin || colWin || diagonalWin || antiDiagonalWin;
  }

  bool _isBoardFull() {
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (_board[row][col] == '') {
          return false;
        }
      }
    }
    return true;
  }

  void _showEndGameDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _board = List<List<String>>.generate(
                    3,
                    (_) => List<String>.filled(3, ''),
                  );
                  _playerTurn = true;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Restart Game'),
            ),
          ],
        );
      },
    );
  }
}
