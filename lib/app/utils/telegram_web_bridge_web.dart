import 'dart:html' as html;
import 'dart:js_util' as js_util;

bool isTelegramMiniAppWeb() {
  try {
    if (!js_util.hasProperty(html.window, 'Telegram')) return false;
    final telegram = js_util.getProperty(html.window, 'Telegram');
    if (telegram == null) return false;
    if (!js_util.hasProperty(telegram, 'WebApp')) return false;
    final webApp = js_util.getProperty(telegram, 'WebApp');
    return webApp != null;
  } catch (_) {
    return false;
  }
}

Future<bool> openTelegramMiniAppExternalLink(String url) async {
  try {
    if (!js_util.hasProperty(html.window, 'Telegram')) return false;
    final telegram = js_util.getProperty(html.window, 'Telegram');
    if (telegram == null) return false;
    if (!js_util.hasProperty(telegram, 'WebApp')) return false;

    final webApp = js_util.getProperty(telegram, 'WebApp');
    if (webApp == null || !js_util.hasProperty(webApp, 'openLink'))
      return false;

    js_util.callMethod(webApp, 'openLink', [url]);
    return true;
  } catch (_) {
    return false;
  }
}
