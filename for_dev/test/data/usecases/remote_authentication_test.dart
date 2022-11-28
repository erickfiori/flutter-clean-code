import 'package:faker/faker.dart';
import 'package:for_dev/domain/usecases/authentication.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<HttpClient>()])
import './remote_authentication_test.mocks.dart';

void main() {
  late final HttpClient httpClient;
  late final String url;
  late final RemoteAuthentication sut;
  late final AuthenticationParams authenticationParams;

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    authenticationParams = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
  });
  test("Should call HttpClient with correct values", () async {
    //? Triple A - Arrange, Act, Expect

    await sut.auth(authenticationParams: authenticationParams);

    verify(httpClient.request(url: url, method: 'post', body: {"email": authenticationParams.email, "secret": authenticationParams.secret}));
  });
}

abstract class HttpClient {
  Future<void> request({
    required String url,
    required String method,
    Map<String, dynamic> body,
  });
}

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
