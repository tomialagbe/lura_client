import 'package:equatable/equatable.dart';

class LuraUser extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;

  const LuraUser({
    required this.uid,
    this.email,
    this.displayName,
  });

  static const empty = LuraUser(uid: '');

  @override
  List<Object?> get props => [uid, email, displayName];
}
