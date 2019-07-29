import 'package:flutter/material.dart';

var finalScore = 0;
var questionNumber = 0;
var quiz = new AnimalQuiz();

class AnimalQuiz {
  var questions = [
    "He _ a doctor.",
    "__ like to chase mice and birds.",
    "She __ to market.",];
  var choices = [
    ["A: iis", "B: was", "C: are", "am"],
    ["Cat", "Snail", "Slug", "Horse"],
    ["Spider", "Snake", "Hawk", "Owl"]
  ];
  var correctAnswers = [
    "is", "Cat", "Owl"
  ];
}

class Quiz1 extends StatefulWidget {
  @override
  _Quiz1State createState() => _Quiz1State();
}

class _Quiz1State extends State<Quiz1> {
  void updateQuestion(){
    setState(() {
      if(questionNumber == quiz.questions.length - 1){
        //Navigator.push(context, new MaterialPageRoute(builder: (context) => (){}));
        debugPrint("Done");
      }else{
        questionNumber++;
      }
    });
  }
  void resetQuiz(){
    setState(() {
      Navigator.pop(context);
      finalScore = 0;
      questionNumber = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(onWillPop: ()async => false,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Quiz'),
            ),
            body: new Container(
              child: new Column(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.all(10.0),
                  ),
                  new Container(
                    //alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
//                        new MaterialButton(
//                            color: Colors.red,
//                            onPressed: resetQuiz,
//                            child: new Text("Quit", style: new TextStyle(color: Colors.white))),
                        new Text("Question ${questionNumber + 1} of ${quiz.questions.length}"),
                        new Text("Score $finalScore"),
                      ],
                    ),
                  ),
                  new Padding(padding: EdgeInsets.all(10.0)),
                  new Text(quiz.questions[questionNumber]),
                  new AnswerWidget(),
                  new Padding(padding: EdgeInsets.all(10.0)),
                  new Row(
                    children: <Widget>[
                      new MaterialButton(
                        color: Colors.blueGrey,
                        onPressed: (){
                          if(quiz.choices[questionNumber][0] == quiz.correctAnswers[questionNumber]){
                            debugPrint("Correct");
                            finalScore++;
                          } else {debugPrint("Wrong");
                          }
                          updateQuestion();
                        },
                        child: new Text(quiz.choices[questionNumber][0]),),

                    ],
                  ),

                  new Padding(padding: EdgeInsets.all(10.0)),
//              new Container(
//                alignment: Alignment.topRight,
//                child: new Text("Answer explained"),
//              ),
                  new ExpansionTile(
                    title: Column(
                      children: <Widget>[
                        Text("展开答案")
                      ],
                    ),
//                leading: CircleAvatar(
//                  backgroundColor: Colors.grey,
//                  child: Text("多选"),
//                ),
                    children: <Widget>[
                      Text("this is a qu about. this is a qu about.this is a qu about.this is a qu about.this is a qu about.this is a qu about.this is a qu about.this is a qu about."),
                    ],
                  ),

                ],
              ),
            )
        ));
  }
}


class AnswerWidget extends StatefulWidget {
//  final List<Results> results;
//  final int index;

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  Color c = Colors.black;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        setState(() {
          c = Colors.green;
        });
      },
      title: Text("A: baba", style: TextStyle(color: c),),
    );
  }
}
