
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:team/SubjectsProvider.dart';

import 'package:team/personalView.dart';
User? loggedUser;
class Subject {
  String title;
  String start;
  String end;
  String memo;
  String type;

  Subject(this.title, this.start, this.end, this.memo, this.type);
}
class ScheduleDetail extends StatefulWidget {
  ScheduleDetail({Key? key}) : super(key: key);

  @override
  State<ScheduleDetail> createState() => _ScheduleDetailState();
}

class _ScheduleDetailState extends State<ScheduleDetail> {

  final _authentication = FirebaseAuth.instance;

  // 이 페이지가 생성될 그 때만 인스턴스 전달만 해주면 됨
  Future<void> setSchedure_Assingment() async {
    var sub = FirebaseFirestore.instance.collection('Subject').
    where('uid', isEqualTo: _authentication.currentUser!.uid).get();
    var check = await sub;

    for (int i = 0; i < check.docs.length; i++) {
      var todayAssingn = FirebaseFirestore.instance.collection('Subject').
      doc(check.docs[i]['SubjectName']).collection('Assignment').get();

      var list = await todayAssingn;
        for (int i = 0; i < list.docs.length; i++) {
          if (intoDay(list.docs[i]['startYMDT'], list.docs[i]['endYMDT']) == true) {
            /*context
                .read<Subs>()
                .taskname
                .add(list.docs[i]['assignexamname']);*/
            context
                .read<Subs>()
                .prov_subjectname
                .add(list.docs[i]['subject']);
            context
                .read<Subs>()
                .prov_memo
                .add(list.docs[i]['memo']);
            context
                .read<Subs>()
                .start
                .add(list.docs[i]['startYMDT']);
            context
                .read<Subs>()
                .end
                .add(list.docs[i]['endYMDT']);
            context
                .read<Subs>()
                .type
                .add('과제');
          }
      }
    }
    for (int i = 0; i < check.docs.length; i++) {
      var todayExam = FirebaseFirestore.instance.collection('Subject').
      doc(check.docs[i]['SubjectName']).collection('Exam').get();

      var list = await todayExam;
      for (int i = 0; i < list.docs.length; i++) {
        if(intoDay(list.docs[i]['startYMDT'], list.docs[i]['endYMDT']) == true){
          /*context
              .read<Subs>()
              .taskname
              .add(list.docs[i]['assignexamname']);*/
          context
              .read<Subs>()
              .prov_subjectname
              .add(list.docs[i]['subject']);
          context
              .read<Subs>()
              .prov_memo
              .add(list.docs[i]['memo']);
          context
              .read<Subs>()
              .start
              .add(list.docs[i]['startYMDT']);
          context
              .read<Subs>()
              .end
              .add(list.docs[i]['endYMDT']);
          context
              .read<Subs>()
              .type
              .add('시험');
       }
      }
    }
    for (int i = 0; i < check.docs.length; i++) {
      var todayQuiz = FirebaseFirestore.instance.collection('Subject').
      doc(check.docs[i]['SubjectName']).collection('Quiz').get();

      var list = await todayQuiz;
        for (int i = 0; i < list.docs.length; i++) {
          if(intoDay(list.docs[i]['startYMDT'], list.docs[i]['endYMDT']) == true) {
            /*context
                .read<Subs>()
                .taskname
                .add(list.docs[i]['assignexamname']);*/
            context
              .read<Subs>()
              .prov_subjectname
              .add(list.docs[i]['subject']);
          context
              .read<Subs>()
              .prov_memo
              .add(list.docs[i]['memo']);
          context
              .read<Subs>()
              .start
              .add(list.docs[i]['startYMDT']);
          context
              .read<Subs>()
              .end
              .add(list.docs[i]['endYMDT']);
          context
              .read<Subs>()
              .type
              .add('퀴즈');
        }
      }
    }
  }

  @override
  // State가 처음 만들어졌을때만 하는 것
  void initState() {
    // TODO: implement initState
    super
        .initState(); // 이걸 먼저 해줘야함(부모 클래스로부터 받아옴, Stateful 위젯 안에 initState가 있기때문에)
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser; // _authentication 의 currentUser을 대입
      if (user != null) {
        loggedUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
  bool intoDay(String startDay, String endDay){
      /*String year = startDay.substring(0, 4);
      String month = startDay.substring(5,7);
      String day = startDay.substring() // 20221202   20221204    20221208
      */
      String newToDay = getcompareDay().substring(0,11);
      String newStartDay = startDay.substring(0,11);
      String newendDay = endDay.substring(0,11);
      int resultstart = newStartDay.compareTo(newToDay);
      int resultend = newendDay.compareTo(newToDay);

      if(resultstart <= 0 && resultend >= 0){
        return true;
      }
      else
        return false;
      /*
      if(result == 0){
        print('같음');
      }

      else if (result > 0){
        print('스타트데이가 큼');
      }
      else if (result < 0){
        print('엔드데이가 큼');
      }
*/  }
  @override
  Widget build(BuildContext context) {
    context
        .read<Subs>()
        .prov_subjectname
        .clear();
    context
        .read<Subs>()
        .prov_memo
        .clear();
    context
        .read<Subs>()
        .start
        .clear();
    context
        .read<Subs>()
        .end
        .clear();
    context
        .read<Subs>()
        .type
        .clear();
    print('스캐줄 빌드');
    return
      DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: AppBar(
                bottom: TabBar(tabs: [
                  Tab(icon: Icon(Icons.schedule),),
                  Tab(icon: Icon(Icons.book),)
                ]),
              ),
            ),
            body: TabBarView(
              children: [
                SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60), // 모서리를 둥글게
                      border: Border.all(color: Colors.indigo, width: 10)),
                  child: Column(
                    children: <Widget>[
                      Text('\n\n오늘 일정 (${getToday()})',
                          style: const TextStyle(fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      Text('개인 일정', style: const TextStyle(fontSize: 16,
                          fontWeight: FontWeight.bold)),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('Personal').
                          where('uid',isEqualTo: _authentication.currentUser!.uid).
                          where('comparedate', isEqualTo: getcompareDay().substring(0,10)).
                          snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final docs = snapshot.data!.docs;
                            return ListView.separated(
                              itemCount: docs.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: ListTile(title: Text(
                                      '     ${docs[index]['time']} :    ${docs[index]['title']
                                          .toString()}',
                                      style: const TextStyle(height: 3,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.start
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  thickness: 3.0,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ), // 개인
                SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60), // 모서리를 둥글게
                        border: Border.all(color: Colors.indigo, width: 10)),
                    child: Column(
                      children: <Widget>[
                        Text('\n\n오늘 일정(${getToday()})',
                            style: const TextStyle(fontSize: 17,
                                fontWeight: FontWeight.bold)),
                        Text('공부 일정', style: const TextStyle(fontSize: 16,
                            fontWeight: FontWeight.bold)),
                        FutureBuilder(
                            future: setSchedure_Assingment(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text('');
                              }
                              else {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: ListView.builder(
                                      itemCount: context
                                          .read<Subs>()
                                          .prov_subjectname
                                          .length,
                                      itemBuilder: (context, index) {
                                        return Dismissible(
                                          key: ValueKey(context
                                              .read<Subs>()
                                              .prov_subjectname[index]),
                                          background: Container(
                                            color: Colors.lightBlue,),
                                          child: Container(
                                            height: 80,
                                            child: SubjectTile(Subject(context
                                                .read<Subs>()
                                                .prov_subjectname[index],
                                                context
                                                    .read<Subs>()
                                                    .start[index],
                                                context
                                                    .read<Subs>()
                                                    .end[index],
                                                context
                                                    .read<Subs>()
                                                    .prov_memo[index],
                                                context
                                                    .read<Subs>()
                                                    .type[index]
                                            )
                                            ),
                                          ),
                                          onDismissed: (direction) {
                                            setState(() {
                                              String TYPE = '';
                                              if (context
                                                  .read<Subs>()
                                                  .type[index] == '시험')
                                                TYPE = 'Exam';
                                              else if (context
                                                  .read<Subs>()
                                                  .type[index] == '과제')
                                                TYPE = 'Assignment';
                                              else if (context
                                                  .read<Subs>()
                                                  .type[index] == '퀴즈')
                                                TYPE = 'Quiz';


                                                FirebaseFirestore.instance.collection('Subject').
                                              doc(context.read<Subs>().prov_subjectname[index]).collection(TYPE).doc('oopprojec').delete();

                                              context
                                                  .read<Subs>()
                                                  .prov_subjectname
                                                  .removeAt(index);
                                              context
                                                  .read<Subs>()
                                                  .prov_memo
                                                  .removeAt(index);
                                              context
                                                  .read<Subs>()
                                                  .start
                                                  .removeAt(index);
                                              context
                                                  .read<Subs>()
                                                  .end
                                                  .removeAt(index);
                                              context
                                                  .read<Subs>()
                                                  .type
                                                  .removeAt(index);
                                           });
                                          },
                                        );
                                      },
                                      /*separatorBuilder: (context, index) {
                                        return const Divider(
                                          thickness: 3.0,
                                        );
                                      },*/
                                    ),
                                  ),
                                );
                              }
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        ),
      );
  }
}
class SubjectTile extends StatefulWidget {
  SubjectTile(this._subject);
  final Subject _subject;

  @override
  State<SubjectTile> createState() => _SubjectTileState();
}

class _SubjectTileState extends State<SubjectTile> {
  double _currentSliderValue = 25;
  bool _check = false;
  @override
  Widget build(BuildContext context) {
      String _endTime = '';
    for(int i = 5; i < 16; i++){
      _endTime += widget._subject.end[i];
    }
    return ListTile(
      trailing:Icon( Icons.check, color: _check ?  Colors.green : Colors.grey),
      title: Row(
        children: [
          SizedBox(
            width: 50,
              child:
                Text(widget._subject.title,
                  style: const TextStyle(height: 1, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
          ),
          Text('  마감일 : '),
          const SizedBox(width: 15,),
          Expanded(child: Text(_endTime)),            // '할 일' 잘리는 것 방지
          Text(widget._subject.type),
          const SizedBox(width: 15,),
        ],
      ),
      onTap: (){        // 리스트 타일이 클릭되면
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22.0))),
                title: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(widget._subject.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3),
                      const SizedBox(width: 15),
                      Expanded(                                 // '할 일' 잘리는 것 방지
                        child: Text(widget._subject.memo,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                      ),
                    ],
                  ),
                ),
                content: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: 300,
                  height: 300,
                  child: Column(
                    children: [
                      const Text('진행도'),
                      Slider(
                          value: _currentSliderValue,
                          max: 100,
                          divisions: 5,
                        label: _currentSliderValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                            if(_currentSliderValue == 100)
                              _check = true;
                            else
                              _check = false;
                          });
                        },
                      ),
                      Row(
                        children: [
                          const Text('날짜'),
                          SizedBox(width: 30,),
                          Container(
                            child: Text(getToday()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      Row(
                        children: [
                          const Text('시작'),
                          SizedBox(width: 30,),
                          Container(
                            child: Text(widget._subject.start),       // 시작 시간만 잘라서 넣기
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      Row(
                        children: [
                          const Text('종료 '),
                          SizedBox(width: 30,),
                          Container(
                            child: Text(widget._subject.end),       // 끝나는 시간만 잘라서 넣기
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            )
        );
      },
    );
  }
}
String getToday(){      // 오늘 날짜 가져오는 함수
  var now = DateTime.now();
  String formatDate = DateFormat('MM/dd').format(now);
  return formatDate;
}

String getcompareDay(){
  var now = DateTime.now();
  return now.toString();
}