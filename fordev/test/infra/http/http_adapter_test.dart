import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/infra/http_adapter.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;
  Map<String, String> headers;

  void mockRequest() => when(client.post(any, headers: anyNamed('headers'), body: '{"any_key":"any_value"}')).thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();

    headers = {'content-type': 'application/json', 'accept': 'application/json'};
  });
  group(
    'Post Requests',
    () {
      test('Should call Post with correct Url', () async {
        // when(client.post(any, headers: anyNamed('headers'), body: '{"any_key":"any_value"}')).thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));
        mockRequest();

        await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

        verify(client.post(Uri.parse(url), headers: headers, body: '{"any_key":"any_value"}'));
      });

      test('Should call Post with correct Headers values', () async {
        mockRequest();
        await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

        verify(client.post(Uri.parse(url), headers: headers, body: '{"any_key":"any_value"}'));
      });

      test('Should call Post with correct Body', () async {
        mockRequest();
        await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

        verify(client.post(Uri.parse(url), headers: headers, body: '{"any_key":"any_value"}'));
      });

      test('Should call Post without Body', () async {
        when(client.post(any, headers: anyNamed('headers'))).thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));

        await sut.request(url: url, method: 'post');

        verify(client.post(any, headers: anyNamed('headers')));
      });

      test('Should return data if post returns 200', () async {
        when(client.post(any, headers: anyNamed('headers'))).thenAnswer((_) async => Response('{"any_key":"any_value"}', 200));

        final response = await sut.request(url: url, method: 'post');

        expect(response, {"any_key": "any_value"});
      });

      test('Should return null if post returns 200 with no data', () async {
        when(client.post(any, headers: anyNamed('headers'))).thenAnswer((_) async => Response('', 200));

        final response = await sut.request(url: url, method: 'post');

        expect(response, null);
      });
    },
  );
}
