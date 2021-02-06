// import 'package:flutter/services.dart';
import 'dart:io';
import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'models/transaction.dart';
import 'widgets/chart.dart';
import 'widgets/transactionList.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();  //Configs to setup for showing app in landscape or potrait mode
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(MyApp()); //starts running the app from here
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Loads the main UI rendering
      title: 'Personal Expenses',
      theme: ThemeData(
        // this is the globally assigned theme data
        //Globally assigned theme for the app
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            button: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
          //Particular theme applied to app bar of app
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
              )),
        ),
        primarySwatch: Colors.purple, //Primary swatch gives shades to flutter app
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        errorColor: Colors.red,
      ),
      home: MyHomePage(), //homepage extending here to display all data
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = []; //user transactions pushed here
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        //loading the dates todays and before today
        Duration(days: 7),
      ));
    }).toList(); // converting into the list format
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    // function to add new transactions
    final newTx = Transaction(
        title: txTitle, amount: txAmount, date: chosenDate, id: DateTime.now().toString());
    //Transaction model been used to pass the data and set the state for stateful widget
    setState(() {
      _userTransactions.add(newTx); //private class method
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    // USed this for floatter button
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewTransaction(_addNewTransaction), // returning the new tx component
            behavior: HitTestBehavior.opaque,
          ); //Need to show in modal sheet
        });
  }

  void _deleteTransaction(String id) {
    //passing the id to be deleted
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Show Chart'),
          Switch.adaptive(
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      ),
      _showChart
          ? Container(
              height:
                  (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) *
                      0.7,
              child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
          height:
              (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.3,
          child: Chart(_recentTransactions)),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(title: Text('Personal Expenses'), actions: <Widget>[
      IconButton(
        // adding + icon to the app bar
        icon: Icon(Icons.add),
        onPressed: () =>
            _startAddNewTransaction(context), //onpressing it will open the bottom app  //
      )
    ]);
    final txListWidget = Container(
        height:
            (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    return Scaffold(
      //Main thing to contain an app
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
            //column takees the width depending on child
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (isLandscape) ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
              if (!isLandscape) ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
            ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, //location of button
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              //floating button when pressed
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
    );
  }
}
