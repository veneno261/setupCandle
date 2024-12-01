import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:candle_setup_finder/models/bot_message_template.dart';

import '../../apis/fetch_chart_image.dart';

/// The events which `CounterBloc` will react to.
sealed class ChartImageEvent {}

class GetChartImageEvent extends ChartImageEvent {
  final String tokenName;
  final String interval;
  final BotMessageTemplate botMessage;

  GetChartImageEvent({
    required this.interval,
    required this.tokenName,
    required this.botMessage,
  });
}

/// Notifies bloc to increment state.
class ChartImageState {}

class ChartImageStateIsInProgress extends ChartImageState {}

class ChartImageStateIsCompeleted extends ChartImageState {
  final http.MultipartFile chartImg;
  final BotMessageTemplate botMessage;

  ChartImageStateIsCompeleted({
    required this.chartImg,
    required this.botMessage,
  });
}

class ChartImageStateGotError extends ChartImageState {
  final String error;
  final BotMessageTemplate botMessage;

  ChartImageStateGotError({
    required this.error,
    required this.botMessage,
  });
}

/// A `CounterBloc` which handles converting `CounterEvent`s into `int`s.
class ChartImageBloc extends Bloc<ChartImageEvent, ChartImageState> {
  /// The initial state of the `CounterBloc` is 0.
  ChartImageBloc() : super(ChartImageState()) {
    final ChartImgApi imgApi = ChartImgApi();

    /// When a `CounterIncrementPressed` event is added,
    /// the current `state` of the bloc is accessed via the `state` property
    /// and a new state is emitted via `emit`.
    on<GetChartImageEvent>((event, emit) async {
      emit(ChartImageStateIsInProgress());

      final response = await imgApi.getChartImage(
        symbol: event.tokenName,
        interval: event.interval,
      );

      if (response.statusCode == 200) {
        emit(ChartImageStateIsCompeleted(
          chartImg: http.MultipartFile.fromBytes(
            'photo',
            response.bodyBytes,
            filename: '${event.tokenName}_${event.interval}.png',
            contentType: MediaType('image', 'png'),
          ),
          botMessage: event.botMessage,
        ));
      } else {
        print('Error: ${response.statusCode}');
        emit(ChartImageStateGotError(
          error: response.statusCode.toString(),
          botMessage: event.botMessage,
        ));
      }
    });
  }
}
