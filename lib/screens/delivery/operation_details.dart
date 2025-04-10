import 'package:flutter/material.dart';
import 'package:ounce/models/pending_operation_model.dart';
import 'package:ounce/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:ounce/providers/operation_tracks_provider.dart';
import '../../generated/l10n.dart';
import '../../widgets/location_detail.dart';

class OperationDetails extends StatefulWidget {
  final PendingOperation item;
  final Widget formSection;

  const OperationDetails(
      {super.key, required this.item, required this.formSection});

  @override
  _OperationDetailsState createState() => _OperationDetailsState();
}

class _OperationDetailsState extends State<OperationDetails> {
  TextEditingController timeTobuyerController = TextEditingController();
  TextEditingController timeToSellerController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    timeToSellerController.dispose();
    timeTobuyerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).deliveryDetailsTitle),
        backgroundColor: BoxBackground,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SectionHeader(numberOfUnits: widget.item.numberOfUnits, amount: widget.item.amount),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 300, // Set a fixed height
                child: PageView(
                  children: [
                    LocationDetail(
                        Location: 'seller', address: widget.item.sellerAddress),
                    LocationDetail(
                        Location: 'buyer', address: widget.item.buyerAddress),
                  ],
                ),
              ),
            ),
            widget.formSection,
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final int numberOfUnits;
  final int amount;

  const SectionHeader({Key? key, required this.numberOfUnits, required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: "${S.of(context).numberOfUnitsLabel} ",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "$numberOfUnits",
                style: TextStyle(
                    color: Colors.red, fontSize: 45),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        RichText(
          text: TextSpan(
            text: "${S.of(context).amount} ",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "\$$amount",
                style: TextStyle(
                    color: Colors.green, fontSize: 45),
              ),
            ],
          ),
        ),
      ],
    );
  }
}