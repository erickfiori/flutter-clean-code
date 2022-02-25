import 'package:faker/faker.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;
  AuthenticationParams authenticationParams;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    authenticationParams = AuthenticationParams(email: faker.internet.email(), password: faker.internet.password());
  });

  //? Triple A - Arrange, Act, Assert

  test("Should call HttpClient with correct values", () async {
    when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')),
    ).thenAnswer((_) async => {'accessToken': faker.guid.guid(), 'name': faker.person.name()});

    await sut.auth(authenticationParams);

    verify(
      httpClient.request(
        url: url,
        method: 'post',
        body: {'email': authenticationParams.email, 'password': authenticationParams.password},
      ),
    );
  });

  test("Should throw UnexpectedError if HttpClient returns 400", () async {
    when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')),
    ).thenThrow(
      HttpError.badRequest,
    );

    final future = sut.auth(authenticationParams);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async {
    when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')),
    ).thenThrow(
      HttpError.notFound,
    );

    final future = sut.auth(authenticationParams);

    expect(future, throwsA(DomainError.unexpected));
  });
  test("Should throw InvalidCredentialsError if HttpClient returns 401", () async {
    when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')),
    ).thenThrow(
      HttpError.unauthorized,
    );

    final future = sut.auth(authenticationParams);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

//! Validar este teste e encontrar solução
  test("Should return an Account if HttpClient 200", () async {
    final accessToken = faker.guid.guid();

    when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')),
    ).thenAnswer((_) async => {'accessToken': accessToken, 'name': faker.person.name()});

    final account = await sut.auth(authenticationParams);

    expect(account.token, accessToken);
  });
  test("Should throw UnexpectedError if HttpClient returns 200 with invalid data", () async {
    when(
      httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')),
    ).thenAnswer((_) async => {'invalidKey': 'invalidValue', 'name': faker.person.name()});

    final future = sut.auth(authenticationParams);

    expect(future, throwsA(DomainError.unexpected));
  });
}
