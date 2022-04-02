import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lura_client/core/utils/platform_helper.dart';

class RefreshWidget extends StatefulWidget {
  final Widget child;
  final Future Function() onRefresh;

  const RefreshWidget({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<RefreshWidget> createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  final _refreshIndicatorKey = const Key('refreshIndicator');

  @override
  Widget build(BuildContext context) {
    final isAndroid = PlatformHelper.isAndroid;
    return isAndroid ? androidList : iosList;
  }

  Widget get androidList {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      child: widget.child,
      onRefresh: widget.onRefresh,
    );
  }

  Widget get iosList {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      key: _refreshIndicatorKey,
      shrinkWrap: true,
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: widget.onRefresh,
          refreshTriggerPullDistance: 200,
        ),
        widget.child,
      ],
    );
  }
}
