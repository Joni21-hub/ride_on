enum DriverOrderType {
  shopping, // Titip Belanja (FlexSend)
  passenger, // Antar Penumpang (FlexRide)
  food, // Pesan Makanan (FlexFood)
}

enum DriverTripStage {
  idle, // Siaga / Mencari order
  incoming, // Orderan baru masuk (countdown)
  headingToPickup, // Menuju lokasi penjemputan / toko
  atPickup, // Tiba di resto / toko / titik jemput
  delivering, // Mengantar ke tujuan
  completed, // Selesai
}

class DriverOrderItem {
  final String name;
  final String quantity;
  final int price;
  final String note;

  const DriverOrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.note = '',
  });
}

class DriverActiveOrder {
  final String orderId;
  final DriverOrderType type;
  final String customerName;
  final String customerPhone;
  final String pickupLocation;
  final String destinationLocation;
  final String distanceInfo;
  final int deliveryFee;
  final int estimatedTalangan;
  final List<String> routeStops;
  final List<DriverOrderItem> items;
  final String? storePin;
  final String? vehicleInfo;

  const DriverActiveOrder({
    required this.orderId,
    required this.type,
    required this.customerName,
    required this.customerPhone,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.distanceInfo,
    required this.deliveryFee,
    this.estimatedTalangan = 0,
    this.routeStops = const [],
    this.items = const [],
    this.storePin,
    this.vehicleInfo,
  });

  static DriverActiveOrder shoppingSample() {
    return const DriverActiveOrder(
      orderId: '#12E4S67',
      type: DriverOrderType.shopping,
      customerName: 'Gufran',
      customerPhone: '0812-9988-7711',
      pickupLocation: 'Pasar Sukaramai & Apotek Sehat Farma',
      destinationLocation: 'Jl. Kenanga No. 12 (Batuphat)',
      distanceInfo: 'Total Jarak Tempuh: 4.2 km • Estimasi: 15 menit',
      deliveryFee: 17000,
      estimatedTalangan: 145000,
      routeStops: [
        '1. 📍 Pasar Sukaramai (4 Item)',
        '2. 📍 Apotek Sehat Farma (1 Item)',
        '3. 🏠 Antar: Jl. Kenanga No. 12 (4.2 km)',
      ],
      items: [
        DriverOrderItem(name: 'Ayam Potong 1 kg', quantity: '1 kg', price: 65000, note: 'Potong 8 bagian'),
        DriverOrderItem(name: 'Bumbu Dapur Lengkap', quantity: '1 bks', price: 20000, note: 'Cabai, bawang merah'),
        DriverOrderItem(name: 'Sayur Bayam 2 Ikat', quantity: '2 ikat', price: 10000, note: 'Daun segar'),
        DriverOrderItem(name: 'Telur Ayam 1 kg', quantity: '1 kg', price: 20000, note: 'Jangan retak'),
        DriverOrderItem(name: 'Minyak Kayu Putih', quantity: '1 btl', price: 25000, note: 'Lokasi 2: Apotek Sehat Farma'),
      ],
    );
  }

  static DriverActiveOrder passengerSample() {
    return const DriverActiveOrder(
      orderId: '#12E4S69',
      type: DriverOrderType.passenger,
      customerName: 'M.Topik',
      customerPhone: '0852-6712-3344',
      pickupLocation: 'Jl. Seulawah No 10 PIM',
      destinationLocation: 'Suzuya Mall Lhokseumawe',
      distanceInfo: 'Jarak Jemput: 2.9 km • Jarak Antar: 18 km • Estimasi: 25 mnt',
      deliveryFee: 35000,
      routeStops: [
        'Titik jemput: Jl. Seulawah No 10 PIM',
        'Tujuan: Suzuya Mall Lhokseumawe',
      ],
    );
  }

  static DriverActiveOrder foodSample() {
    return const DriverActiveOrder(
      orderId: '#I2E4S68',
      type: DriverOrderType.food,
      customerName: 'Fikri',
      customerPhone: '0813-4455-8899',
      pickupLocation: 'Waroeng Bamboe',
      destinationLocation: 'Jl. Dumai, ARUN No. 101 (Fikri)',
      distanceInfo: 'Total Jarak Tempuh: 4.2 km Estimasi: 10 menit',
      deliveryFee: 15000,
      storePin: '4 0 9 2',
      routeStops: [
        'Waroeng Bamboe',
        'Jl. Dumai, ARUN No. 101 (Fikri)',
      ],
      items: [
        DriverOrderItem(name: 'Nasi Goreng Spesial', quantity: '2x', price: 30000, note: '1 pedas, 1 tidak'),
        DriverOrderItem(name: 'Nasi Goreng Telur', quantity: '1x', price: 15000, note: 'pedas'),
      ],
    );
  }
}

class DriverWalletTransaction {
  final String id;
  final String title;
  final String subtitle;
  final int amount;
  final bool isIncome;
  final DateTime date;

  const DriverWalletTransaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.date,
  });
}
