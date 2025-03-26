part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginWithEmailEvent(
    this.email,
    this.password,
  );

  @override
  List<Object> get props => [email, password];
}

class CheckAuthEvent extends AuthEvent {}

class LoginWithGoogleEvent extends AuthEvent {}

class SignupEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;

  const SignupEvent(this.email, this.password, this.username);

  @override
  List<Object> get props => [email, password, username];
}

class LogoutEvent extends AuthEvent {}
