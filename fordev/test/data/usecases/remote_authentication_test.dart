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

  Map mockValidData() => {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')));

  void mockHttpData(Map data) => mockRequest().thenAnswer((_) async => data);
  void mockHttpError(HttpError httpError) => mockRequest().thenThrow(httpError);

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    authenticationParams = AuthenticationParams(email: faker.internet.email(), password: faker.internet.password());
  });

  test("Should call HttpClient with correct values", () async {
    mockHttpData(mockValidData());

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
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(authenticationParams);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Should throw UnexpectedError if HttpClient returns 404", () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(authenticationParams);

    expect(future, throwsA(DomainError.unexpected));
  });
  test("Should throw InvalidCredentialsError if HttpClient returns 401", () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(authenticationParams);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test("Should return an Account if HttpClient 200", () async {
    final validData = mockValidData();

    mockHttpData(validData);

    final account = await sut.auth(authenticationParams);

    expect(account.token, validData['accessToken']);
  });

  test("Should throw UnexpectedError if HttpClient returns 200 with invalid data", () async {
    mockHttpData({'invalidKey': 'invalidValue'});

    final future = sut.auth(authenticationParams);

    expect(future, throwsA(DomainError.unexpected));
  });
}
