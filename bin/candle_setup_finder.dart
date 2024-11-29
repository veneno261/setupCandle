import 'dart:async';
import 'dart:io';

import 'package:candle_setup_finder/bloc/chart_img/get_chart_image_bloc.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:cron/cron.dart';

import 'package:candle_setup_finder/bloc/calc_sma/calculate_smas_bloc.dart';
import 'package:candle_setup_finder/bloc/setup_candle/find_setup_candle_bloc.dart';
import 'package:candle_setup_finder/logics/bot_message.dart';
import 'package:candle_setup_finder/models/bot_message_template.dart';
import 'package:candle_setup_finder/models/candle_model_response.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

void main(List<String> arguments) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);

  //'8159444945:AAFREaeS7veuvpiG_oFDEogcQASvBJSpU78', '60596350'

  final cron = Cron();
  final bot = TelegramBot();

  //bot.sendMessage(message: "bot start successfully");

  // TODO: calculate sma degree and count it isaaa
  // TODO: get chart screenshot

  /// list of calculate sma`s
  List<List<double>> smas = [];
  double sma7 = 0;
  double sma25 = 0;
  double sma99 = 0;

  List<String> tokens = [
    'BTC',
    'SOL',
    'SUI',
    'MOVR',
    'CELR',
    'XRP',
    'ETH',
    'OM',
    'VTHO',
    'TIA',
    'AXL',
    'LDO',
    'AEVO',
    'XVS',
    'FXS',
    'STX',
    'ORDI',
    'ETHFI',
    'LEVER',
    'NFP',
    'PIXEL',
    'MEME',
    'SEI',
    'FET',
    'WOO',
    'PORTAL',
    'CELO',
    'PYTH',
    'JUP',
    'ENJ',
    'ONE',
    'SAND',
    'MANA',
    'ZEN',
    'AXS',
    'VET',
    'FIL',
    'FLOW',
    'COTI',
    'SCRT',
    'UNI',
  ];
  final int lookBack = 2;
  final String tokenConvert = 'USDT';
  final String exchange = 'binance';
  final String candleLimit = '110';
  String timeFrame = '1';
  BotMessageTemplate botMessageTemplate;

  /// daily , hourly or minutly time frame api
  String dhm = 'histohour';

  /// make this event variable because when got error and we want to execute code again we havent the event which got error
  /// in this situation we have the event which got error and we can call that again
  FindSetupCandleEvent event = FindSetupCandleEvent(
    lookBack: lookBack,
    exchange: exchange,
    tokenName: tokens.first,
    tokenConvert: tokenConvert,
    candleLimit: candleLimit,
    timeFrame: '15',
    dhm: 'histominute',
  );

  CandleModelResponse response = CandleModelResponse.initialize();

  final findSetupCandleBloc = FindSetupCandle();
  final calculateSmasBloc = CalculateSmas();
  final chartImageBloc = ChartImageBloc();

  StreamSubscription subscription = findSetupCandleBloc.stream.listen((setupCandleState) async {
    if (setupCandleState is FindSetupCandleIsCompeleted) {
      if (setupCandleState.response.isSetupCandle) {
        response = setupCandleState.response;

        calculateSmasBloc.add(ChangeSmasStateEvent());
        await Future.delayed(Duration(milliseconds: 200));
        calculateSmasBloc.add(CalculateSmasEvent(data: response.response!));
      } else {
        print('Can`t found setup candle\n');
      }
    }

    if (setupCandleState is FindSetupCandleGotError) {
      findSetupCandleBloc.add(event);
      print('error happen when try fetching data ,Error code:${setupCandleState.error} token: ${event.tokenName}');
    }
  });

  /// this section check sma bloc and when calculate sma completed check for setup candle and other things
  StreamSubscription smaSubscription = calculateSmasBloc.stream.listen((smaState) {
    if (smaState is CalculateSmasIsCompeleted) {
      smas = smaState.smas;
      sma7 = smas[0][smas[0].length - lookBack];
      sma25 = smas[1][smas[1].length - lookBack];
      sma99 = smas[2][smas[2].length - lookBack];

      if (response.candleDirection == 'Bullish' && response.high > sma25 && response.high > sma99) {
        print('\\**** find LONG setup candle above sma 25 ****//');
        print('A setup candle found: ${response.open}, ${response.high}, ${response.low}, ${response.close}');
        print('sma 7 - 25 - 99: $sma7 - $sma25 - $sma99');
        print('Token: ${response.tokenName}');
        print('TimeFrame: ${response.dhm == 'histoday' ? 'Daily' : response.dhm == 'histominute' ? '15 Minute' : '${response.timeFrame} Hour'}');
        print('Candle Direction: ${response.candleDirection}');
        print('Candle Color: ${response.candleColor}');
        print('\n');

        botMessageTemplate = BotMessageTemplate(
          tokenName: response.tokenName,
          timeFrame: response.dhm == 'histoday'
              ? 'Daily'
              : response.dhm == 'histominute'
                  ? '15 Minute'
                  : '${response.timeFrame} Hour',
          candle: '${response.candleDirection}  🐂 / ${response.candleColor}',
          signal: '🟩 Long 📈',
        );

        chartImageBloc.add(GetChartImageEvent(
          tokenName: '${response.tokenName}USDT',
          interval: '${response.dhm == 'histoday' ? '1D' : response.dhm == 'histominute' ? '15m' : '${response.timeFrame}h'}',
          botMessage: botMessageTemplate,
        ));
      } else if (response.candleDirection == 'Bearish' && response.low < sma25 && response.low < sma99) {
        print('\\**** find SHORT setup candle under sma 25 ****//');
        print('A setup candle found: ${response.open}, ${response.high}, ${response.low}, ${response.close}');
        print('sma 7 - 25 - 99: $sma7 - $sma25 - $sma99');
        print('Token: ${response.tokenName}');
        print('TimeFrame: ${response.dhm == 'histoday' ? 'Daily' : response.dhm == 'histominute' ? '15 Minute' : '${response.timeFrame} Hour'}');
        print('Candle Direction: ${response.candleDirection}');
        print('Candle Color: ${response.candleColor}');
        print('\n');

        botMessageTemplate = BotMessageTemplate(
          tokenName: response.tokenName,
          timeFrame: response.dhm == 'histoday'
              ? 'Daily'
              : response.dhm == 'histominute'
                  ? '15 Minute'
                  : '${response.timeFrame} Hour',
          candle: '${response.candleDirection}  🐻 / ${response.candleColor}',
          signal: '🟥 Short 📉',
        );

        chartImageBloc.add(GetChartImageEvent(
          tokenName: '${response.tokenName}USDT',
          interval: '${response.dhm == 'histoday' ? '1D' : response.dhm == 'histominute' ? '15m' : '${response.timeFrame}h'}',
          botMessage: botMessageTemplate,
        ));
      } else {
        print('Can`t found setup candle for: ${response.tokenName}\n');
      }

      response = CandleModelResponse.initialize();
    }
  });

  // get chart image if there is setup candle and if i can get chart image send it to bot and if i cant then send a simple message to bot
  StreamSubscription chartImgSubscription = chartImageBloc.stream.listen((chartImgState) {
    if (chartImgState is ChartImageStateIsCompeleted) {
      bot.sendMessage(
        message: chartImgState.botMessage.toString(),
        chartImg: chartImgState.chartImg,
      );
    } else if (chartImgState is ChartImageStateGotError) {
      bot.sendMessage(
        message: chartImgState.botMessage.toString(),
      );
    }
  });

  tokens = [
    'STX',
    // 'UNI',
    // '1INCH',
    // 'LDO',
  ];
  for (String token in tokens) {
    event = FindSetupCandleEvent(
      lookBack: lookBack,
      exchange: exchange,
      tokenName: token,
      tokenConvert: tokenConvert,
      candleLimit: candleLimit,
      timeFrame: '1',
      dhm: dhm,
    );
    findSetupCandleBloc.add(event);
    await Future.delayed(Duration(seconds: 1));
    await waitForStateChange(() => findSetupCandleBloc.state is FindSetupCandleIsCompeleted);
  }

  // Schedule to run every 15 minutes at exact intervals (e.g., 00:15, 00:30, 00:45)
  // cron.schedule(Schedule.parse('*/15 * * * *'), () async {
  //   print('************* 15 minute *************');
  //   bot.sendMessage("15 minutes");
  //   for (String token in tokens) {
  //     event = FindSetupCandleEvent(
  //       lookBack: lookBack,
  //       exchange: exchange,
  //       tokenName: token,
  //       tokenConvert: tokenConvert,
  //       candleLimit: candleLimit,
  //       timeFrame: '15',
  //       dhm: 'histominute',
  //     );
  //     findSetupCandleBloc.add(event);
  //     await Future.delayed(Duration(seconds: 1));
  //     await waitForStateChange(() => findSetupCandleBloc.state is FindSetupCandleIsCompeleted);
  //   }
  // });

  // Schedule to run every hour at exact intervals (e.g., 01:00, 02:00, etc.)
  // cron.schedule(Schedule.parse('0 * * * *'), () async {
  //   print('************* 1 hour *************');
  //   bot.sendMessage("1 HOUR cron job executed");
  //   for (String token in tokens) {
  //     event = FindSetupCandleEvent(
  //       lookBack: lookBack,
  //       exchange: exchange,
  //       tokenName: token,
  //       tokenConvert: tokenConvert,
  //       candleLimit: candleLimit,
  //       timeFrame: timeFrame,
  //       dhm: dhm,
  //     );
  //     findSetupCandleBloc.add(event);
  //     await Future.delayed(Duration(seconds: 1));
  //     await waitForStateChange(() => findSetupCandleBloc.state is FindSetupCandleIsCompeleted);
  //   }
  // });

  // // Schedule to run every 4 hours (e.g., 00:00, 04:00, 08:00, etc.)
  // cron.schedule(Schedule.parse('0 */4 * * *'), () async {
  //   print('************* 4 hour *************');
  //   bot.sendMessage("4 HOUR cron job executed");
  //   for (String token in tokens) {
  //     event = FindSetupCandleEvent(
  //       lookBack: lookBack,
  //       exchange: exchange,
  //       tokenName: token,
  //       tokenConvert: tokenConvert,
  //       candleLimit: candleLimit,
  //       timeFrame: '4',
  //       dhm: dhm,
  //     );
  //     findSetupCandleBloc.add(event);
  //     await Future.delayed(Duration(seconds: 1));
  //     await waitForStateChange(() => findSetupCandleBloc.state is FindSetupCandleIsCompeleted);
  //   }
  // });

  // // Schedule to run once a day at midnight (00:00)
  // cron.schedule(Schedule.parse('0 3 * * *'), () async {
  //   print('************* Daily *************');
  //   bot.sendMessage("DAILY cron job executed");
  //   for (String token in tokens) {
  //     event = FindSetupCandleEvent(
  //       lookBack: lookBack,
  //       exchange: exchange,
  //       tokenName: token,
  //       tokenConvert: tokenConvert,
  //       candleLimit: candleLimit,
  //       timeFrame: timeFrame,
  //       dhm: 'histoday',
  //     );
  //     findSetupCandleBloc.add(event);
  //     await Future.delayed(Duration(seconds: 1));
  //     await waitForStateChange(() => findSetupCandleBloc.state is FindSetupCandleIsCompeleted);
  //   }
  // });

  print('Cron jobs scheduled.');

  print('Server listening on port ${server.port}');

  await subscription.asFuture();
  await smaSubscription.asFuture();
  await chartImgSubscription.asFuture();
}

Future<void> waitForStateChange(bool Function() condition) async {
  while (!condition()) {
    await Future.delayed(Duration(seconds: 1)); // Check every 100ms
  }
}
