import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleDetailPage extends StatefulWidget {
  const ScheduleDetailPage({Key? key}) : super(key: key);

  @override
  State<ScheduleDetailPage> createState() => _ScheduleDetailPageState();
}

class _ScheduleDetailPageState extends State<ScheduleDetailPage> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  // 이 페이지가 생성될 그 때만 인스턴스 전달만 해주면 됨

  @override
  // State가 처음 만들어졌을때만 하는 것
  void initState() {
    // TODO: implement initState
    super.initState(); // 이걸 먼저 해줘야함(부모 클래스로부터 받아옴, Stateful 위젯 안에 initState가 있기때문에)
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
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class ScheduleDetail extends StatelessWidget {
  ScheduleDetail({Key? key}) : super(key: key);

  List<Subject> todoList = [                          // 그냥 예시입니다!!
    Subject('DB','13:00-14:30','DB레포트 작성'),
    Subject('Graphics', '15:00-18:00', 'Texture, Lighting, 할거 짱 많네 아오'),
    Subject('Algorithm', '21:00-23:00', 'BFS'),
    Subject('DB','13:00-14:30','DB레포트 작성'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
           title: const Text('상세 일정'),
        ),
      body:
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.separated(
                itemCount: todoList.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                      child: Text('오늘 일정(${getToday()})', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    );
                  }
                  return SubjectTile(todoList[index - 1]);
                },
                separatorBuilder: (context, index) {
                  if (index == 0) {
                    return SizedBox.shrink();
                  }
                  return const Divider();
                },
              ),
            ),
          )
    );
  }

}

class Subject {
  String title;
  String time;
  String todo;

  Subject(this.title, this.time, this.todo);
}


class SubjectTile extends StatelessWidget {
  SubjectTile(this._subject);

  final Subject _subject;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          SizedBox(
            width: 70,
              child:
                Text(_subject.title,
                  style: const TextStyle(height: 1, fontSize: 15, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)
          ),
          const SizedBox(width: 30,),
          Text(_subject.time),
          const SizedBox(width: 30,),
          Expanded(
            child: Text(_subject.todo,),
          ),
        ],
      ),
      onTap: (){        // 리스트 타일을 클릭하면
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
                      Text(_subject.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3),
                      const SizedBox(width: 20),
                      Expanded(child: Text(_subject.todo, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),)),
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
                      const SizedBox(                   // 이 곳엔 진행바가 들어갈 예정!!!!!!!!!!!
                        height: 100,
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
                            child: Text(_subject.time),       // 시작 시간만 잘라서 넣기
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      Row(
                        children: [
                          const Text('종료'),
                          SizedBox(width: 30,),
                          Container(
                            child: Text(_subject.time),       // 끝나는 시간만 잘라서 넣기
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