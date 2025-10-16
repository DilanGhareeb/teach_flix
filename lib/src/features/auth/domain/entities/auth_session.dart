import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  final bool isAuthenticated;
  final String? uid;

  const AuthSession({this.uid, required this.isAuthenticated});

  @override
  List<Object?> get props => [uid];
}
