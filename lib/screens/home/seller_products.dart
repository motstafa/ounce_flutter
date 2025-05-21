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
  late Future<List<Operation>> _sellerOperationsFuture;
  bool _isRefreshing = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadSellerOperations();
  }

  Future<void> _loadSellerOperations() async {
    setState(() {
      _isRefreshing = true;
      _sellerOperationsFuture = _fetchSellerOperations();
    });

    await _sellerOperationsFuture;

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  Future<List<Operation>> _fetchSellerOperations() async {
    final operationProvider = Provider.of<OperationProvider>(context, listen: false);
    await operationProvider.loadSellerOperations();
    return operationProvider.sellerOperations;
  }

  // New function to handle deletion in the parent widget
  Future<void> _handleDelete(Operation operation) async {
    // First show confirmation dialog
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Confirm Deletion',
          style: TextStyle(color: buttonAccentColor),
        ),
        content: Text(
          'Are you sure you want to delete this item?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );

    // If user cancels, do nothing
    if (confirmed != true) return;

    // Show the deleting state
    setState(() {
      _isDeleting = true;
    });

    try {
      // Call the delete API
      bool success = await OperationService().deleteOperation(operation.id);

      if (mounted) {
        // Show appropriate message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success ? 'Item deleted successfully' : 'Failed to delete item. Please try again.',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            duration: Duration(seconds: 2),
          ),
        );

        // Reload operations if deletion was successful
        if (success) {
          await _loadSellerOperations();
        }
      }
    } catch (e) {
      print("Error during delete: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      // Always reset the deleting state
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
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
        actions: [
          // Add refresh button
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (_isRefreshing || _isDeleting) ? null : _loadSellerOperations,
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _loadSellerOperations,
            color: buttonAccentColor,
            child: FutureBuilder<List<Operation>>(
              future: _sellerOperationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || _isRefreshing) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${S.of(context).error}: ${snapshot.error}',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                } else {
                  final operations = snapshot.data;

                  if (operations == null || operations.isEmpty) {
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
                    itemCount: operations.length,
                    itemBuilder: (context, index) {
                      return ModifiedOperationItem(
                        operation: operations[index],
                        onDeleteTap: _handleDelete,
                      );
                    },
                  );
                }
              },
            ),
          ),

          // Loading overlay
          if (_isDeleting)
            Container(
              color: Colors.black.withOpacity(0.7),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(buttonAccentColor),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Deleting...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Modified operation item that doesn't handle deletion on its own
class ModifiedOperationItem extends StatelessWidget {
  final Operation operation;
  final Function(Operation) onDeleteTap;

  const ModifiedOperationItem({
    Key? key,
    required this.operation,
    required this.onDeleteTap,
  }) : super(key: key);

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
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              operation.picOfUnits ?? '',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[800],
                child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 12),

          // Product details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.inventory_2, color: buttonAccentColor),
                  SizedBox(width: 8.0),
                  Text(
                    '${S.of(context).numberOfOuncesLabel}: ${operation.numberOfUnits}',
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
                onPressed: () => onDeleteTap(operation),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.sell, color: buttonAccentColor),
              SizedBox(width: 8.0),
              Text(
                '${S.of(context).unitPriceLabel}: \$${operation.unitPrice}',
                style: TextStyle(
                  color: buttonAccentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              SizedBox(width: 8.0),
              Text(
                '${S.of(context).totalPriceLabel}: \$${operation.total}',
                style: TextStyle(
                  color: buttonAccentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.calendar_today, color: buttonAccentColor),
              SizedBox(width: 8.0),
              Text(
                'Date: ${operation.dateOfOperation}',
                style: TextStyle(
                  color: buttonAccentColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}