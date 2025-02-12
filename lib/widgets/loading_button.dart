import 'package:flutter/material.dart';
import 'package:ounce/theme/theme.dart';

class LoadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.only(top: 30),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(
                  primaryTextColor,
                ),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            const Text(
              'Loading',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal, // Use FontWeight.normal for a standard style
                color: Colors.black, // Set the color if required
              ),
            ),
          ],
        ),
      ),
    );
  }
}
