@TestOn('browser')

import 'package:test/test.dart';

import 'package:gun_dart/src/utils.dart';

void main() {
  test('Convert Dart string to js object', () {
    final js = dartToJs('Hello World');
    final result = jsToDart(js);
    expect(result, 'Hello World');
  });

  test('Convert Dart int to js object', () {
    final js = dartToJs(123);
    final result = jsToDart(js);
    expect(result, 123);
  });

  test('Convert Dart double to js object', () {
    final js = dartToJs(123.456);
    final result = jsToDart(js);
    expect(result, 123.456);
  });

  test('Convert Dart bool to js object', () {
    final js = dartToJs(true);
    final result = jsToDart(js);
    expect(result, true);
  });

  test('Convert Dart list to js object', () {
    final js = dartToJs([1, 2, 3]);
    final result = jsToDart(js);
    expect(result, [1, 2, 3]);
  });

  test('Convert Dart map to js object', () {
    final js = dartToJs({'a': 1, 'b': 2, 'c': 3});
    final result = jsToDart(js);
    expect(result, {'a': 1, 'b': 2, 'c': 3});
  });

  test('Convert Dart map with list to js object', () {
    final js = dartToJs({
      'a': [1, 2, 3],
      'b': 2,
      'c': 3
    });
    final result = jsToDart(js);
    expect(result, {
      'a': [1, 2, 3],
      'b': 2,
      'c': 3
    });
  });

  test('Convert Dart map with map to js object', () {
    final js = dartToJs({
      'a': {'a': 1, 'b': 2, 'c': 3},
      'b': 2,
      'c': 3
    });
    final result = jsToDart(js);
    expect(result, {
      'a': {'a': 1, 'b': 2, 'c': 3},
      'b': 2,
      'c': 3
    });
  });
}
