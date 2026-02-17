import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.dark)) {
    on<ThemeToggled>(_onToggled);
    on<ThemeSetDark>(_onSetDark);
    on<ThemeSetLight>(_onSetLight);
  }

  void _onToggled(ThemeToggled event, Emitter<ThemeState> emit) {
    emit(
      state.copyWith(
        themeMode: state.isDark ? ThemeMode.light : ThemeMode.dark,
      ),
    );
  }

  void _onSetDark(ThemeSetDark event, Emitter<ThemeState> emit) {
    emit(state.copyWith(themeMode: ThemeMode.dark));
  }

  void _onSetLight(ThemeSetLight event, Emitter<ThemeState> emit) {
    emit(state.copyWith(themeMode: ThemeMode.light));
  }
}
