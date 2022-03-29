import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../colors.dart';
import 'lura_alert.dart';

class LuraSuccessAlert extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onClose;

  const LuraSuccessAlert({
    Key? key,
    required this.title,
    required this.message,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LuraAlert(
      title: title,
      message: message,
      onClose: onClose,
      icon: const Icon(FontAwesomeIcons.check, size: 15),
      bgColor: LuraColors.alertSuccessBackground,
      borderColor: LuraColors.alertSuccessBorder,
      iconColor: LuraColors.alertSuccessIcon,
    );
  }
}

class LuraInfoAlert extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onClose;
  final String? actionText;
  final VoidCallback? onAction;

  const LuraInfoAlert({
    Key? key,
    required this.title,
    required this.message,
    this.onClose,
    this.actionText,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LuraAlert(
      title: title,
      message: message,
      onClose: onClose,
      icon: const Icon(FontAwesomeIcons.info, size: 15),
      bgColor: LuraColors.alertInfoBackground,
      borderColor: LuraColors.alertInfoBorder,
      iconColor: LuraColors.alertInfoIcon,
      actionText: actionText,
      onAction: onAction,
    );
  }
}

class LuraErrorAlert extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onClose;
  final String? actionText;
  final VoidCallback? onAction;

  const LuraErrorAlert({
    Key? key,
    required this.title,
    required this.message,
    this.onClose,
    this.actionText,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LuraAlert(
      title: title,
      message: message,
      onClose: onClose,
      icon: const Icon(FontAwesomeIcons.info, size: 15),
      bgColor: LuraColors.alertErrorBackground,
      borderColor: LuraColors.alertErrorBorder,
      iconColor: LuraColors.alertErrorIcon,
      actionText: actionText,
      onAction: onAction,
    );
  }
}

class LuraWarningAlert extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onClose;

  const LuraWarningAlert({
    Key? key,
    required this.title,
    required this.message,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LuraAlert(
      title: title,
      message: message,
      onClose: onClose,
      icon: const Icon(FontAwesomeIcons.info, size: 15),
      bgColor: LuraColors.alertWarningBackground,
      borderColor: LuraColors.alertWarningBorder,
      iconColor: LuraColors.alertWarningIcon,
    );
  }
}
