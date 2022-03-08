class Config {
  static const ENV_LOCAL = 'local';
  static const ENV_WEB = 'web';

  static late Config _inst;
  factory Config() => _inst;

  Config.setup(
      {this.env = ENV_LOCAL,
      this.apiBasePath = '',
      this.apiHost = 'https://nile.trongrid.io',
      this.defaultChain = 'NILE'}) {
    _inst = this;
  }

  final String env;
  final String apiBasePath;
  final String apiHost;
  final String defaultChain;
}
