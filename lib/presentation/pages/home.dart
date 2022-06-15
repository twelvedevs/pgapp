import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pgapp/core/extensions/extensions.dart';
import 'package:pgapp/core/theme/theme.dart';
import 'package:pgapp/domain/entities/password_constants.dart';
import 'package:pgapp/domain/entities/password_template.dart';
import 'package:pgapp/presentation/providers/password_provider.dart';
import 'package:pgapp/presentation/providers/theme_provider.dart';
import 'package:pgapp/presentation/widgets/group_buttons.dart';
import 'package:pgapp/presentation/widgets/incrementer.dart';
import 'package:pgapp/presentation/widgets/input.dart';
import 'package:pgapp/presentation/widgets/separator.dart';
import 'package:pgapp/presentation/widgets/slider.dart';
import 'package:pgapp/presentation/widgets/swich.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Widget futureBuilder(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          context.read<PasswordProvider>().getDictionary(context),
          context.read<PasswordProvider>().getTemplate(),
        ]),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                  child: CircularProgressIndicator(
                color: context.watch<ThemeProvider>().colorMode.onInput,
              )),
            );
          }

          PasswordTemplate passwordTemplate =
              snapshot.data?[1] ?? PasswordTemplate();

          return _Page(template: passwordTemplate);
        });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimens) {
        final bool isMobile = dimens.maxWidth < MyDimensions.mobile;

        final container = AnimatedContainer(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            duration: MyThemes.duration,
            decoration: BoxDecoration(
                gradient: MyThemes.backgroundGradient(
                    context.watch<ThemeProvider>().isDarkMode)),
            child: SafeArea(bottom: false, child: futureBuilder(context)));

        if (isMobile) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: container,
          );
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: container,
          ),
        );
      },
    );
  }
}

class _Page extends StatefulWidget {
  final PasswordTemplate template;

  const _Page({Key? key, required this.template}) : super(key: key);

  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> {
  late PasswordTemplate passwordTemplate;

  @override
  void initState() {
    super.initState();
    passwordTemplate = widget.template;
    _generate(false);
  }

  _generate([bool withNotify = true]) {
    try {
      context
          .read<PasswordProvider>()
          .generate(passwordTemplate, passwordTemplate.md5, withNotify);
    } catch (e) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Generator Error'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      // throw Exception(e);
    }
  }

  Widget lengthSlider() => CustomSlider(
        label: 'Length:',
        value: passwordTemplate.passwordLength.toDouble(),
        onChanged: (value) {
          passwordTemplate.passwordLength = value.round();
          _generate();
        },
        min: PasswordConstants.min.toDouble(),
        max: PasswordConstants.max.toDouble(),
      );

  Widget numberIncrementer() => Incrementer(
      label: 'Numbers: ',
      value: passwordTemplate.numberLength,
      min: -1,
      max: PasswordConstants.max,
      increaseDisabled: passwordTemplate.requiredPartLength(
              passwordTemplate.numberLength + 1,
              passwordTemplate.symbolLength,
              passwordTemplate.wordLength) >
          PasswordConstants.max,
      onIncrease: (value) {
        passwordTemplate.numberLength = value;
        _generate();
      },
      onDecrease: (value) {
        passwordTemplate.numberLength = value;
        _generate();
      });

  Widget symbolIncrementer() => Incrementer(
      label: 'Symbols: ',
      value: passwordTemplate.symbolLength,
      min: -1,
      max: PasswordConstants.max,
      increaseDisabled: passwordTemplate.requiredPartLength(
              passwordTemplate.numberLength,
              passwordTemplate.symbolLength + 1,
              passwordTemplate.wordLength) >
          PasswordConstants.max,
      onIncrease: (value) {
        passwordTemplate.symbolLength = value;
        _generate();
      },
      onDecrease: (value) {
        passwordTemplate.symbolLength = value;
        _generate();
      });

  Widget wordIncrementer() => Incrementer(
      label: 'Words: ',
      value: passwordTemplate.wordLength,
      min: 0,
      max: PasswordConstants.max ~/ PasswordConstants.min,
      increaseDisabled: passwordTemplate.requiredPartLength(
              passwordTemplate.numberLength,
              passwordTemplate.symbolLength,
              passwordTemplate.wordLength + 1) >
          PasswordConstants.max,
      onIncrease: (value) {
        passwordTemplate.wordLength = value;
        _generate();
      },
      onDecrease: (value) {
        passwordTemplate.wordLength = value;
        _generate();
      });

  Widget md5() => GroupButtons(
        label: 'Md5:',
        data: [
          RadioModel(!passwordTemplate.md5, 'Off'),
          RadioModel(passwordTemplate.md5, 'On')
        ],
        onSelect: (value) {
          passwordTemplate.md5 = value.label == 'On' && value.isSelected;
          context.read<PasswordProvider>().onMd5();
        },
      );

  Widget letterCase() => GroupButtons(
        label: 'Letter case:',
        data: List.generate(
            LetterCase.values.length,
            (index) => RadioModel(
                passwordTemplate.letterCase == LetterCase.values[index],
                LetterCase.values[index].name.capitalize())).toList(),
        onSelect: (value) {
          passwordTemplate.letterCase =
              LetterCase.values.byName(value.label.toLowerCase());
          _generate();
        },
      );

  Widget separator() => Separator(
      label: 'Separator: ',
      value: passwordTemplate.separator,
      disabled: passwordTemplate.wordLength < 2,
      onChange: (symbol) {
        passwordTemplate.separator = symbol;
        _generate();
      });

  Widget progressStatus() => ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: LinearProgressIndicator(
          color: context
              .watch<ThemeProvider>()
              .colorMode
              .getColorByStatus(context.watch<PasswordProvider>().status),
          backgroundColor:
              context.watch<ThemeProvider>().colorMode.progressBackground,
          minHeight: 2,
          value: context.watch<PasswordProvider>().score,
          semanticsLabel: 'Password Strength checker',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimens) {
        final bool isMobile = dimens.maxWidth < MyDimensions.mobile;

        if (isMobile) {
          return mobileLayout();
        }

        return Center(
          child: desktopLayout(),
        );
      },
    );
  }

  Widget mobileLayout() => Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: LiteRollingSwitch(
                      value: !context.watch<ThemeProvider>().isDarkMode,
                      iconOnAssetName: 'assets/icons/sun.svg',
                      iconOffAssetName: 'assets/icons/moon.svg',
                      onChanged: (value) {
                        context.read<ThemeProvider>().toggleTheme(!value);
                      }),
                ),
                const SizedBox(height: 24),
                AnimatedDefaultTextStyle(
                  duration: MyThemes.duration,
                  style: Theme.of(context).textTheme.headline2!,
                  child: const Text('PGApp'),
                ),
                const SizedBox(height: 8),
                AnimatedDefaultTextStyle(
                  duration: MyThemes.duration,
                  style: Theme.of(context).textTheme.headline4!,
                  child: const Text('Generate a secure password'),
                ),
                const SizedBox(height: 24),
                Password(
                    password: context.watch<PasswordProvider>().password,
                    onUpdate: () => _generate()),
                AnimatedCrossFade(
                    crossFadeState: passwordTemplate.md5
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: MyThemes.duration,
                    firstCurve: Curves.easeInCirc,
                    secondCurve: Curves.easeInCirc,
                    firstChild: const SizedBox(height: 8),
                    secondChild: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Password(
                          password: context.watch<PasswordProvider>().md5),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: progressStatus(),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            decoration: BoxDecoration(
                color: context.watch<ThemeProvider>().colorMode.surfaceMobile,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                )),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  lengthSlider(),
                  const SizedBox(height: 16),
                  letterCase(),
                  const SizedBox(height: 16),
                  MediaQuery.of(context).size.width > 300
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: numberIncrementer(),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: symbolIncrementer(),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            numberIncrementer(),
                            const SizedBox(height: 16),
                            symbolIncrementer(),
                          ],
                        ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: wordIncrementer(),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: md5(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  separator(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ))
        ],
      );

  Widget desktopLayout() => Container(
        margin: const EdgeInsets.symmetric(vertical: 40),
        width: 680,
        decoration: BoxDecoration(
          color: context.watch<ThemeProvider>().colorMode.background,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.centerRight,
                    child: LiteRollingSwitch(
                        value: !context.watch<ThemeProvider>().isDarkMode,
                        iconOnAssetName: 'assets/icons/sun.svg',
                        iconOffAssetName: 'assets/icons/moon.svg',
                        onChanged: (value) {
                          context.read<ThemeProvider>().toggleTheme(!value);
                        }),
                  ),
                  const SizedBox(height: 40),
                  AnimatedDefaultTextStyle(
                    duration: MyThemes.duration,
                    style: Theme.of(context).textTheme.headline1!,
                    child: const Text('PGApp'),
                  ),
                  const SizedBox(height: 8),
                  AnimatedDefaultTextStyle(
                    duration: MyThemes.duration,
                    style: Theme.of(context).textTheme.headline3!,
                    child: const Text('Generate a secure password'),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Password(
                        password: context.watch<PasswordProvider>().password,
                        onUpdate: () => _generate()),
                  ),
                  AnimatedCrossFade(
                      crossFadeState: passwordTemplate.md5
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: MyThemes.duration,
                      firstCurve: Curves.easeInCirc,
                      secondCurve: Curves.easeInCirc,
                      firstChild: const SizedBox(height: 12),
                      secondChild: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 40),
                        child: Password(
                            password: context.watch<PasswordProvider>().md5),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16 + 40),
                    child: progressStatus(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 32),
              decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().colorMode.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  )),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        lengthSlider(),
                        const SizedBox(height: 24),
                        letterCase(),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: numberIncrementer(),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: symbolIncrementer(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: wordIncrementer(),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: md5(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        separator(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  if (kIsWeb)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 24),
                      child: Row(
                        children: [
                          TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/privacy');
                              },
                              child: Text('Privacy Policy',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    height: 1.36,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                    color: context
                                        .watch<ThemeProvider>()
                                        .colorMode
                                        .onSurface,
                                  ))),
                          const Expanded(child: SizedBox()),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Text('© 2022 Twelvedevs',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    height: 1.36,
                                    leadingDistribution:
                                        TextLeadingDistribution.even,
                                    color: context
                                        .watch<ThemeProvider>()
                                        .colorMode
                                        .onSurface,
                                  ))),
                        ],
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      );
}
