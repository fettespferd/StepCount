import 'package:pizzaCalc/app/module.dart';
import 'package:pizzaCalc/content/user/models.dart';
import 'package:test/test.dart';

import '../../utils/serialization.dart';

void main() {
  group('UserIdentifier', () {
    testJsonSerialization(
      'JSON serialization',
      object: UserIdentifier('my-uid'),
      json: <String, dynamic>{'uid': 'my-uid'},
      fromJson: (json) => UserIdentifier.fromJson(json),
    );
  });
  group('User', () {
    group('JSON serialization', () {
      testJsonSerialization(
        'not yet graduated',
        object: User(
          firstName: 'Lorem N.Y.G.',
          lastName: 'Ipsum',
          birthday: LocalDate(2008, 06, 02),
          graduationInfo: GraduationInfo.notYetGraduated(
            currentGrade: 6,
            expectedYear: 2026,
          ),
        ),
        json: <String, dynamic>{
          'birthdate': '2008-06-02T00:00:00',
          'degree': null,
          'finishedSchool': false,
          'firstname': 'Lorem N.Y.G.',
          'grade': 6,
          'graduatedOn': null,
          'lastname': 'Ipsum',
          'willGraduateOn': '2026-01-01T00:00:00',
        },
        fromJson: (json) => User.fromJson(json),
      );
      testJsonSerialization(
        'graduated',
        object: User(
          firstName: 'Lorem G.',
          lastName: 'Ipsum',
          birthday: LocalDate(1998, 04, 02),
          graduationInfo: GraduationInfo.graduated(
            year: 2016,
            degree: 'Realschulabschluss (Mittlere Reife)',
          ),
        ),
        json: <String, dynamic>{
          'birthdate': '1998-04-02T00:00:00',
          'degree': 'Realschulabschluss (Mittlere Reife)',
          'finishedSchool': true,
          'firstname': 'Lorem G.',
          'grade': null,
          'graduatedOn': '2016-01-01T00:00:00',
          'lastname': 'Ipsum',
          'willGraduateOn': null,
        },
        fromJson: (json) => User.fromJson(json),
      );
    });
  });
}
