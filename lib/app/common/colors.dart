import 'dart:ui';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  APP COLORS  –  KickChain Soccer Clash
// ─────────────────────────────────────────────

// ── Background Gradient ──────────────────────
const Color bgGradientTop    = Color(0xFF1D8C01);
const Color bgGradientBottom = Color(0xFF041A0B);

// ── Primary Brand ────────────────────────────
const Color primaryColor     = Color(0xFF6EC21B);   // green light
const Color primaryColor2    = Color(0xFF0B826F);   // green dark / teal

// ── Coin Bar ─────────────────────────────────
const Color coinBarBg        = Color(0x59000000);   // black @ 35%

// ── Play Match button ────────────────────────
const Color playMatchStart   = Color(0xFF5DCF00);
const Color playMatchEnd     = Color(0xFF0B826F);

// ── Shop button ──────────────────────────────
const Color shopStart        = Color(0xFF297DFF);
const Color shopEnd          = Color(0xFF155DFB);

// ── Leaderboard button ───────────────────────
const Color leaderboardStart = Color(0xFFEFB000);
const Color leaderboardEnd   = Color(0xFFD18800);

// ── Daily Missions button ────────────────────
const Color dailyMissionsStart = Color(0xFFAC45FF);
const Color dailyMissionsEnd   = Color(0xFF9915FB);

// ── Notification FAB ─────────────────────────
const Color notifGradientStart = Color(0xFF5DCF00);
const Color notifGradientEnd   = Color(0xFF0B826F);
const Color notifBorder        = Colors.white;

// ── Home FAB ─────────────────────────────────
const Color homeFabBg          = Color(0xFF5DCF00);

// ── Card Shadow ──────────────────────────────
const Color cardShadowColor    = Color(0x40000000);  // black @ 25%

// ── Bottom Nav ───────────────────────────────
const Color bottomNavBg        = Color(0xFF0A0A0A);
const Color bottomNavActive    = Color(0xFF5DCF00);
const Color bottomNavInactive  = Color(0xFF8A8A8A);

// ── Text ─────────────────────────────────────
const Color textWhite          = Color(0xFFFFFFFF);
const Color textBlack          = Color(0xFF000000);
const Color textGrey           = Color(0xFFADA4A5);
const Color textLightBlue      = Color(0xFF9DB2BF);
const Color textGreen          = primaryColor;
const Color textTeal           = primaryColor2;

// ── Misc ─────────────────────────────────────
const Color transparent        = Colors.transparent;
const Color dividerColor       = Color(0xFF2A3A2A);

// ══════════════════════════════════════════════
//  WALLET SCREEN COLORS
// ══════════════════════════════════════════════

// ── Balance card ─────────────────────────────
const Color walletCardBg          = Color(0x26FFFFFF);  // white @ 15%
const Color walletCardBorderStart = Color(0xFF5DCF00);  // green border gradient start
const Color walletCardBorderEnd   = Color(0xFF0B826F);  // teal border gradient end

// ── Available / Locked sub-cards ─────────────
const Color walletSubCardBg       = Color(0xFF0c5208);  // dark green pill bg
const Color walletSubCardBorder   = Color(0xFF1E4A1E);  // subtle border

// ── Deposit button ───────────────────────────
const Color depositStart          = Color(0xFF5DCF00);
const Color depositEnd            = Color(0xFF1b8c5f);

// ── Withdraw button ──────────────────────────
const Color withdrawBorder        = Color(0xFF5DCF00);
const Color withdrawBg            = Color(0x1A5DCF00);  // green @ 10%

// ── Stats row card ───────────────────────────
const Color statsCardBg           = Color(0x20FFFFFF);  // white @ 13%
const Color statsCardBorderStart  = Color(0xFF5DCF00);
const Color statsCardBorderEnd    = Color(0xFF0B826F);
const Color statsDivider          = Color(0x33FFFFFF);  // white @ 20%

// ── Activity cards ───────────────────────────
const Color activityCardBg        = Color(0x1AFFFFFF);  // white @ 10%
const Color activityCardBorder    = Color(0x33FFFFFF);  // white @ 20%

// ── Transaction icon backgrounds ─────────────
const Color txIconIncomeBg        = Color(0xFF3BB900);  // green circle
const Color txIconOutgoingBg      = Color(0xFFE53935);  // red circle

// ── Transaction amounts ───────────────────────
const Color txAmountPositive      = Color(0xFF6EC21B);  // green +
const Color txAmountNegative      = Color(0xFFE53935);  // red  -

// ── "View All" link ───────────────────────────
const Color viewAllColor          = Color(0xFFFFFFFF);


// ── Background gradient ──────────────────────
 const Color bgTop    = Color(0xFF1A5C00); // deep forest green (top)
 const Color bgMid    = Color(0xFF0D3D00); // darker mid green
 const Color bgBottom = Color(0xFF071A00); // near-black green (bottom)

// ── Card / glass surface ─────────────────────
 const Color cardBg        = Color(0x1AFFFFFF); // white 10 % opacity
 const Color cardBorder    = Color(0x33FFFFFF); // white 20 %
 const Color cardBgDark    = Color(0x0DFFFFFF); // white 5 %

// ── Gradient border colours ──────────────────
 const Color gradBorderTop    = Color(0xFF5DCF00);
 const Color gradBorderBottom = Color(0xFF0B826F);

// ── Toggle colours ───────────────────────────
 const Color toggleActiveTrack   = Color(0xFF4CD137);
 const Color toggleInactiveTrack = Color(0xFF9E9E9E);
 const Color toggleThumbBg       = Color(0xFFFFFFFF);

// ── Accent / action ──────────────────────────
 const Color logoutBtn   = Color(0xFFE53935); // red pill
 const Color accentGreen = Color(0xFF5DCF00);
 const Color accentTeal  = Color(0xFF0B826F);

// ── Text ─────────────────────────────────────
 const Color textPrimary   = Color(0xFFFFFFFF);
 const Color textSecondary = Color(0xFFB2DFDB); // light mint
 const Color textMuted     = Color(0xFF80CBC4); // muted teal

// ── Divider ──────────────────────────────────
 const Color divider = Color(0x1AFFFFFF); // white 10 %

// ── Icon tints ───────────────────────────────
 const Color iconGreen = Color(0xFF4CD137);

// ── Chevron ──────────────────────────────────
 const Color chevron = Color(0xFF80CBC4);


const Color bgGradientMid = Color(0xFF0A6400);


// Fun Coins card
const Color funCoinsStart = Color(0xFFFFB300);
const Color funCoinsEnd = Color(0xFFFF8C00);
const Color funCoinsOrb = Color(0xFFFFC940);

// Real Stakes card
const Color realStakesStart = Color(0xFF3DD068);
const Color realStakesEnd = Color(0xFF1A7A3C);
const Color realStakesOrb = Color(0xFF52E080);


const Color backButtonColor = Color(0xFF22C55E);


// ── Auth / glass theme colors ───────────────────
const Color glassBg             = Color(0x1AFFFFFF);   // 10% white
const Color glassBgDark         = Color(0x33000000);   // 20% black
const Color glassBorder         = Color(0x33FFFFFF);   // 20% white
const Color inputFillColor      = Color(0x1AFFFFFF);
const Color inputBorderColor    = Color(0x55FFFFFF);
const Color hintColor           = Color(0x99FFFFFF);
const Color errorRedColor       = Color(0xFFFF4444);
const Color successGreenColor   = Color(0xFF4CAF50);
const Color linkColor           = Color(0xFF1DB800);
const Color disabledBtnColor    = Color(0x55FFFFFF);