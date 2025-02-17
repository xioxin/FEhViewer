import 'package:dio/dio.dart';

// dio 配置项
class DioHttpConfig {
  DioHttpConfig({
    this.baseUrl,
    this.proxy,
    this.cookiesPath,
    this.interceptors,
    this.domainFronting,
    this.connectTimeout = Duration.millisecondsPerMinute,
    this.sendTimeout = Duration.millisecondsPerMinute,
    this.receiveTimeout = Duration.millisecondsPerMinute,
    this.maxConnectionsPerHost,
    this.contentType = Headers.formUrlEncodedContentType,
  });

  String? baseUrl;
  String? proxy;
  String? cookiesPath;
  List<Interceptor>? interceptors;
  int connectTimeout;
  int sendTimeout;
  int receiveTimeout;
  bool? domainFronting;
  int? maxConnectionsPerHost;
  String? contentType;

  @override
  String toString() {
    return 'DioHttpConfig{baseUrl: $baseUrl, proxy: $proxy, cookiesPath: $cookiesPath, interceptors: $interceptors, connectTimeout: $connectTimeout, sendTimeout: $sendTimeout, receiveTimeout: $receiveTimeout, domainFronting: $domainFronting, maxConnectionsPerHost: $maxConnectionsPerHost, contentType: $contentType}';
  }
}
