import 'package:pizzaCalc/app/module.dart';

part 'models.freezed.dart';

/// Associates a Firebase Auth UID with the corresponding smusy user ID.
///
/// Note that this identifier only exists when the account was created via a
/// federated identity provider.
@freezed
abstract class UserIdentifier extends Entity implements _$UserIdentifier {
  const factory UserIdentifier(String uid) = _UserIdentifier;

  const UserIdentifier._();
  factory UserIdentifier.fromJson(Map<String, dynamic> json) =>
      UserIdentifier(json['uid'] as String);

  static final collection =
      services.firebaseFirestore.collection('userIdentifiers');

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'uid': uid};
}

/// Information about a signed-up user.
///
/// Missing fields from the old app: `school`, `bookmarkedArticles`,
/// `likedArticles`.
@freezed
abstract class User extends Entity implements _$User {
  const factory User({
    @required String firstName,
    @required String lastName,
    @required LocalDate birthday,
    @required GraduationInfo graduationInfo,
  }) = _User;

  const User._();
  factory User.fromJson(Map<String, dynamic> json) {
    final graduationInfo = json['finishedSchool'] as bool
        ? GraduationInfo.graduated(
            year: _decodeYear(json['graduatedOn']),
            degree: json['degree'] as String,
          )
        : GraduationInfo.notYetGraduated(
            currentGrade: json['grade'] as int,
            expectedYear: _decodeYear(json['willGraduateOn']),
          );

    return User(
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      birthday: _decodeDate(json['birthdate']),
      graduationInfo: graduationInfo,
    );
  }

  static final collection = services.firebaseFirestore.collection('users');

  static LocalDate _decodeDate(dynamic value) =>
      LocalDateTimePattern.generalIso.parse(value as String).value.calendarDate;
  static int _decodeYear(dynamic value) => _decodeDate(value).year;
  static String _encodeDate(LocalDate value) =>
      LocalDateTimePattern.generalIso.format(value.atMidnight());
  static String _encodeYear(int value) =>
      value == null ? null : _encodeDate(LocalDate(value, 1, 1));

  @override
  Map<String, dynamic> toJson() {
    final graduatedInfo = graduationInfo is _GraduatedInfo
        ? graduationInfo as _GraduatedInfo
        : null;
    final notYetGraduatedInfo = graduationInfo is _NotYetGraduatedInfo
        ? graduationInfo as _NotYetGraduatedInfo
        : null;
    return <String, dynamic>{
      'firstname': firstName,
      'lastname': lastName,
      'birthdate': _encodeDate(birthday),
      'finishedSchool': graduationInfo is _GraduatedInfo,
      'graduatedOn': _encodeYear(graduatedInfo?.year),
      'degree': graduatedInfo?.degree,
      'grade': notYetGraduatedInfo?.currentGrade,
      'willGraduateOn': _encodeYear(notYetGraduatedInfo?.expectedYear),
    };
  }
}

@freezed
abstract class GraduationInfo with _$GraduationInfo {
  const factory GraduationInfo.graduated({
    @required int year,
    @required String degree,
  }) = _GraduatedInfo;

  const factory GraduationInfo.notYetGraduated({
    @required int currentGrade,
    @required int expectedYear,
  }) = _NotYetGraduatedInfo;
}
