import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'merchant/merchant_models.dart';
import 'merchant/merchant_dashboard_tab.dart';
import 'merchant/merchant_orders_tab.dart';
import 'merchant/merchant_menu_tab.dart';
import 'merchant/merchant_wallet_tab.dart';
import 'merchant/merchant_registration_flow.dart';

class MerchantView extends StatefulWidget {
  final VoidCallback onBackToCustomer;

  const MerchantView({super.key, required this.onBackToCustomer});

  @override
  State<MerchantView> createState() => _MerchantViewState();
}

class _MerchantViewState extends State<MerchantView> {
  int _currentTab = 0;
  bool _isOpen = true;
  int _todayEarnings = 485000;
  int _todayCompletedOrders = 14;
  int _activeBalance = 1485000;

  late List<MerchantOrder> _orders;
  late List<MerchantMenuItem> _menuItems;

  @override
  void initState() {
    super.initState();
    _orders = [
      MerchantOrder(
        id: '#FD-8821',
        customerName: 'Siti Nuraini',
        customerPhone: '0813-8829-1029',
        items: const [
          MerchantOrderItem(name: 'Nasi Goreng Spesial (Level Sedang)', quantity: 2, price: 21000),
          MerchantOrderItem(name: 'Es Teh Manis Jumbo', quantity: 1, price: 6000),
        ],
        totalPrice: 48000,
        orderTime: DateTime.now().subtract(const Duration(minutes: 5)),
        status: MerchantOrderStatus.newOrder,
        assignedDriverName: 'Joni Utama',
        assignedDriverPlate: 'BK 4892 ABC',
        handoverPin: '4092',
        cookingEstimateMinutes: 15,
      ),
      MerchantOrder(
        id: '#FD-8822',
        customerName: 'Fikri Pratama',
        customerPhone: '0852-7718-2918',
        items: const [
          MerchantOrderItem(name: 'Ayam Bakar Madu Sukaramai', quantity: 1, price: 32000),
          MerchantOrderItem(name: 'Kebab Turki Daging Sapi', quantity: 1, price: 22000),
          MerchantOrderItem(name: 'Es Jeruk Segar', quantity: 2, price: 7000),
        ],
        totalPrice: 68000,
        orderTime: DateTime.now().subtract(const Duration(minutes: 2)),
        status: MerchantOrderStatus.newOrder,
        assignedDriverName: 'Joni Utama',
        assignedDriverPlate: 'BK 4892 ABC',
        handoverPin: '4092',
        cookingEstimateMinutes: 20,
      ),
      MerchantOrder(
        id: '#FD-8820',
        customerName: 'M. Topik',
        customerPhone: '0812-9988-7766',
        items: const [
          MerchantOrderItem(name: 'Bakso Urat Jumbo Spesial', quantity: 2, price: 25000),
        ],
        totalPrice: 50000,
        orderTime: DateTime.now().subtract(const Duration(minutes: 25)),
        status: MerchantOrderStatus.readyToPickup,
        assignedDriverName: 'Joni Utama',
        assignedDriverPlate: 'BK 4892 ABC',
        handoverPin: '4092',
        cookingEstimateMinutes: 0,
      ),
    ];

    _menuItems = [
      MerchantMenuItem(
        id: 'M-1',
        name: 'Nasi Goreng Spesial',
        description: 'Nasi goreng harum rempah istimewa, telur mata sapi, acar segar dan kerupuk renyah.',
        price: 24000,
        category: 'Makanan Utama',
        imageAsset: 'assets/images/nasi_goreng.png',
        variants: ['Level Pedas: 1-5', 'Topping Telur Mata Sapi'],
      ),
      MerchantMenuItem(
        id: 'M-2',
        name: 'Ayam Bakar Madu Sukaramai',
        description: 'Potongan ayam empuk dibakar dengan olesan bumbu madu legit kecap manis khas rempah.',
        price: 32000,
        category: 'Makanan Utama',
        imageAsset: 'assets/images/ayam_bakar.png',
        variants: ['Bagian Paha / Dada', 'Sambal Terasi'],
      ),
      MerchantMenuItem(
        id: 'M-3',
        name: 'Bakso Urat Jumbo',
        description: 'Bakso daging sapi asli dengan isian urat renyah, kuah kaldu sapi pekat gurih segar.',
        price: 25000,
        category: 'Makanan Utama',
        imageAsset: 'assets/images/bakso_urat.png',
        variants: ['Mie Kuning / Bihun', 'Ekstra Tetelan'],
      ),
      MerchantMenuItem(
        id: 'M-4',
        name: 'Kebab Turki Daging Sapi',
        description: 'Tortilla renyah dengan isian irisan daging kebab sapi lezat, saus keju dan mayones.',
        price: 22000,
        category: 'Camilan',
        imageAsset: 'assets/images/kebab_turki.png',
        variants: ['Pedas Sedang', 'Ekstra Keju'],
      ),
      MerchantMenuItem(
        id: 'M-5',
        name: 'Burger Sapi Keju Panggang',
        description: 'Patty sapi juicy dengan keju leleh cheddar, selada renyah dan saus spesial gerai.',
        price: 28000,
        category: 'Camilan',
        imageAsset: 'assets/images/burger.png',
        variants: ['Single Patty', 'Double Cheese'],
      ),
      MerchantMenuItem(
        id: 'M-6',
        name: 'Mie Ayam Pangsit Komplit',
        description: 'Mie kenyal dengan topping cincang ayam manis gurih, kuah bening kaldu dan pangsit renyah.',
        price: 18000,
        category: 'Makanan Utama',
        imageAsset: 'assets/images/mie_ayam.png',
        variants: ['Pangsit Goreng / Basah'],
      ),
      MerchantMenuItem(
        id: 'M-7',
        name: 'Pempek Palembang Asli',
        description: 'Pempek lenjer dan kapal selam dengan kuah cuko asam manis pedas kental.',
        price: 25000,
        category: 'Camilan',
        imageAsset: 'assets/images/pempek.png',
        variants: ['Kuah Cuko Pedas'],
      ),
      MerchantMenuItem(
        id: 'M-8',
        name: 'Es Teh Manis Melati Jumbo',
        description: 'Teh seduh daun melati segar dengan es kristal dingin melepas dahaga.',
        price: 6000,
        category: 'Minuman',
        variants: ['Gula Sedang / Normal'],
      ),
      MerchantMenuItem(
        id: 'M-9',
        name: 'Es Jeruk Peras Murni',
        description: 'Perasan jeruk asli segar kaya vitamin C dengan sensasi manis alami.',
        price: 8000,
        category: 'Minuman',
        variants: ['Es Sedang / Tanpa Es'],
      ),
    ];
  }

  void _onStartCooking(MerchantOrder order) {
    setState(() {
      order.status = MerchantOrderStatus.cooking;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pesanan ${order.id} mulai dimasak oleh dapur!'),
        backgroundColor: AppColors.primaryPurple,
      ),
    );
  }

  void _onMarkReady(MerchantOrder order) {
    setState(() {
      order.status = MerchantOrderStatus.readyToPickup;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pesanan ${order.id} selesai dimasak! Driver Joni Utama siap mengambil.'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  void _onCompleteOrder(MerchantOrder order) {
    setState(() {
      order.status = MerchantOrderStatus.completed;
      _todayEarnings += order.totalPrice;
      _todayCompletedOrders += 1;
      _activeBalance += order.totalPrice;
    });
  }

  void _onRejectOrder(MerchantOrder order, String reason) {
    setState(() {
      order.status = MerchantOrderStatus.rejected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeOrdersCount = _orders.where((o) => o.status != MerchantOrderStatus.completed && o.status != MerchantOrderStatus.rejected).length;

    final tabs = [
      MerchantDashboardTab(
        isOpen: _isOpen,
        onToggleOpen: (val) => setState(() => _isOpen = val),
        todayEarnings: _todayEarnings,
        todayCompletedOrders: _todayCompletedOrders,
        orders: _orders,
        onNavigateToOrders: () => setState(() => _currentTab = 1),
        onNavigateToMenu: () => setState(() => _currentTab = 2),
        onNavigateToWallet: () => setState(() => _currentTab = 3),
        onStartCooking: _onStartCooking,
        onOpenRegistration: () => MerchantRegistrationFlow.show(context),
      ),
      MerchantOrdersTab(
        orders: _orders,
        onStartCooking: _onStartCooking,
        onMarkReady: _onMarkReady,
        onCompleteOrder: _onCompleteOrder,
        onRejectOrder: _onRejectOrder,
      ),
      MerchantMenuTab(
        menuItems: _menuItems,
        onAddMenuItem: (item) => setState(() => _menuItems.add(item)),
        onUpdateMenuItem: (item) => setState(() {}),
        onDeleteMenuItem: (id) => setState(() => _menuItems.removeWhere((i) => i.id == id)),
      ),
      MerchantWalletTab(
        activeBalance: _activeBalance,
        onBalanceUpdated: (newBal) => setState(() => _activeBalance = newBal),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: widget.onBackToCustomer,
          tooltip: 'Kembali ke Customer / Ganti Role',
        ),
        title: GestureDetector(
          onTap: () => MerchantRegistrationFlow.show(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Text(
                    'Dapur Sambal Sukaramai',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: _isOpen ? AppColors.successGreen : AppColors.dangerRed,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isOpen ? 'Gerai Buka' : 'Gerai Tutup',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _isOpen ? AppColors.successGreen : AppColors.dangerRed,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('•', style: TextStyle(color: Colors.grey, fontSize: 10)),
                  const SizedBox(width: 6),
                  const Text(
                    'Mitra FlexFood Resmi',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none, color: AppColors.textDark),
                if (activeOrdersCount > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Anda memiliki $activeOrdersCount pesanan aktif yang perlu diproses.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.store_outlined, color: AppColors.primaryPurple),
            tooltip: 'Profil & Legalitas Usaha',
            onPressed: () => MerchantRegistrationFlow.show(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentTab,
        children: tabs,
      ),
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
                _buildNavItem(0, Icons.storefront, 'Beranda'),
                _buildNavItem(
                  1,
                  Icons.receipt_long,
                  'Pesanan',
                  badge: activeOrdersCount > 0 ? '$activeOrdersCount' : null,
                ),
                _buildNavItem(2, Icons.restaurant_menu, 'Menu'),
                _buildNavItem(3, Icons.account_balance_wallet, 'Keuangan'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {String? badge}) {
    final isSelected = _currentTab == index;
    return InkWell(
      onTap: () => setState(() => _currentTab = index),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.white60,
                  size: 20,
                ),
                if (badge != null && !isSelected)
                  Positioned(
                    top: -6,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
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
