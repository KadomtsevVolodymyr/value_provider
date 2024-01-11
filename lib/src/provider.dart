import 'dart:async';

import 'package:flutter/material.dart';
import 'package:value_provider/src/notifiable_builder.dart';

typedef ValueBuilder<T> = Widget Function(BuildContext, T);
typedef UpdateShouldNotify<T> = bool Function(T, T);
typedef ValueConverter<T, S> = T Function(S);

class ValueProvider<T, S> extends StatelessWidget {
  ValueProvider({
    Key? key,
    this.resultConverter,
    required this.builder,
    required this.future,
    required this.shouldNotify,
    required T initValue,
  })  : notifier = ValueNotifier(initValue),
        super(key: key);

  final ValueBuilder<T> builder;
  final FutureOr<S> future;
  final UpdateShouldNotify<T> shouldNotify;
  final ValueNotifier<T> notifier;
  final ValueConverter<T, S>? resultConverter;

  static ValueNotifier of<T>(BuildContext context) => _ValueController.of<T>(context);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(future),
      builder: (context, result) {
        final hasData = result.hasData && result.data != null;
        if (hasData) notifier.value = resultConverter == null ? result.data as T : resultConverter!(result.data as S);
        return NotifiableBuilder(
          notifier: notifier,
          builder: (context) {
            return _ValueController<T>._(
              value: notifier.value,
              notifier: notifier,
              shouldNotify: shouldNotify,
              child: builder(context, notifier.value),
            );
          },
        );
      },
    );
  }
}

class _ValueController<T> extends InheritedWidget {
  const _ValueController._({
    Key? key,
    required this.value,
    required this.notifier,
    required this.shouldNotify,
    required Widget child,
  }) : super(key: key, child: child);
  final T value;
  final ValueNotifier<T> notifier;
  final bool Function(T, T) shouldNotify;

  @override
  bool updateShouldNotify(_ValueController oldWidget) => shouldNotify(value, oldWidget.value);

  static ValueNotifier of<T>(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ValueController<T>>()!.notifier;
}
