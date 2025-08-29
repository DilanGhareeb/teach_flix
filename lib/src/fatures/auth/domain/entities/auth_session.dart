import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  final String? uid;

  const AuthSession({this.uid});

  bool get isAuthenticated => uid != null && uid!.isNotEmpty;

  @override
  List<Object?> get props => [uid];
}
