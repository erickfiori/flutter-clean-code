import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  HttpAdapter sut;
  ClientSpy client;
  String url;
  Map<String, String> headers;

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
        await sut.request(
          url: url,
          method: 'post',
        );

        verify(client.post(Uri.parse(url), headers: headers));
      });

      test('Should call Post with correct Headers values', () async {
        await sut.request(url: url, method: 'post');

        verify(client.post(Uri.parse(url), headers: headers));
      });

      test('Should call Post with correct Body', () async {
        await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

        verify(client.post(Uri.parse(url), headers: headers, body: '{"any_key":"any_value"}'));
      });

      test('Should call Post without Body', () async {
        await sut.request(url: url, method: 'post');

        verify(client.post(
          any,
          headers: anyNamed('headers'),
        ));
      });
    },
  );
}

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({@required String url, @required String method, Map body}) async {
    final headers = {'content-type': 'application/json', 'accept': 'application/json'};

    await client.post(Uri.parse(url), headers: headers, body: body != null ? jsonEncode(body) : null);
  }
}
