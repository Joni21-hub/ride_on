import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'driver/driver_models.dart';
import 'driver/driver_radar_tab.dart';
import 'driver/driver_activity_tab.dart';
import 'driver/driver_wallet_tab.dart';
import 'driver/driver_chat_tab.dart';
import 'driver/driver_profile_dialog.dart';

class DriverView extends StatefulWidget {
  final VoidCallback onBackToCustomer;

  const DriverView({super.key, required this.onBackToCustomer});

  @override
  State<DriverView> createState() => _DriverViewState();
}

class _DriverViewState extends State<DriverView> {
  int _currentTab = 0;
  bool _isOnline = true;
  int _cashCapital = 200000;
  int _activeBalance = 327000;
  int _todayEarnings = 0;
  int _todayTrips = 0;

  void _onTripCompleted(DriverActiveOrder order, int earnings) {
    setState(() {
      _todayEarnings += earnings;
      _todayTrips += 1;
      _activeBalance += earnings;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      DriverRadarTab(
        isOnline: _isOnline,
        onToggleOnline: (val) => setState(() => _isOnline = val),
        cashCapital: _cashCapital,
        onUpdateCashCapital: (val) => setState(() => _cashCapital = val),
        todayEarnings: _todayEarnings,
        todayTrips: _todayTrips,
        onTripCompleted: _onTripCompleted,
        onOpenChat: () => setState(() => _currentTab = 3),
      ),
      const DriverActivityTab(),
      DriverWalletTab(
        activeBalance: _activeBalance,
        onBalanceUpdated: (newBal) => setState(() => _activeBalance = newBal),
      ),
      const DriverChatTab(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Current Tab
          IndexedStack(
            index: _currentTab,
            children: tabs,
          ),

          // Custom Top Header for Driver (Joni Utama, BK 4892 ABC, GPS SIAP)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.textDark,
                      shadowColor: Colors.black12,
                      elevation: 4,
                    ),
                    icon: const Icon(Icons.arrow_back),
                    onPressed: widget.onBackToCustomer,
                    tooltip: 'Kembali ke Customer / Switch Role',
                  ),
                  const SizedBox(width: 8),

                  // Avatar & Driver name
                  GestureDetector(
                    onTap: () => DriverProfileDialog.show(context, onBackToCustomer: widget.onBackToCustomer),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/driver_avatar.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Joni Utama',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryDark,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'BK 4892 ABC',
                                  style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),

                  // GPS SIAP badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFC8E6C9)),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.circle, color: Color(0xFF00E676), size: 8),
                        SizedBox(width: 6),
                        Text(
                          'GPS SIAP',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar matching Figma
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.radar, 'Radar'),
                _buildNavItem(1, Icons.receipt_long, 'Aktivitas'),
                _buildNavItem(2, Icons.account_balance_wallet, 'Dompet'),
                _buildNavItem(3, Icons.forum, 'Chat'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentTab == index;
    return InkWell(
      onTap: () => setState(() => _currentTab = index),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white60,
              size: 20,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
