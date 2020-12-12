import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../configs/themes_config.dart';
import 'progress_indicator_widget.dart';

class EmptyList extends StatelessWidget {
  final String svgImage;
  final String title;

  const EmptyList({Key key, @required this.svgImage, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildImage(),
        _buildText(),
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: SvgPicture.asset(
        'assets/images/$svgImage.svg',
        height: 300,
        placeholderBuilder: (_) => ProgressIndicatorWidget(),
      ),
    );
  }

  Widget _buildText() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Text(
        title ?? 'A lista está vazia.',
        style: themeData.textTheme.headline5.merge(const TextStyle(color: Colors.white)),
        textAlign: TextAlign.center,
      ),
    );
  }
}
