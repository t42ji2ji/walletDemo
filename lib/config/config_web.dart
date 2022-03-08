import 'config.dart';

void loadConfig() {
  final hostUri = Uri.base;
  var host = '${hostUri.scheme}://${hostUri.host}';
  if (hostUri.hasPort) {
    host += ':${hostUri.port}';
    //Uri.base.
  }

  Config.setup(
    env: Config.ENV_WEB,
    apiBasePath: '/api',
    apiHost: host,
  );
}
