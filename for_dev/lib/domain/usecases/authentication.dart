import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth({required AuthenticationParams authenticationParams});
}

class AuthenticationParams {
  final String email;
  final String secret;

  AuthenticationParams({required this.email, required this.secret});
}
