import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/telegram_web_bridge.dart';

enum WebWalletApp { metamask, trustWallet }

class WalletService extends GetxService {
  static WalletService get to => Get.find();

  // ── Observables ──────────────────────────────
  final isConnected = false.obs;
  final walletAddress = ''.obs;
  final walletBalance = '0.00'.obs;
  final isInitializing = true.obs;
  final isConnecting = false.obs;
  final connectedChain = ''.obs;
  final sessionTopic = ''.obs;

  // ── AppKit modal instance ─────────────────────
  ReownAppKitModal? _appKitModal;
  bool _loggedWebUnsupported = false;

  bool get isAppKitReady => _appKitModal != null;
  bool get isTelegramMiniAppContext => kIsWeb && isTelegramMiniAppWeb();
  bool get isTelegramMobileContext =>
      isTelegramMiniAppContext && _isTelegramMobilePlatform();

  // ── Replace with your Reown Cloud project ID ──
  static const _projectId = '62085e04fb4b751847113628420f1cf1';

  // ── Called from main.dart ──────────────────────
  Future<WalletService> init() async {
    debugPrint('[WalletService] Service registered');
    return this;
  }

  // ── Initialize AppKit with context ─────────────
  Future<bool> initAppKit(BuildContext context) async {
    if (kIsWeb) {
      isInitializing.value = false;
      if (!_loggedWebUnsupported) {
        debugPrint(
          '[WalletService] AppKit is not supported on Web for this build',
        );
        _loggedWebUnsupported = true;
      }
      return false;
    }

    if (_appKitModal != null) {
      debugPrint('[WalletService] Already initialized');
      return true;
    }

    try {
      debugPrint('[WalletService] Initializing AppKit...');

      _appKitModal = ReownAppKitModal(
        context: context,
        projectId: _projectId,
        metadata: const PairingMetadata(
          name: 'KickChain Soccer Clash',
          description: 'Compete in real-money soccer matches',
          url: 'https://kickchain.io',
          icons: ['https://kickchain.io/assets/icon.png'],
          redirect: Redirect(
            native: 'kickchain://',
            universal: 'https://kickchain.io',
            linkMode: true,
          ),
        ),
      );

      await _appKitModal!.init();

      // Restore previous session
      _syncSession();

      // Listen for session changes
      _appKitModal!.onModalConnect.subscribe(_onConnect);
      _appKitModal!.onModalDisconnect.subscribe(_onDisconnect);
      _appKitModal!.onModalError.subscribe(_onError);
      _appKitModal!.onSessionExpireEvent.subscribe(_onSessionExpire);

      isInitializing.value = false;
      debugPrint('[WalletService] AppKit initialized successfully');
      return true;
    } catch (e) {
      isInitializing.value = false;
      debugPrint('[WalletService] init error: $e');
      return false;
    }
  }

  void _syncSession() {
    if (_appKitModal == null) return;
    final session = _appKitModal!.session;
    if (session != null) {
      isConnected.value = true;
      walletAddress.value = _appKitModal!.session?.getAddress("") ?? '';
      connectedChain.value = _appKitModal!.selectedChain?.name ?? '';
      sessionTopic.value = session.topic ?? '';
      _fetchBalance();
    }
  }

  void _onConnect(ModalConnect? event) {
    isConnecting.value = false;
    isConnected.value = true;
    walletAddress.value = _appKitModal?.session?.getAddress("") ?? '';
    connectedChain.value = _appKitModal?.selectedChain?.name ?? '';
    sessionTopic.value = _appKitModal?.session?.topic ?? '';
    _fetchBalance();
    debugPrint('[WalletService] connected: ${walletAddress.value}');
  }

  void _onDisconnect(ModalDisconnect? event) {
    isConnected.value = false;
    walletAddress.value = '';
    walletBalance.value = '0.00';
    connectedChain.value = '';
    sessionTopic.value = '';
    debugPrint('[WalletService] disconnected');
  }

  void _onError(ModalError? event) {
    isConnecting.value = false;
    debugPrint('[WalletService] error: ${event?.message}');
  }

  void _onSessionExpire(SessionExpire? event) {
    _onDisconnect(null);
  }

  // ── Open the connect modal ─────────────────────
  Future<void> openConnectModal(BuildContext context) async {
    if (kIsWeb) {
      await _connectOnWeb();
      return;
    }

    // Initialize if not ready
    if (_appKitModal == null) {
      final success = await initAppKit(context);
      if (!success) {
        debugPrint('[WalletService] Failed to initialize AppKit');
        return;
      }
    }

    if (isConnected.value) return;

    isConnecting.value = true;
    try {
      await _appKitModal!.openModalView();
    } catch (e) {
      isConnecting.value = false;
      debugPrint('[WalletService] openModal error: $e');
    }
  }

  // ── Disconnect ─────────────────────────────────
  Future<void> disconnect() async {
    if (kIsWeb) {
      _onDisconnect(null);
      return;
    }

    if (_appKitModal == null) return;
    try {
      await _appKitModal!.disconnect();
    } catch (e) {
      debugPrint('[WalletService] disconnect error: $e');
    }
  }

  Future<void> _fetchBalance() async {
    try {
      // TODO: Implement actual balance fetching
      walletBalance.value = '0.00';
    } catch (_) {}
  }

  Future<void> _connectOnWeb() async {
    if (!kIsWeb) return;
    isInitializing.value = false;
    isConnecting.value = true;

    try {
      final provider = await _resolveWebProvider();
      if (provider == null) {
        if (isTelegramMiniAppWeb() && _isTelegramMobilePlatform()) {
          final opened = await _openInWalletBrowser(
            WebWalletApp.metamask,
            preferTelegramBridge: true,
          );
          isConnecting.value = false;
          if (opened) {
            Get.snackbar(
              'Opening wallet',
              'We opened MetaMask. Continue wallet connection there.',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4),
            );
            return;
          }
        }

        if (isTelegramMiniAppWeb() && !_isTelegramMobilePlatform()) {
          Get.snackbar(
            'Open in Chrome',
            'For direct extension wallet connect, open this app in regular Chrome with MetaMask extension enabled.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
          );
          isConnecting.value = false;
          return;
        }

        Get.snackbar(
          'Wallet not found',
          'No browser wallet detected. Install MetaMask (or open this site inside a wallet browser) and try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
        isConnecting.value = false;
        return;
      }

      final accounts = await provider.requestAccount();
      if (accounts.isEmpty) {
        isConnecting.value = false;
        return;
      }

      walletAddress.value = accounts.first;
      isConnected.value = true;
      connectedChain.value = provider.chainId.toString();
      sessionTopic.value = 'browser-wallet';
      await _fetchBalance();
      isConnecting.value = false;
      debugPrint(
        '[WalletService] Web wallet connected: ${walletAddress.value}',
      );
    } catch (e) {
      isConnecting.value = false;
      debugPrint('[WalletService] web connect error: $e');
      Get.snackbar(
        'Connection failed',
        'Could not connect browser wallet. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> checkWebConnection() async {
    if (!kIsWeb) return;
    await _connectOnWeb();
  }

  Future<void> openWalletAppForTelegram(WebWalletApp app) async {
    if (!kIsWeb || !isTelegramMobileContext) return;

    isConnecting.value = true;
    final name = app == WebWalletApp.metamask ? 'MetaMask' : 'Trust Wallet';
    Get.snackbar(
      'Redirecting to $name',
      'Approve in wallet app, then return and tap "Check Connection".',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );

    final opened = await _openInWalletBrowser(app, preferTelegramBridge: true);
    isConnecting.value = false;
    if (!opened) {
      Get.snackbar(
        'Unable to open wallet',
        'Please install $name and try again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<Ethereum?> _resolveWebProvider() async {
    if (!kIsWeb) return null;
    if (ethereum != null) return ethereum;

    // Some wallets inject window.ethereum shortly after page load.
    for (var i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
      if (ethereum != null) return ethereum;
    }
    return null;
  }

  bool _isTelegramMobilePlatform() {
    if (!kIsWeb) return false;
    final p = (Uri.base.queryParameters['tgWebAppPlatform'] ?? '')
        .toLowerCase();
    return p.contains('android') || p.contains('ios');
  }

  Future<bool> _openInWalletBrowser(
    WebWalletApp app, {
    bool preferTelegramBridge = false,
  }) async {
    if (!kIsWeb) return false;
    try {
      final current = Uri.base.toString();
      final withoutScheme = current.replaceFirst(RegExp(r'^https?://'), '');
      final walletUri = switch (app) {
        WebWalletApp.metamask => Uri.parse(
          'https://metamask.app.link/dapp/$withoutScheme',
        ),
        WebWalletApp.trustWallet => Uri.parse(
          'https://link.trustwallet.com/open_url?coin_id=60&url=${Uri.encodeComponent(current)}',
        ),
      };

      if (preferTelegramBridge) {
        final openedInTelegram = await openTelegramMiniAppExternalLink(
          walletUri.toString(),
        );
        if (openedInTelegram) return true;
      }

      return await launchUrl(walletUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('[WalletService] Wallet deep-link open failed: $e');
      return false;
    }
  }

  String get shortAddress {
    final addr = walletAddress.value;
    if (addr.length < 10) return addr;
    return '${addr.substring(0, 6)}...${addr.substring(addr.length - 4)}';
  }

  @override
  void onClose() {
    _appKitModal?.onModalConnect.unsubscribe(_onConnect);
    _appKitModal?.onModalDisconnect.unsubscribe(_onDisconnect);
    _appKitModal?.onModalError.unsubscribe(_onError);
    _appKitModal?.onSessionExpireEvent.unsubscribe(_onSessionExpire);
    super.onClose();
  }
}
