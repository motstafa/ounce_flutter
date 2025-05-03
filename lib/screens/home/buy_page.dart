import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ounce/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:ounce/models/operation_model.dart';
import 'package:ounce/providers/operation_provider.dart';
import 'package:ounce/theme/theme.dart';
import 'package:ounce/providers/balance_provider.dart';
import 'package:ounce/providers/notification_provider.dart';
import '../../generated/l10n.dart';
import '../../widgets/unavailable_item_dialog.dart';

class BuyPage extends StatefulWidget {
  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  Timer? _refreshTimer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    final operationProvider = Provider.of<OperationProvider>(context, listen: false);
    final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      operationProvider.loadOperations();
      balanceProvider.callToGetBalance();

      // Start a timer to refresh data every 10 seconds
      _refreshTimer = Timer.periodic(Duration(seconds: 5), (_) {
        if (!_isRefreshing) {
          _refreshData();
        }
      });
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _refreshData() async {
    if (mounted) {
      setState(() {
        _isRefreshing = true;
      });

      try {
        final operationProvider = Provider.of<OperationProvider>(context, listen: false);
        await operationProvider.refreshPage();
      } finally {
        if (mounted) {
          setState(() {
            _isRefreshing = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final operationProvider = Provider.of<OperationProvider>(context, listen: false);
    final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        pageName: S.of(context).buyPageTitle,
        balanceType: 'buy',
      ),
      body: Consumer<BalanceProvider>(
        builder: (context, balanceProvider, child) {
          // Check if balance is insufficient
          if (balanceProvider.buyingBalance <= 0) {
            return Center(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: buttonAccentColor, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.red,
                      size: 60,
                    ),
                    SizedBox(height: 20),
                    Text(
                      S.of(context).insufficientBalanceTitle,
                      style: TextStyle(
                        color: buttonAccentColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Text(
                      S.of(context).purchaseFailedText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Regular content when balance is sufficient
          return RefreshIndicator(
            onRefresh: _refreshData,
            color: buttonAccentColor,
            backgroundColor: Colors.black45,
            child: Stack(
              children: [
                FutureBuilder(
                  future: operationProvider.loadOperations(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${S.of(context).error}: ${snapshot.error}'));
                    } else {
                      return ListView.builder(
                        itemCount: operationProvider.operations.length,
                        itemBuilder: (context, index) {
                          final operation = operationProvider.operations[index];
                          return OperationItem(operation);
                        },
                      );
                    }
                  },
                ),

                // Show a subtle refreshing indicator at the top
                if (_isRefreshing)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6),
                      color: Colors.black54,
                      child: Center(
                        child: Text(
                          S.of(context).refreshing,
                          style: TextStyle(
                            color: buttonAccentColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class OperationItem extends StatelessWidget {
  final Operation operation;
  final TextEditingController _controller = TextEditingController();

  OperationItem(this.operation);

  @override
  Widget build(BuildContext context) {
    String operationNumber = '${S.of(context).operationNumberLabel}: ${Operation.generateBigFakeNumber(operation.id)}';

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: BoxBackground,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: buttonAccentColor),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PurchasePage(operation: operation),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.inventory_2, color: buttonAccentColor),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              '${S.of(context).numberOfOuncesLabel}: ${operation.numberOfUnits}',
                              style: TextStyle(
                                color: buttonAccentColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: buttonAccentColor),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              '${S.of(context).totalPriceLabel}: \$${operation.total}',
                              style: TextStyle(
                                color: buttonAccentColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PurchasePage extends StatefulWidget {
  final Operation operation;

  const PurchasePage({Key? key, required this.operation}) : super(key: key);

  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  bool _isConfirming = false;
  int? calculatedValue = 0;
  int selectedItems = 0;
  bool _deliveryAvailable = false;
  bool _isImageExpanded = false;

  @override
  Widget build(BuildContext context) {
    final balanceProvider = Provider.of<BalanceProvider>(context, listen: false);
    var buyBalance = balanceProvider.buyingBalance;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(_isConfirming ? 'Confirm Delivery' : 'Confirm Purchase'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Adjust layout based on screen size
          final isSmallScreen = constraints.maxWidth < 600;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product Image with responsive sizing
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isImageExpanded = !_isImageExpanded;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: _isImageExpanded
                            ? screenHeight * 0.5
                            : isSmallScreen
                            ? screenHeight * 0.25
                            : screenHeight * 0.3,
                        margin: EdgeInsets.only(bottom: isSmallScreen ? 12.0 : 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[900],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.operation.picOfUnits ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Icon(Icons.image_not_supported,
                                  size: isSmallScreen ? 40 : 50,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Product Details Card - Responsive version
                    Card(
                      color: BoxBackground,
                      margin: EdgeInsets.only(bottom: isSmallScreen ? 12.0 : 16.0),
                      child: Padding(
                        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(3),
                          },
                          children: [
                            _buildTableRow(
                              context,
                              S.of(context).typeOfOuncesLabel,
                              widget.operation.unitType,
                              isSmallScreen,
                            ),
                            _buildTableRowDivider(isSmallScreen),
                            _buildTableRow(
                              context,
                              S.of(context).retailLabel,
                              widget.operation.retail == 1
                                  ? S.of(context).trueLabel
                                  : S.of(context).falseLabel,
                              isSmallScreen,
                            ),
                            _buildTableRowDivider(isSmallScreen),
                            _buildTableRow(
                              context,
                              S.of(context).numberOfOuncesLabel,
                              '${widget.operation.numberOfUnits}',
                              isSmallScreen,
                            ),
                            _buildTableRowDivider(isSmallScreen),
                            _buildTableRow(
                              context,
                              S.of(context).total,
                              '\$${widget.operation.total}',
                              isSmallScreen,
                              valueStyle: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Quantity Selector (only for retail)
                    if (widget.operation.retail == 1)
                      Card(
                        color: BoxBackground,
                        margin: EdgeInsets.only(bottom: isSmallScreen ? 12.0 : 16.0),
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                          child: Column(
                            children: [
                              Text(
                                '${S.of(context).selectQuantity}:',
                                style: TextStyle(
                                  color: buttonAccentColor,
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 12),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 8 : 12,
                                  vertical: isSmallScreen ? 4 : 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    isExpanded: true,
                                    value: selectedItems,
                                    items: [
                                      DropdownMenuItem(
                                        value: 0,
                                        child: Text(
                                          '0',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 14 : 16,
                                          ),
                                        ),
                                      ),
                                      ...List.generate(
                                        widget.operation.numberOfUnits,
                                            (index) => DropdownMenuItem(
                                          value: index + 1,
                                          child: Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 14 : 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        selectedItems = value ?? 0;
                                        calculatedValue = Constants().CalculatePrice(
                                          selectedItems,
                                          widget.operation.unitPrice,
                                        );
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 12),
                              Text(
                                '${S.of(context).total}: \$${calculatedValue ?? 0}',
                                style: TextStyle(
                                  color: buttonAccentColor,
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Spacer to push buttons to bottom on large screens
                    if (!isSmallScreen) Expanded(child: SizedBox()),

                    // Action Buttons
                    if (!_isConfirming)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonAccentColor,
                          padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 14 : 16,
                          ),
                          minimumSize: Size.fromHeight(isSmallScreen ? 48 : 54),
                        ),
                        child: Text(
                          S.of(context).buyButtonText,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                          ),
                        ),
                        onPressed: () async {
                          // For retail items, compare with selectedItems, otherwise compare with numberOfUnits
                          final requiredAmount = widget.operation.retail == 1
                              ? selectedItems
                              : widget.operation.numberOfUnits;

                          if ((buyBalance ?? 0) < requiredAmount) {
                            _showNotEnoughResourcesDialog(context);
                            return;
                          }

                          final operationProvider = Provider.of<OperationProvider>(
                            context,
                            listen: false,
                          );
                          _deliveryAvailable = await operationProvider.checkDeliveries(
                            widget.operation.id,
                          );

                          if (widget.operation.retail == 0 || selectedItems > 0) {
                            setState(() {
                              _isConfirming = true;
                            });
                          }
                        },
                      ),

                    if (_isConfirming) ...[
                      SizedBox(height: isSmallScreen ? 12 : 16),
                      Card(
                        color: BoxBackground,
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                          child: Column(
                            children: [
                              Text(
                                _deliveryAvailable
                                    ? S.of(context).noDelay
                                    : S.of(context).delayed,
                                style: TextStyle(
                                  color: _deliveryAvailable ? Colors.green : Colors.orange,
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: isSmallScreen ? 16 : 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: EdgeInsets.symmetric(
                                          vertical: isSmallScreen ? 12 : 14,
                                        ),
                                      ),
                                      child: Text(
                                        S.of(context).cancel,
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 14 : 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: isSmallScreen ? 12 : 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: EdgeInsets.symmetric(
                                          vertical: isSmallScreen ? 12 : 14,
                                        ),
                                      ),
                                      child: Text(
                                        S.of(context).confirm,
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 14 : 16,
                                        ),
                                      ),
                                      onPressed: () async {
                                        final operationProvider = Provider.of<OperationProvider>(
                                          context,
                                          listen: false,
                                        );
                                        final balanceProvider = Provider.of<BalanceProvider>(
                                          context,
                                          listen: false,
                                        );

                                        // Show a loading indicator
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(buttonAccentColor),
                                              ),
                                            );
                                          },
                                        );

                                        Map<String, dynamic> result = await operationProvider.Buy(
                                          widget.operation.id,
                                          widget.operation.retail == 0
                                              ? widget.operation.numberOfUnits
                                              : selectedItems,
                                        );

                                        // Always dismiss the loading dialog
                                        Navigator.of(context).pop();

                                        if (result['success']) {
                                          await operationProvider.refreshPage();
                                          await balanceProvider.callToGetBalance();
                                          Navigator.of(context).pop(); // Close the purchase page
                                        } else {
                                          // Handle different error codes
                                          String errorMessage = result['message'];

                                          if (result['error_code'] == 'ITEM_UNAVAILABLE') {
                                            // Show item unavailable dialog
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return UnavailableItemDialog(
                                                  message: S.of(context).itemNoLongerAvailable,
                                                  onDismiss: () {
                                                    // Close both dialogs - first the error dialog, then the purchase page
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).pop();
                                                    // Force refresh the product list
                                                    operationProvider.refreshPage();
                                                  },
                                                );
                                              },
                                            );
                                          } else if (result['error_code'] == 'INSUFFICIENT_QUANTITY') {
                                            // Show insufficient quantity dialog with available amount
                                            int availableQuantity = result['data']['available_quantity'] ?? 0;

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(S.of(context).error),
                                                  content: Text(
                                                    '${S.of(context).onlyAvailable}: $availableQuantity ${S.of(context).items}',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        // Update the selected items to the available quantity
                                                        setState(() {
                                                          selectedItems = availableQuantity;
                                                        });
                                                      },
                                                      child: Text(S.of(context).okButtonLabel),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            // Show generic error
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(errorMessage)),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  TableRow _buildTableRow(
      BuildContext context,
      String label,
      String value,
      bool isSmallScreen, {
        TextStyle? valueStyle,
      }) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 8),
          child: Text(
            label,
            style: TextStyle(
              color: buttonAccentColor,
              fontSize: isSmallScreen ? 14 : 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 6 : 8),
          child: Text(
            value,
            style: valueStyle ?? TextStyle(
              color: Colors.grey,
              fontSize: isSmallScreen ? 14 : 16,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRowDivider(bool isSmallScreen) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 6),
          child: Divider(height: 1, color: Colors.grey[700]),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 6),
          child: Divider(height: 1, color: Colors.grey[700]),
        ),
      ],
    );
  }

  void _showNotEnoughResourcesDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).purchaseFailed),
          content: Text(S.of(context).purchaseFailedText),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).okButtonLabel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}