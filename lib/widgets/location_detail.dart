import 'package:flutter/material.dart';
import 'package:ounce/theme/theme.dart';
import '../generated/l10n.dart';
import '../models/address_model.dart';

class LocationDetail extends StatelessWidget {
  final Address address;
  final Location;

  const LocationDetail({
    super.key,
    this.Location,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (Location == "buyer") Icon(Icons.arrow_back,color: buttonAccentColor,),
              Text(
                Location == 'seller'
                    ? S.of(context).sellerLocation
                    : S.of(context).buyerLocation,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              if (Location == 'seller') Icon(Icons.arrow_forward,color:buttonAccentColor,),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            // Align items to the start of the cross axis
            children: [
              Text('${S.of(context).nameLabel}: ${address.fullName}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${S.of(context).phone}: ${address.phone}'),
            ],
          ),
          // Add a SizedBox for consistent spacing between rows
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            // Align items to the start of the cross axis
            children: [
              Text('${S.of(context).prefecture}: ${address.prefecture}'),
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              // Align items to the start of the cross axis
              children: [Text('${S.of(context).city}: ${address.cityTown}')]),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${S.of(context).wardLabel}: ${address.ward}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${S.of(context).streetAddressLabel}: ${address.streetAdress}'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${S.of(context).buildingLabel}: ${address.building}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${S.of(context).floorLabel}: ${address.floor}'),
            ],
          ),
        ],
      ),
    );
  }
}
