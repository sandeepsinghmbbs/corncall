import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:corncall/common/enums/message_enum.dart';

class streams {
  final  StreamController stream;

  streams(this.stream);
}

final streamsProvider = StateProvider<streams?>((ref) => null);
