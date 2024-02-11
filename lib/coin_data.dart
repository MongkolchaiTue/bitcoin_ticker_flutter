import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

// curl -L -X GET 'https://rest.coinapi.io/v1/exchangerate/:asset_id_base/:asset_id_quote' \
// -H 'Accept: text/json' \
// -H 'X-CoinAPI-Key: <API_KEY_VALUE>'

late String? coinApiURL;
late String? coinApiKey;
late dynamic? coinDataJson;

class CoinData {

  Future<dynamic> getCoinData(String cryptoName,String currency) async {
    await dotenv.load();
    coinApiURL = dotenv.env['CoinApiURL'];
    coinApiKey = dotenv.env['CoinApiKey'];

    if (coinApiURL != null && coinApiKey != null) {
      String requestURL = '$coinApiURL/$cryptoName/$currency?apikey=$coinApiKey';
      final httpResponse = await http.get(Uri.parse(requestURL));
      if (httpResponse.statusCode == 200) {
        coinDataJson = jsonDecode(httpResponse.body) as Map<String, dynamic>;

        print(coinDataJson);

        var lastPrice = coinDataJson['rate'];
        return lastPrice;
      }

      print(httpResponse.statusCode);
      throw 'Failed to retrieve the get request! code${httpResponse.statusCode}';
    }

    print('Failed to retrieve the URL!');
    throw 'Failed to retrieve the URL!';

  }
}
