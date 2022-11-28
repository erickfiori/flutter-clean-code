import 'package:faker/faker.dart';
import 'package:for_dev/data/http/http.dart';
import 'package:for_dev/data/usecases/usecases.dart';
import 'package:for_dev/domain/usecases/usecases.dart';

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
