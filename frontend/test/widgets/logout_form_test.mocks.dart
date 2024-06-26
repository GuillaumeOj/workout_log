// Mocks generated by Mockito 5.4.4 from annotations
// in wod_board_app/test/widgets/logout_form_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i6;

import 'package:flutter/material.dart' as _i1;
import 'package:mockito/mockito.dart' as _i2;
import 'package:mockito/src/dummies.dart' as _i5;
import 'package:wod_board_app/models/user.dart' as _i3;
import 'package:wod_board_app/settings.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeGlobalKey_0<T extends _i1.State<_i1.StatefulWidget>>
    extends _i2.SmartFake implements _i1.GlobalKey<T> {
  _FakeGlobalKey_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUser_1 extends _i2.SmartFake implements _i3.User {
  _FakeUser_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SettingsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSettingsService extends _i2.Mock implements _i4.SettingsService {
  @override
  String get environnment => (super.noSuchMethod(
        Invocation.getter(#environnment),
        returnValue: _i5.dummyValue<String>(
          this,
          Invocation.getter(#environnment),
        ),
        returnValueForMissingStub: _i5.dummyValue<String>(
          this,
          Invocation.getter(#environnment),
        ),
      ) as String);

  @override
  String get apiUrlHost => (super.noSuchMethod(
        Invocation.getter(#apiUrlHost),
        returnValue: _i5.dummyValue<String>(
          this,
          Invocation.getter(#apiUrlHost),
        ),
        returnValueForMissingStub: _i5.dummyValue<String>(
          this,
          Invocation.getter(#apiUrlHost),
        ),
      ) as String);

  @override
  String get apiUrlPort => (super.noSuchMethod(
        Invocation.getter(#apiUrlPort),
        returnValue: _i5.dummyValue<String>(
          this,
          Invocation.getter(#apiUrlPort),
        ),
        returnValueForMissingStub: _i5.dummyValue<String>(
          this,
          Invocation.getter(#apiUrlPort),
        ),
      ) as String);

  @override
  _i1.GlobalKey<_i1.NavigatorState> get mainNavigatorKey => (super.noSuchMethod(
        Invocation.getter(#mainNavigatorKey),
        returnValue: _FakeGlobalKey_0<_i1.NavigatorState>(
          this,
          Invocation.getter(#mainNavigatorKey),
        ),
        returnValueForMissingStub: _FakeGlobalKey_0<_i1.NavigatorState>(
          this,
          Invocation.getter(#mainNavigatorKey),
        ),
      ) as _i1.GlobalKey<_i1.NavigatorState>);

  @override
  _i3.User get currentUser => (super.noSuchMethod(
        Invocation.getter(#currentUser),
        returnValue: _FakeUser_1(
          this,
          Invocation.getter(#currentUser),
        ),
        returnValueForMissingStub: _FakeUser_1(
          this,
          Invocation.getter(#currentUser),
        ),
      ) as _i3.User);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);

  @override
  void setCurrentUser(_i3.User? newUser) => super.noSuchMethod(
        Invocation.method(
          #setCurrentUser,
          [newUser],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setCurrentUsetToken(_i3.Token? newToken) => super.noSuchMethod(
        Invocation.method(
          #setCurrentUsetToken,
          [newToken],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addListener(_i6.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i6.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
