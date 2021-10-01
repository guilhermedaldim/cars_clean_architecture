import 'package:data_connection_checker_tv/data_connection_checker.dart';

abstract class Network {
  Future<bool> get isConnected;
}

class NetworkImpl implements Network {
  final DataConnectionChecker connectionChecker;

  NetworkImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
