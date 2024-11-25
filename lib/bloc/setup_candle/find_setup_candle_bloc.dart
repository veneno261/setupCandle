import 'dart:convert';

import 'package:bloc/bloc.dart';

import '../../apis/get_market_data.dart';
import '../../logics/find_setup_candle.dart';
import '../../models/candle_model_response.dart';

/// The events which `CounterBloc` will react to.
sealed class SetupCandleEvent {}

class FindSetupCandleEvent extends SetupCandleEvent {
  final int lookBack;
  final String tokenName;
  final String tokenConvert;
  final String exchange;
  final String candleLimit;
  final String timeFrame;
  final String dhm;

  FindSetupCandleEvent({
    required this.lookBack,
    required this.tokenName,
    required this.tokenConvert,
    required this.exchange,
    required this.candleLimit,
    required this.timeFrame,
    required this.dhm,
  });
}

/// Notifies bloc to increment state.
class FetchDataForFindSetupCandle {}

class FindSetupCandleIsInProgress extends FetchDataForFindSetupCandle {}

class FindSetupCandleIsCompeleted extends FetchDataForFindSetupCandle {
  final CandleModelResponse response;

  FindSetupCandleIsCompeleted({required this.response});
}

class FindSetupCandleGotError extends FetchDataForFindSetupCandle {
  final String error;

  FindSetupCandleGotError({required this.error});
}

/// A `CounterBloc` which handles converting `CounterEvent`s into `int`s.
class FindSetupCandle extends Bloc<SetupCandleEvent, FetchDataForFindSetupCandle> {
  /// The initial state of the `CounterBloc` is 0.
  FindSetupCandle() : super(FetchDataForFindSetupCandle()) {
    /// When a `CounterIncrementPressed` event is added,
    /// the current `state` of the bloc is accessed via the `state` property
    /// and a new state is emitted via `emit`.
    on<FindSetupCandleEvent>((event, emit) async {
      emit(FindSetupCandleIsInProgress());

      print('---------- ${event.tokenName} --------------');

      final response = await fetchMarketData(
        tokenName: event.tokenName,
        tokenConvert: event.tokenConvert,
        candleLimit: event.candleLimit,
        exchange: event.exchange,
        timeFrame: event.timeFrame,
        dhm: event.dhm,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        CandleModelResponse candleModel = findSetupCandle(
          candles: data,
          lookBack: event.lookBack,
          tokenName: event.tokenName,
          timFrame: event.timeFrame,
          dhm: event.dhm,
        );
        emit(FindSetupCandleIsCompeleted(response: candleModel));
      } else {
        print('Error: ${response.statusCode}');
        emit(FindSetupCandleGotError(error: response.statusCode.toString()));
      }
    });
  }
}
