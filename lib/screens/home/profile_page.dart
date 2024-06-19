import 'package:flutter/material.dart';
import 'package:ounce/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:ounce/models/user_model.dart';
import 'package:ounce/providers/auth_provider.dart';
import '../../generated/l10n.dart';
import '../../providers/local_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AuthProvider authProvider =
      Provider.of<AuthProvider>(context, listen: false);
      bool success = await authProvider.getUser();
      if (success) {
        setState(() {
          user = authProvider.user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text(S.of(context).profile),
        actions: [
          LanguageSwitcher(),
        ],
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (user?.profilePhotoUrl != null)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user!.profilePhotoUrl!),
                ),
              ),
            SizedBox(height: 20),
            UserInfoTile(
              label: S.of(context).name,
              value: user?.name ?? 'N/A',
            ),
            UserInfoTile(
              label: S.of(context).email,
              value: user?.email ?? 'N/A',
            ),
            UserInfoTile(
              label: S.of(context).username,
              value: user?.username ?? 'N/A',
            ),
            // Add more UserInfoTile widgets as needed
          ],
        ),
      ),
    );
  }
}


class UserInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocaleProvider localeProvider = Provider.of<LocaleProvider>(context);

    return DropdownButton<Locale>(
      value: localeProvider.locale,
      icon: Icon(Icons.language,color: buttonAccentColor,),
      padding:const EdgeInsets.only(left: 17),
      items: const [
        DropdownMenuItem(
          child: Text('English'),
          value: Locale('en'),
        ),
        DropdownMenuItem(
          child: Text('العربية'),
          value: Locale('ar'),
        ),
      ],
      onChanged: (Locale? locale) {
        if (locale != null) {
          localeProvider.setLocale(locale);
        }
      },
    );
  }
}
