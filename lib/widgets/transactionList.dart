import '../widgets/transaction_Item.dart';
import '../models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No Transactions added yet !',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      ))
                ],
              );
            },
          )
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      transaction: tx,
                      deleteTx: deleteTx,
                    ))
                .toList(),
            // itemBuilder: (ctx, index) {
            //   return TransactionItem(transaction: transactions[index], deleteTx: deleteTx);
            // },
            // itemCount: transactions.length,

            //alternative
            // return Card(
            //   child: Row(
            //     children: <Widget>[
            //       Container(
            //         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            //         decoration: BoxDecoration(
            //           border: Border.all(color: Theme.of(context).primaryColor, width: 2),
            //         ),
            //         padding: EdgeInsets.all(10),
            //         child: Text(
            //           'INR ${transactions[index].amount.toStringAsFixed(2)}',
            //           style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 20,
            //               color: Theme.of(context).primaryColor),
            //         ),
            //       ),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Text(transactions[index].title,
            //               style: Theme.of(context).textTheme.headline6),
            //           Text(DateFormat.yMMMd().format(transactions[index].date),
            //               style:
            //                   TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold))
            //         ],
            //       ),
            //     ],
            //   ),
            // );
          );
  }
}

// children: transactions.map((tx) {}).toList(),
