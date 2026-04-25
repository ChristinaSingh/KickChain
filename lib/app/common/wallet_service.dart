import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:reown_appkit/reown_appkit.dart';

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
      isInitializing.value = false;
      Get.snackbar(
        'Wallet unavailable on web',
        'Please use Android or iOS app to connect wallet.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
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
