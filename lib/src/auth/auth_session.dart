import 'dart:async';

import 'package:flutter/cupertino.dart';

abstract class AuthSessionStorage<T, U> {
  FutureOr<void> clearUser();

  FutureOr<void> clearToken();

  FutureOr<T?> readUser();

  FutureOr<U?> readToken();

  FutureOr<void> saveUser(T user);

  FutureOr<void> saveToken(U token);
}

final class AuthSession<T, U> extends ChangeNotifier {
  AuthSession({required AuthSessionStorage<T, U> storage}) : _storage = storage;

  final AuthSessionStorage<T, U> _storage;

  T? _user;
  U? _token;

  bool get isSignedIn => _token != null;

  U get token => _token!;

  T get user => _user!;

  FutureOr<void> initialize() async {
    _user = await _storage.readUser();
    _token = await _storage.readToken();
  }

  Future<void> signIn(T user, U token) async {
    await _storage.saveUser(user);
    await _storage.saveToken(token);

    _user = user;
    _token = token;

    notifyListeners();
  }

  Future<void> signOut() async {
    await _storage.clearUser();
    await _storage.clearToken();

    _user = null;
    _token = null;

    notifyListeners();
  }
}
