import 'package:flutter/material.dart';
import 'package:pgapp/core/theme/theme.dart';
import 'package:pgapp/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class Privacy extends StatelessWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle title = TextStyle(
      fontFamily: 'Manrope',
      fontSize: 40,
      fontWeight: FontWeight.w600,
      height: 1.2,
      leadingDistribution: TextLeadingDistribution.even,
      color: context.watch<ThemeProvider>().colorMode.onSurface,
    );
    final TextStyle subtitle = TextStyle(
      fontFamily: 'Manrope',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
      color: context.watch<ThemeProvider>().colorMode.onSurface,
    );
    final TextStyle heading = TextStyle(
      fontFamily: 'Manrope',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 2.2,
      leadingDistribution: TextLeadingDistribution.even,
      color: context.watch<ThemeProvider>().colorMode.onSurface,
    );
    final TextStyle body = TextStyle(
      fontFamily: 'Manrope',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.6,
      leadingDistribution: TextLeadingDistribution.even,
      color: context.watch<ThemeProvider>().colorMode.onSurface,
    );

    const padding = SizedBox(height: 16);
    final double margin =
        MediaQuery.of(context).size.width > MyDimensions.mobile ? 40 : 0;
    final double boxPadding =
        MediaQuery.of(context).size.width > MyDimensions.mobile ? 40 : 20;
    final double radius =
        MediaQuery.of(context).size.width > MyDimensions.mobile ? 40 : 0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            decoration: BoxDecoration(
                gradient: MyThemes.backgroundGradient(
                    context.watch<ThemeProvider>().isDarkMode)),
            child: SafeArea(
                bottom: false,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(margin),
                    padding: EdgeInsets.all(boxPadding),
                    constraints: const BoxConstraints(maxWidth: 1080),
                    // width: 680,
                    decoration: BoxDecoration(
                      color: context.watch<ThemeProvider>().colorMode.surface,
                      borderRadius: BorderRadius.circular(radius),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Privacy Policy', style: title),
                        Text('Last updated on 30/05/2022', style: subtitle),
                        padding,
                        Text(
                            'The PGApp is a free app. This service is provided at no cost and is intended for use as is.',
                            style: body),
                        padding,
                        Text(
                            'This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use PGApp.',
                            style: body),
                        padding,
                        Text(
                            '''If you choose to use PGApp, then you agree to the described provisions in relation to this policy. PGApp doesn't collect any personal Information, and as a consequence doesn’t use or share your information with anyone.''',
                            style: body),
                        padding,
                        Text('Information Collection and Use', style: heading),
                        padding,
                        Text(
                            'PGApp doesn’t use network connection, and works entirely in offline mode. The app doesn’t collect any personally identifiable information. The app does use third party services that may collect information used to identify you.',
                            style: body),
                        padding,
                        Text('Changes to This Privacy Policy', style: heading),
                        padding,
                        Text(
                            'Twelvedevs may update this Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. When we post changes to this statement, we will revise the "last updated" date at the top of the statement. These changes are effective immediately after they are posted on this page.',
                            style: body),
                        padding,
                        Text('Contact Us', style: heading),
                        padding,
                        Text(
                            'If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us.',
                            style: body),
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }
}
