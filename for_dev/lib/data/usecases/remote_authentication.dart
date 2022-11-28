import '../../domain/usecases/usecases.dart';
import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth({required AuthenticationParams authenticationParams}) async {
    await httpClient.request(
      url: url,
      method: 'post',
      body: {"email": authenticationParams.email, "secret": authenticationParams.secret},
    );
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String secret;

  RemoteAuthenticationParams({required this.email, required this.secret});
}
