import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:redux/redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Lecture>> getTodayLectures(Store<AppState> store) async {
  List<Lecture> lectures = await getLectures(store);

  final now = DateTime.now();
  final nowSeconds = now.hour * 3600 + now.minute * 60 + now.second;
  final weekday = now.weekday;

  List<Lecture> result = <Lecture>[];

  for (Lecture lecture in lectures) {
    if (lecture.day == weekday - 1 &&
        lecture.startTimeSeconds + 60 * 30 * lecture.blocks < nowSeconds) {
      result.add(lecture);
    }
  }

  return result;
}

Future<num> getRateTeacher(String name, String subject) async {
  num counter = 0, sum = 0;
  var collection = FirebaseFirestore.instance
      .collection('teachers')
      .where('teacher', isEqualTo: name)
      .where('subject', isEqualTo: subject);
  var querySnapshot = await collection.get();
  for (var doc in querySnapshot.docs) {
    counter++;
    sum += doc.data()['rating'];
  }
  if (counter == 0) return 0;
  return sum / counter;
}

Future<num> getRateRoom(String name) async {
  num counter = 0, sum = 0;
  var collection = FirebaseFirestore.instance
      .collection('rooms')
      .where('name', isEqualTo: name);
  var querySnapshot = await collection.get();
  for (var doc in querySnapshot.docs) {
    counter++;
    sum += doc.data()['rating'];
  }
  if (counter == 0) return 0;
  return sum / counter;
}

Future<void> addRoomRating(
    String subject, String name, double rating, String comment) async {
  return FirebaseFirestore.instance.collection('rooms').add(
      {'comment': comment, 'name': name, 'subject': subject, 'rating': rating});
}

Future<void> addClassRating(String subject, String teacher, double rating) {
  return FirebaseFirestore.instance
      .collection('teachers')
      .add({'subject': subject, 'teacher': teacher, 'rating': rating});
}
