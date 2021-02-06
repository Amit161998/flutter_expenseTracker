import 'dart:math';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key, //Every Widget can have a key //espcially stateless widget dont need a key
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;
  @override
  void initState() {
    const availableColors = [Colors.red, Colors.black, Colors.blue, Colors.purple];
    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5), //top bottom left right
      child: ListTile(
        leading: CircleAvatar(
          //Circle Avatar to disp amt
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(child: Text('Rs ${widget.transaction.amount.toStringAsFixed(1)}')),
          ),
        ),
        title: Text(widget.transaction.title, style: Theme.of(context).textTheme.headline6),
        subtitle: Text(DateFormat.yMMMd().format(widget.transaction.date)),
        trailing: MediaQuery.of(context).size.width > 360
            ? FlatButton.icon(
                textColor: Theme.of(context).errorColor,
                label: Text('Delete'),
                icon: Icon(Icons.delete),
                onPressed: () => widget.deleteTx(widget.transaction.id))
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTx(widget.transaction.id),
              ),
      ),
    );
  }
}
