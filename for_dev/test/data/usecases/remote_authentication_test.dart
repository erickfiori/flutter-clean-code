import 'package:faker/faker.dart';
import 'package:for_dev/data/http/http.dart';
import 'package:for_dev/data/usecases/usecases.dart';
import 'package:for_dev/domain/errors/errors.dart';
import 'package:for_dev/domain/usecases/usecases.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<HttpClient>()])
import './remote_authentication_test.mocks.dart';

void main() {
  //? Mockito Null Safety - Use Mocked Class instead Base Class
  MockHttpClient httpClient = MockHttpClient();

  late final String url;
  late final RemoteAuthentication sut;
  late final AuthenticationParams authenticationParams;

  setUp(() {
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    authenticationParams = AuthenticationParams(email: faker.internet.email(), secret: faker.internet.password());
  });
  test("Should call HttpClient with correct values", () async {
    //? Triple A - Arrange, Act, Expect

    await sut.auth(authenticationParams: authenticationParams);

    verify(httpClient.request(url: url, method: 'post', body: {"email": authenticationParams.email, "password": authenticationParams.secret}));
  });

  test("Should throw UnexpectedError if HttpClient returns 400", () async {
    //? Triple A - Arrange, Act, Expect

    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenThrow(HttpError.badRequest);

    final future = sut.auth(authenticationParams: authenticationParams);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw InvalidCredentialsError if HttpClient returns 401", () async {
    //? Triple A - Arrange, Act, Expect

    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenThrow(HttpError.unauthorized);

    final future = sut.auth(authenticationParams: authenticationParams);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test("Should throw ServerError if HttpClient returns 500", () async {
    //? Triple A - Arrange, Act, Expect

    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body'))).thenThrow(HttpError.serverError);

    final future = sut.auth(authenticationParams: authenticationParams);

    expect(future, throwsA(DomainError.unexpected));
  });
}
