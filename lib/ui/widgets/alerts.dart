import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../colors.dart';

enum AlertType { info, error }

class AlertText extends StatelessWidget {
  final AlertType alertType;
  final Widget child;

  const AlertText({
    Key? key,
    this.alertType = AlertType.error,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        final isDesktop =
            sizingInformation.deviceScreenType == DeviceScreenType.desktop;
        return Container(
          width: isDesktop ? 400 : double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: isDesktop ? 20 : 10, horizontal: 10),
          decoration: BoxDecoration(
            color: alertType.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: alertType.borderColor),
          ),
          child: Theme(
            data: themeData.copyWith(
              textTheme: themeData.textTheme.copyWith(
                bodyText1: LuraTextStyles.baseTextStyle.copyWith(
                    fontSize: 16,
                    color: alertType.textColor,
                    fontWeight: FontWeight.w400),
                bodyText2: LuraTextStyles.baseTextStyle.copyWith(
                    fontSize: 14,
                    color: alertType.textColor,
                    fontWeight: FontWeight.w400),
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

extension on AlertType {
  Color get textColor {
    switch (this) {
      case AlertType.info:
        return LuraColors.infoText;
      case AlertType.error:
        return LuraColors.errorText;
    }
  }

  Color get borderColor {
    switch (this) {
      case AlertType.info:
        return LuraColors.infoBorder;
      case AlertType.error:
        return LuraColors.errorBorder;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case AlertType.info:
        return LuraColors.infoBackground;
      case AlertType.error:
        return LuraColors.errorBackground;
    }
  }
}

class ErrorAlert extends StatelessWidget {
  final String error;
  final VoidCallback? onTap;
  final bool showRetry;

  const ErrorAlert(
      {Key? key, required this.error, this.onTap, this.showRetry = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertText(
      alertType: AlertType.error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(error),
          const Gap(10),
          if (showRetry)
            GestureDetector(
              onTap: onTap,
              child: RichText(
                text: TextSpan(
                  text: 'Retry',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: LuraColors.errorText),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class InfoAlert extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;
  final bool showAction;
  final String? actionText;

  const InfoAlert(
      {Key? key,
      required this.message,
      this.onTap,
      this.showAction = false,
      this.actionText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertText(
      alertType: AlertType.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const Gap(10),
          if (showAction)
            GestureDetector(
              onTap: onTap,
              child: RichText(
                text: TextSpan(
                  text: actionText ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: LuraColors.infoText),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
