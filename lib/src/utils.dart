import 'package:js/js.dart';
import 'package:js/js_util.dart';

/// A javascript Promise.
///
/// Can be converted to a Dart Future using [toFuture].
@JS()
@anonymous
class Promise<T> {}

/// Convert a JS object a Dart Object.
Object? jsToDart(Object? object) {
  return dartify(object);
}

/// Convert a object Dart to a JS Object.
Object? dartToJs(Object? object) {
  if (object == null) {
    return object;
  }
  if (object is Map || object is Iterable) {
    return jsify(object);
  }
  return object;
}

/// Concert a JS promise to a Dart Future.
Future<T> toFuture<T>(Promise<T> promise) {
  return promiseToFuture(promise);
}

@JS('console.log')
external void _consoleLog(dynamic object);

/// Utility function to log a js object in the console.
void log(dynamic data) => _consoleLog(data);

/// Returns the values of a JsObject.
@JS('Object.values')
external List<Object> values(Object data);
