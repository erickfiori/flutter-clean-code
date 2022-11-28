import '../../domain/usecases/usecases.dart';
import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth({required AuthenticationParams authenticationParams}) async {
    final body = RemoteAuthenticationParams.fromDomain(authenticationParams).toJson();

    await httpClient.request(url: url, method: 'post', body: body);
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String secret;

  RemoteAuthenticationParams({required this.email, required this.secret});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams authenticationParams) {
    return RemoteAuthenticationParams(email: authenticationParams.email, secret: authenticationParams.secret);
  }

  Map<String, dynamic> toJson() => {"email": email, "password": secret};
}
