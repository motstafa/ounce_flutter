import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screens/signin_screen.dart';
import '/screens/signup_screen.dart';
import '/theme/theme.dart';
import '/widgets/custom_scaffold.dart';
import '/widgets/welcome_button.dart';
import '../providers/local_provider.dart';
import '../generated/l10n.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    return CustomScaffold(
      child: Column(
        children: [
          // Language switcher at the top right
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 16.0),
              child: _buildLanguageSwitcher(context, localeProvider, isArabic),
            ),
          ),
          Flexible(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${S.of(context).welcomeToOunce}\n',
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w600,
                          color: buttonFocusedColor,
                        ),
                      ),
                      TextSpan(
                        text: '\n${S.of(context).welcomePlatformDesc}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButton(
                      buttonText: S.of(context).signin,
                      onTap: const SignInScreen(),
                      color: Colors.transparent,
                      textColor: buttonAccentColor,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: S.of(context).signUp,
                      onTap: const SignUpScreen(),
                      color: buttonAccentColor,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSwitcher(
      BuildContext context,
      LocaleProvider localeProvider,
      bool isArabic,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: GoldInBetween.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context,
              'English',
              !isArabic,
                  () => localeProvider.setLocale(const Locale('en')),
            ),
            const SizedBox(width: 12),
            Container(
              height: 20,
              width: 1,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(width: 12),
            _buildLanguageOption(
              context,
              'العربية',
              isArabic,
                  () => localeProvider.setLocale(const Locale('ar')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context,
      String language,
      bool isSelected,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        language,
        style: TextStyle(
          color: isSelected ? GoldInBetween : Colors.white.withOpacity(0.7),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}