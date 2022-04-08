import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import '../authentication/lura_user.dart';

class TrackingService {
  final Mixpanel _mixpanel;
  final String env;

  const TrackingService({required Mixpanel mixpanel, this.env = 'dev'})
      : _mixpanel = mixpanel;

  Future setUser(LuraUser user) async {
    _mixpanel.identify(user.uid);
    _mixpanel.getPeople()
      ..set('\$email', user.email)
      ..set('\$distinct_id', user.uid);
  }

  Future trackLogin(String email) async {
    trackEvent('LOGIN', properties: {'\$email': email});
  }

  Future trackSignup(String email) async {
    trackEvent('SIGNUP', properties: {'\$email': email});
  }

  Future trackLogout() async {
    trackEvent('SIGNUP');
  }

  Future trackEvent(String eventName,
      {Map<String, String> properties = const {}}) async {
    properties.addAll({'env': env});
    _mixpanel.track(eventName, properties: properties);
  }

  Future reset() async {
    _mixpanel.reset();
  }
}
