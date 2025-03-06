import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ounce/models/operation_model.dart';
import 'package:ounce/providers/operation_provider.dart';
import 'package:ounce/theme/theme.dart';
import '../../generated/l10n.dart';
import '../../services/operation_service.dart';

class SellerProducts extends StatefulWidget {
  @override
  _SellerProductsState createState() => _SellerProductsState();
}

class _SellerProductsState extends State<SellerProducts> {
  late Future<Operation?> _sellerOperationFuture;

  @override
  void initState() {
    super.initState();
    final operationProvider =
        Provider.of<OperationProvider>(context, listen: false);
    _sellerOperationFuture = operationProvider
        .loadSellerOperations()
        .then((_) => operationProvider.sellerOperation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text(S.of(context).selledItem),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Consumer<OperationProvider>(
        builder: (context, operationProvider, child) {
          return FutureBuilder(
            future: _sellerOperationFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${S.of(context).error}: ${snapshot.error}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                );
              } else {
                final operation = operationProvider.sellerOperation;

                if (operation == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.remove_shopping_cart,
                            color: Colors.grey, size: 50),
                        SizedBox(height: 10),
                        Text(
                          S.of(context).NoListingYet,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return OperationItem(operation, operationProvider,
                        onDelete: () {
                      // This will trigger a rebuild of the widget
                      setState(() {});
                    });
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}

class OperationItem extends StatelessWidget {
  final Operation? operation;
  final OperationProvider provider;
  final VoidCallback? onDelete;

  OperationItem(this.operation, this.provider, {this.onDelete});

  void _deleteOperation(BuildContext context, int operationId) async {
    try {
      await OperationService().deleteOperation(operationId);
      provider.loadSellerOperations(); // Refresh seller operations

      // Call the onDelete callback if provided
      if (onDelete != null) {
        onDelete!();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${S.of(context).error}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: BoxBackground,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: buttonAccentColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.inventory_2, color: buttonAccentColor),
                  SizedBox(width: 8.0),
                  Text(
                    '${S.of(context).numberOfOuncesLabel}: ${operation?.numberOfUnits}',
                    style: TextStyle(
                      color: buttonAccentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  if (operation?.id != null) {
                    _deleteOperation(context, operation!.id);
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.attach_money, color: buttonAccentColor),
              SizedBox(width: 8.0),
              Text(
                '${S.of(context).totalPriceLabel}: \$${operation?.total}',
                style: TextStyle(
                  color: buttonAccentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
