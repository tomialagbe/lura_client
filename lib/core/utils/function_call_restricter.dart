import 'package:flutter/cupertino.dart';

class FunctionCallRestricter {
  int _maxCalls = 0;
  int _numCalls = 0;

  FunctionCallRestricter({required int maxCalls}) {
    _maxCalls = maxCalls;
  }

  void reset() {
    _numCalls = 0;
  }

  call(VoidCallback funcToCall) {
    callFunction(funcToCall);
  }

  void callFunction(VoidCallback functionToCall) {
    if (_numCalls < _maxCalls) {
      _numCalls++;
      functionToCall();
    }
  }
}
