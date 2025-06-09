import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mozgalica/resources/configurations/variables.dart';
import 'package:mozgalica/l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.onThemeToggled,
    required this.onLocaleChanged,
    required this.onAnimationDurationChanged,
    required this.presetValues,
  });

  // razni callback-ovi
  final VoidCallback onThemeToggled;
  final void Function(String) onLocaleChanged;
  final void Function(Duration) onAnimationDurationChanged;

  // radi app runtime perzistencije izmedju navigacije, za postavljanje initialSelection
  final Map<String, Object?> presetValues;

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool darkThemeSelected = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.darkThemeSelected,
                style: TextStyle(fontSize: 18.0),
              ),
              Switch(
                value: darkThemeSelected,
                dragStartBehavior: DragStartBehavior.down,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (_) {
                  setState(() {
                    darkThemeSelected = !darkThemeSelected;
                    widget.onThemeToggled();
                  });
                },
              ),
            ],
          ),
        ),

        const Divider(),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.selectedLanguage,
                style: TextStyle(fontSize: 18.0),
              ),
              DropdownMenu(
                initialSelection: AppLocalizations.of(context)!.localeName,
                leadingIcon: const Icon(Icons.language),
                dropdownMenuEntries: <DropdownMenuEntry>[
                  DropdownMenuEntry(
                    value: 'en',
                    label: AppLocalizations.of(context)!.en,
                    style: MenuItemButton.styleFrom(
                      textStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  DropdownMenuEntry(
                    value: 'sr',
                    label: AppLocalizations.of(context)!.sr,
                    style: MenuItemButton.styleFrom(
                      textStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
                onSelected: (locale) {
                  if (locale != null) {
                    widget.onLocaleChanged(locale);
                  }
                },
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              ),
            ],
          ),
        ),

        const Divider(),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.animationIntensity,
                style: TextStyle(fontSize: 18.0),
              ),

              DropdownMenu(
                initialSelection: widget.presetValues['duration'] as Duration,
                leadingIcon: const Icon(Icons.animation),
                dropdownMenuEntries: <DropdownMenuEntry>[
                  DropdownMenuEntry(
                    value: durationInstant,
                    label: AppLocalizations.of(context)!.durationInstant,
                    style: MenuItemButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 16.0
                      )
                    )
                  ),
                  DropdownMenuEntry(
                    value: durationFast,
                    label: AppLocalizations.of(context)!.durationFast,
                      style: MenuItemButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: 16.0
                          )
                      )
                  ),
                  DropdownMenuEntry(
                    value: durationNormal,
                    label: AppLocalizations.of(context)!.durationNormal,
                      style: MenuItemButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: 16.0
                          )
                      )
                  ),
                  DropdownMenuEntry(
                    value: durationSlow,
                    label: AppLocalizations.of(context)!.durationSlow,
                      style: MenuItemButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: 16.0
                          )
                      )
                  ),
                ],
                onSelected: (duration) {
                  widget.onAnimationDurationChanged(duration);
                },
              ),
            ],
          ),
        ),

        const Divider(),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          ),
        ),
      ],
    );
  }
}
