import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../configs/themes_config.dart';

class EmptyList extends StatelessWidget {
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
        'assets/images/empty_list.svg',
        height: 300,
      ),
    );
  }

  Widget _buildText() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Text(
        'A lista está vazia.',
        style: themeData.textTheme.headline5.merge(const TextStyle(color: Colors.white)),
        textAlign: TextAlign.center,
      ),
    );
  }
}
