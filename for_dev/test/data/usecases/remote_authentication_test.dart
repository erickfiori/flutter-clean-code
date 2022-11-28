import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<HttpClient>()])
import './remote_authentication_test.mocks.dart';

void main() {
  late final HttpClient httpClient;
  late final String url;
  late final RemoteAuthentication sut;

  setUp(() {
    httpClient = MockHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });
  test("Should call HttpClient with correct values", () async {
    //? Triple A - Arrange, Act, Expect

    await sut.auth();

    verify(httpClient.request(url: url, method: 'post'));
  });
}

abstract class HttpClient {
  Future<void> request({required String url, required String method});
}

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}
