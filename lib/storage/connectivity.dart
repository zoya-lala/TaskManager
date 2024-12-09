import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Expose the connectivity stream (mapped to return single ConnectivityResult)
  Stream<ConnectivityResult> get connectivityStream =>
      _connectivity.onConnectivityChanged
          .asyncExpand((event) => Stream.fromIterable(event));

  /// Get the current connectivity status
  Future<List<ConnectivityResult>> get currentConnectivity async =>
      (await _connectivity.checkConnectivity());
}
