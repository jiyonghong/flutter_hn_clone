import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<Result<T>> api<T>(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Result.ok(jsonDecode(response.body) as T);
    } else {
      return Result.error(HttpException('Failed to load data'));
    }
  } on Exception catch (e) {
    return Result.error(e);
  }
}

sealed class Result<T> {
  const Result();

  factory Result.ok(T data) => Ok(data);

  factory Result.error(Exception error) => Error(error);
}

final class Ok<T> extends Result<T> {
  final T data;

  const Ok(this.data);
}

final class Error<T> extends Result<T> {
  final Exception error;

  const Error(this.error);
}
