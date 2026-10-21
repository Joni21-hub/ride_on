import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Available device & platform preview modes
enum DeviceMode {
  auto,    // Automatically detected from screen width and platform
  laptop,  // Full desktop/laptop responsive experience
  ios,     // Apple iPhone experience (Cupertino blur, dynamic island, bouncing physics)
  android, // Android experience (Material 3 pill bar, punch-hole, clamping physics)
  tablet,  // iPad / Tablet experience
}

/// Global controller for adaptive platform and device preview
class AdaptivePlatformController extends ChangeNotifier {
  static final AdaptivePlatformController instance = AdaptivePlatformController();

  DeviceMode _mode = DeviceMode.auto;

  DeviceMode get mode => _mode;

  void setMode(DeviceMode newMode) {
    if (_mode != newMode) {
      _mode = newMode;
      notifyListeners();
    }
  }
}

/// Inherited scope providing access to AdaptivePlatformController
class AdaptiveScope extends InheritedNotifier<AdaptivePlatformController> {
  const AdaptiveScope({
    super.key,
    required AdaptivePlatformController controller,
    required super.child,
  }) : super(notifier: controller);

  static AdaptivePlatformController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AdaptiveScope>();
    return scope?.notifier ?? AdaptivePlatformController.instance;
  }
}

/// Helper methods for adaptive layout, platform styling, and device sizing
class AdaptiveHelper {
  /// Checks if screen width is physical mobile size (< 768px)
  static bool isRealMobileScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  /// Returns the effective device mode considering manual override and screen width
  static DeviceMode effectiveMode(BuildContext context) {
    final controller = AdaptiveScope.of(context);
    if (controller.mode != DeviceMode.auto) {
      return controller.mode;
    }

    // Auto resolution based on screen width and target platform
    final width = MediaQuery.of(context).size.width;
    if (width < 768) {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return DeviceMode.ios;
      }
      return DeviceMode.android;
    } else if (width < 1024) {
      return DeviceMode.tablet;
    } else {
      return DeviceMode.laptop;
    }
  }

  /// Whether current active mode is Laptop / Desktop
  static bool isDesktop(BuildContext context) {
    return effectiveMode(context) == DeviceMode.laptop;
  }

  /// Whether current active mode is Tablet
  static bool isTablet(BuildContext context) {
    return effectiveMode(context) == DeviceMode.tablet;
  }

  /// Whether current active mode is Mobile (either iOS or Android)
  static bool isMobile(BuildContext context) {
    final mode = effectiveMode(context);
    return mode == DeviceMode.ios || mode == DeviceMode.android;
  }

  /// Whether current active platform style is iOS
  static bool isIOS(BuildContext context) {
    final mode = effectiveMode(context);
    if (mode == DeviceMode.ios) return true;
    if (mode == DeviceMode.android) return false;
    return defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS;
  }

  /// Whether current active platform style is Android
  static bool isAndroid(BuildContext context) {
    final mode = effectiveMode(context);
    if (mode == DeviceMode.android) return true;
    if (mode == DeviceMode.ios) return false;
    return defaultTargetPlatform == TargetPlatform.android;
  }

  /// Returns platform-specific scroll physics
  static ScrollPhysics scrollPhysics(BuildContext context) {
    if (isIOS(context)) {
      return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
    }
    if (isAndroid(context)) {
      return const ClampingScrollPhysics();
    }
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }

  /// Returns platform-adaptive back icon
  static IconData backIcon(BuildContext context) {
    return isIOS(context) ? Icons.arrow_back_ios_new : Icons.arrow_back;
  }

  /// Returns platform-adaptive share icon
  static IconData shareIcon(BuildContext context) {
    return isIOS(context) ? Icons.ios_share : Icons.share;
  }

  /// Returns platform-adaptive more icon
  static IconData moreIcon(BuildContext context) {
    return isIOS(context) ? Icons.more_horiz : Icons.more_vert;
  }

  /// Human-readable name of active platform / device
  static String platformTitle(BuildContext context) {
    final mode = effectiveMode(context);
    switch (mode) {
      case DeviceMode.ios:
        return 'Apple iPhone (iOS)';
      case DeviceMode.android:
        return 'Google Pixel / Android';
      case DeviceMode.tablet:
        return 'iPad / Android Tablet';
      case DeviceMode.laptop:
        return 'Laptop / Desktop Web';
      case DeviceMode.auto:
        return 'Auto Detect';
    }
  }
}

/// Top toolbar rendered on wide screens (Laptop / PC) allowing real-time device mode switching
class DevicePreviewToolbar extends StatelessWidget {
  const DevicePreviewToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AdaptiveScope.of(context);
    final effectiveMode = AdaptiveHelper.effectiveMode(context);
    final width = MediaQuery.of(context).size.width.toInt();
    final height = MediaQuery.of(context).size.height.toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF131127),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.12), width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Logo / Branding badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryPurple, Color(0xFF8667FD)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.devices, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'RideOn Multi-Platform',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Mode Selector Buttons
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildModeButton(
                      context: context,
                      label: 'Laptop / PC',
                      icon: Icons.laptop_mac_rounded,
                      mode: DeviceMode.laptop,
                      isActive: effectiveMode == DeviceMode.laptop,
                      controller: controller,
                    ),
                    const SizedBox(width: 6),
                    _buildModeButton(
                      context: context,
                      label: 'iPhone (iOS)',
                      icon: Icons.phone_iphone_rounded,
                      mode: DeviceMode.ios,
                      isActive: effectiveMode == DeviceMode.ios,
                      controller: controller,
                    ),
                    const SizedBox(width: 6),
                    _buildModeButton(
                      context: context,
                      label: 'Android Phone',
                      icon: Icons.phone_android_rounded,
                      mode: DeviceMode.android,
                      isActive: effectiveMode == DeviceMode.android,
                      controller: controller,
                    ),
                    const SizedBox(width: 6),
                    _buildModeButton(
                      context: context,
                      label: 'Tablet / iPad',
                      icon: Icons.tablet_mac_rounded,
                      mode: DeviceMode.tablet,
                      isActive: effectiveMode == DeviceMode.tablet,
                      controller: controller,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Screen resolution & platform status tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.successGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${width}x$height px • ${AdaptiveHelper.platformTitle(context)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required DeviceMode mode,
    required bool isActive,
    required AdaptivePlatformController controller,
  }) {
    return InkWell(
      onTap: () => controller.setMode(mode),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryPurple : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? Colors.white.withOpacity(0.3) : Colors.transparent,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primaryPurple.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isActive ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.white : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Adaptive Container: On wide screens (Laptop/PC), if mobile or tablet mode is selected,
/// it frames the app inside a realistic iPhone or Android device chassis.
/// If laptop mode is selected, it renders wide.
/// On actual mobile screens (< 768px), it always renders full screen natively without frame.
class AdaptiveContainer extends StatelessWidget {
  final Widget child;

  const AdaptiveContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isRealMobile = AdaptiveHelper.isRealMobileScreen(context);
    if (isRealMobile) {
      // True native mobile experience: zero mockup bezel, full screen
      return child;
    }

    final mode = AdaptiveHelper.effectiveMode(context);

    // If laptop mode is selected on wide screen
    if (mode == DeviceMode.laptop) {
      return Scaffold(
        backgroundColor: const Color(0xFFF1F3F9),
        body: Column(
          children: [
            const DevicePreviewToolbar(),
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 540),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // If mobile or tablet mode is selected on wide screen, wrap in device frame
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      body: Column(
        children: [
          const DevicePreviewToolbar(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: _buildDeviceChassis(context, mode, child),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceChassis(BuildContext context, DeviceMode mode, Widget content) {
    final isIos = mode == DeviceMode.ios;
    final isTablet = mode == DeviceMode.tablet;

    // Dimensions
    final double frameWidth = isTablet ? 768 : (isIos ? 392 : 396);
    final double frameHeight = isTablet ? 880 : 812;
    final double cornerRadius = isTablet ? 32 : (isIos ? 48 : 36);

    return Container(
      width: frameWidth,
      height: frameHeight,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(cornerRadius),
        border: Border.all(
          color: isIos ? const Color(0xFF4B5563) : const Color(0xFF2E2C3D),
          width: 5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 36,
            spreadRadius: 6,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: AppColors.primaryPurple.withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius - 4),
        child: Stack(
          children: [
            // Embedded Application Screen
            Positioned.fill(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  size: Size(frameWidth, frameHeight),
                  padding: EdgeInsets.only(
                    top: isIos ? 44 : 36,
                    bottom: isIos ? 24 : 16,
                  ),
                  viewPadding: EdgeInsets.only(
                    top: isIos ? 44 : 36,
                    bottom: isIos ? 24 : 16,
                  ),
                ),
                child: content,
              ),
            ),

            // Top Status Bar Overlay (Mockup Hardware details)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: isIos
                    ? _buildIosStatusBar()
                    : _buildAndroidStatusBar(isTablet),
              ),
            ),

            // Bottom Navigation Gesture Bar (Mockup Hardware details)
            Positioned(
              bottom: 6,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: Container(
                    width: isIos ? 134 : 110,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIosStatusBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // iOS Clock
          const Text(
            '9:41',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),

          // Dynamic Island Pill
          Container(
            width: 104,
            height: 26,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 8),
                Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F172A),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          // Status Icons (5G, WiFi, Battery)
          Row(
            children: const [
              Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.white),
              SizedBox(width: 4),
              Icon(Icons.wifi, size: 14, color: Colors.white),
              SizedBox(width: 4),
              Icon(Icons.battery_full_rounded, size: 17, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAndroidStatusBar(bool isTablet) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Android Clock
          const Text(
            '12:30',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),

          // Center Punch Hole Camera
          if (!isTablet)
            Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF374151), width: 1.5),
              ),
            ),

          // Material Status Icons
          Row(
            children: const [
              Icon(Icons.wifi, size: 13, color: Colors.white),
              SizedBox(width: 4),
              Icon(Icons.network_cell, size: 13, color: Colors.white),
              SizedBox(width: 4),
              Icon(Icons.battery_std, size: 13, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}

/// Adaptive Bottom Navigation Bar:
/// Automatically differentiates appearance between iOS (translucent frosted glassmorphism blur)
/// and Android (Material 3 elevated dark bar with active pill indicator).
class AdaptiveBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final List<AdaptiveNavItem> items;

  const AdaptiveBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isIos = AdaptiveHelper.isIOS(context);

    if (isIos) {
      // iOS Frosted Glassmorphism Design
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xE0131127), // Translucent deep violet
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.12),
                  width: 0.8,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 64,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final isSelected = currentIndex == index;
                    return InkWell(
                      onTap: () => onTabSelected(index),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isSelected ? item.activeIcon : item.icon,
                            size: 22,
                            color: isSelected ? AppColors.accentPastel : Colors.white60,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? Colors.white : Colors.white54,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Android Material 3 Pill Indicator Design
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = currentIndex == index;
              return InkWell(
                onTap: () => onTabSelected(index),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          isSelected ? item.activeIcon : item.icon,
                          size: 20,
                          color: isSelected ? AppColors.primaryDark : Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class AdaptiveNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const AdaptiveNavItem({
    required this.label,
    required this.icon,
    IconData? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}
