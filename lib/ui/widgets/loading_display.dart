import 'package:flutter/material.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingDisplay extends StatelessWidget {
  const LoadingDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 50),
      child: Center(
        child: Loader(size: 30),
      ),
    );
  }
}

class Loader extends StatelessWidget {
  final double size;

  const Loader({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitCubeGrid(
      color: LuraColors.blue,
      size: size,
    );
  }
}
