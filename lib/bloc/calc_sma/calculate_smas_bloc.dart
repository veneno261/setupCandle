import 'package:bloc/bloc.dart';

import '../../logics/calculate_smas.dart';

sealed class SmasEvent {}

class CalculateSmasEvent extends SmasEvent {
  final Map<String, dynamic> data;

  CalculateSmasEvent({required this.data});
}

class ChangeSmasStateEvent extends SmasEvent {}

/// Notifies bloc to increment state.
class CalculateSmasState {}

class CalculateSmasIsInProgress extends CalculateSmasState {}

class CalculateSmasIsCompeleted extends CalculateSmasState {
  final List<List<double>> smas;

  CalculateSmasIsCompeleted({required this.smas});
}

class CalculateSmasGotError extends CalculateSmasState {
  final String error;

  CalculateSmasGotError({required this.error});
}

/// A `CounterBloc` which handles converting `CounterEvent`s into `int`s.
class CalculateSmas extends Bloc<SmasEvent, CalculateSmasState> {
  /// The initial state of the `CounterBloc` is 0.
  CalculateSmas() : super(CalculateSmasIsInProgress()) {
    /// When a `CounterIncrementPressed` event is added,
    /// the current `state` of the bloc is accessed via the `state` property
    /// and a new state is emitted via `emit`.
    on<CalculateSmasEvent>((event, emit) {
      emit(CalculateSmasIsInProgress());
      try {
        final List<List<double>> smaResult = calculateSMAs(event.data);
        emit(CalculateSmasIsCompeleted(smas: smaResult));
      } catch (e) {
        emit(CalculateSmasGotError(error: e.toString()));
      }
    });

    on<ChangeSmasStateEvent>((event, emit) {
      emit(CalculateSmasIsInProgress());
    });
  }
}
