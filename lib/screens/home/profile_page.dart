import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../theme/theme.dart';
import '../../providers/local_provider.dart';
import '../signin_screen.dart';

// Existing UserInfoTile widget
class UserInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const UserInfoTile({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

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

// Existing LanguageSwitcher widget
class LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocaleProvider localeProvider = Provider.of<LocaleProvider>(context);

    return DropdownButton<Locale>(
      value: localeProvider.locale,
      icon: Icon(Icons.language, color: buttonAccentColor),
      padding: const EdgeInsets.only(left: 17),
      items: const [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: Locale('ar'),
          child: Text('العربية'),
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

// Account Deletion Confirmation Dialog
class AccountDeletionConfirmationDialog extends StatefulWidget {
  final VoidCallback onConfirmDeletion;
  final VoidCallback onCancel;

  const AccountDeletionConfirmationDialog({
    Key? key,
    required this.onConfirmDeletion,
    required this.onCancel,
  }) : super(key: key);

  @override
  _AccountDeletionConfirmationDialogState createState() =>
      _AccountDeletionConfirmationDialogState();
}

class _AccountDeletionConfirmationDialogState
    extends State<AccountDeletionConfirmationDialog> {
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          S.of(context).deleteAccount,
          style: TextStyle(color: Colors.red)
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).deleteAccountConfirmation,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: S.of(context).password,
              suffixIcon: IconButton(
                icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              errorText: _errorMessage,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(S.of(context).cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: _verifyAndDelete,
          child: Text(S.of(context).delete),
        ),
      ],
    );
  }

  void _verifyAndDelete() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final password = _passwordController.text.trim();

    if (password.isEmpty) {
      setState(() {
        _errorMessage = S.of(context).passwordRequired;
      });
      return;
    }

    try {
      bool isPasswordValid = await authProvider.verifyPassword(password);

      if (isPasswordValid) {
        widget.onConfirmDeletion();
      } else {
        setState(() {
          _errorMessage = S.of(context).incorrectPassword;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = S.of(context).errorVerifyingPassword;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}

// Delete Account Button Widget
class DeleteAccountButton extends StatelessWidget {
  final VoidCallback onDeleteAccount;

  const DeleteAccountButton({
    Key? key,
    required this.onDeleteAccount
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onDeleteAccount,
        child: Text(
          S.of(context).deleteAccount,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Updated ProfilePage with Account Deletion
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success = await authProvider.getUser();

      if (success && mounted) {
        setState(() {
          user = authProvider.user;
        });
      }
    });
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AccountDeletionConfirmationDialog(
        onConfirmDeletion: _deleteAccount,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _deleteAccount() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      bool deleted = await authProvider.deleteAccount();

      if (deleted) {
        // Navigate to login or welcome screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).accountDeletedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).errorDeletingAccount),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).errorDeletingAccount),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          : ListView(
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
          SizedBox(height: 20),
          DeleteAccountButton(
            onDeleteAccount: _showDeleteAccountConfirmation,
          ),
        ],
      ),
    );
  }
}