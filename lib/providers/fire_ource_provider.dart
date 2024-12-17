import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FireSourcNotifier extends StateNotifier<Source> {
  FireSourcNotifier() : super(Source.serverAndCache);
  changeSourceToCacheAndRevertAfterSeconds() {
    state = Source.cache;
    Future.delayed(const Duration(milliseconds: 400)).then(
      (value) {
        state = Source.serverAndCache;
      },
    );
  }
}

final fireSourcProvider = StateNotifierProvider<FireSourcNotifier, Source>(
  (ref) => FireSourcNotifier(),
);
