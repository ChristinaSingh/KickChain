import 'telegram_web_bridge_stub.dart'
    if (dart.library.html) 'telegram_web_bridge_web.dart'
    as impl;

bool isTelegramMiniAppWeb() => impl.isTelegramMiniAppWeb();

Future<bool> openTelegramMiniAppExternalLink(String url) =>
    impl.openTelegramMiniAppExternalLink(url);
