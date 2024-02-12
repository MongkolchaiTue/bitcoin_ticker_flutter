import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    super.initState();

    getData();
    _visiblePicker = true;
  }

  bool _visiblePicker = false;
  String _selectedCurrency = 'USD';
  int _selectedIndex = 19;
  List<String> _cryptoValueInCurrencyList = ['?', '?', '?'];

  getData() async {
    try {
      for (int index = 0; index < cryptoList.length; index++)
        if (_cryptoValueInCurrencyList[index] == '?') {
          double data = await CoinData()
              .getCoinData(cryptoList[index], _selectedCurrency);
          setState(() {
            _cryptoValueInCurrencyList[index] = data.toStringAsFixed(0);
          });
        }
    } catch (e) {
      print(e);
    }
  }

  List<Widget> getCardCryptoValueInCurrency() {
    return List<Widget>.generate(cryptoList.length, (int index) {
      return Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 ${cryptoList[index]} = ${_cryptoValueInCurrencyList[index]} $_selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }

  Widget iOSPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      scrollController: FixedExtentScrollController(
        initialItem: _selectedIndex,
      ),
      onSelectedItemChanged: (selectedIndex) {
        _cryptoValueInCurrencyList = ['?', '?', '?'];
        _selectedIndex = selectedIndex;
        _selectedCurrency = currenciesList[_selectedIndex];
        getData();
      },
      children: List<Widget>.generate(currenciesList.length, (int index) {
        return Text(currenciesList[index]);
      }),
    );
  }

  Widget androidDropdown() {
    return DropdownButton<String>(
      value: _selectedCurrency,
      items: currenciesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        _cryptoValueInCurrencyList = ['?', '?', '?'];
        _selectedCurrency = value ?? '';
        _selectedIndex = currenciesList.indexOf(_selectedCurrency);
        getData();
      },
    );
  }

  Widget getPicker() {
    // print(Platform.operatingSystem); //flutter: ios
    if (Platform.isIOS) {
      return iOSPicker();
    } else {
      //if (Platform.isAndroid) {
      return androidDropdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getCardCryptoValueInCurrency(),
            ),
          ),
          Visibility(
            visible: _visiblePicker,
            child: Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: getPicker(),
            ),
          ),
        ],
      ),
    );
  }
}
