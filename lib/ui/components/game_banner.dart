import 'package:flutter/material.dart';

class GameBanner extends StatefulWidget {
  const GameBanner({
    super.key,
    required this.title,
    required this.description,
    required this.imageAssetPath,
    required this.routeName,
  });

  final String title;
  final String description;
  final String imageAssetPath;
  final String routeName;

  @override
  State<StatefulWidget> createState() => _GameBannerState();
}

class _GameBannerState extends State<GameBanner> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OrientationBuilder(
        builder: (context, orientation) => Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            onTap: () {
              if (mounted) {
                Navigator.pushNamed(context, widget.routeName);
              }
            },
            child: Container(
              height: orientation == Orientation.landscape
                  ? MediaQuery.of(context).size.height * 0.9
                  : MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: List.of([
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.inverseSurface.withAlpha(0),
                    spreadRadius: 0,
                    blurStyle: BlurStyle.outer,
                    blurRadius: 2,
                  ),
                ]),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Stack(
                      children: [
                        Container(
                          width: orientation == Orientation.landscape ? 96 : 64,
                          height: orientation == Orientation.landscape
                              ? 96
                              : 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(64)),
                            border: BoxBorder.all(
                              color: Theme.of(
                                context,
                              ).colorScheme.inverseSurface.withAlpha(125),
                            ),
                            color: Theme.of(
                              context,
                            ).colorScheme.inverseSurface.withAlpha(25),
                          ),
                        ),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            widget.imageAssetPath,
                            isAntiAlias: true,
                            alignment: Alignment.topCenter,
                            width: orientation == Orientation.landscape
                                ? 96
                                : 64,
                            height: orientation == Orientation.landscape
                                ? 96
                                : 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Chip(
                            label: Text(
                              widget.title,
                              softWrap: true,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              widget.description,
                              softWrap: true,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
