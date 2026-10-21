import 'package:flutter/material.dart';

enum MerchantOrderStatus {
  newOrder,
  cooking,
  readyToPickup,
  completed,
  rejected,
}

class MerchantOrderItem {
  final String name;
  final int quantity;
  final int price;
  final String? note;

  const MerchantOrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.note,
  });
}

class MerchantOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final List<MerchantOrderItem> items;
  final int totalPrice;
  final DateTime orderTime;
  MerchantOrderStatus status;
  final String? assignedDriverName;
  final String? assignedDriverPlate;
  final String? assignedDriverPhone;
  final String handoverPin;
  int cookingEstimateMinutes;

  MerchantOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.items,
    required this.totalPrice,
    required this.orderTime,
    this.status = MerchantOrderStatus.newOrder,
    this.assignedDriverName,
    this.assignedDriverPlate,
    this.assignedDriverPhone,
    this.handoverPin = '4092',
    this.cookingEstimateMinutes = 15,
  });

  String get summaryText {
    return items.map((i) => '${i.quantity}x ${i.name}').join(', ');
  }
}

class MerchantMenuItem {
  final String id;
  String name;
  String description;
  int price;
  String category; // 'Makanan Utama', 'Minuman', 'Camilan'
  bool isAvailable;
  String? imageAsset;
  List<String> variants;

  MerchantMenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.isAvailable = true,
    this.imageAsset,
    this.variants = const [],
  });
}

class MerchantTransaction {
  final String id;
  final String title;
  final String date;
  final int amount;
  final bool isCredit; // true = incoming, false = withdrawal
  final String status;

  const MerchantTransaction({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.status,
  });
}

class StoreScheduleDay {
  final String dayName;
  bool isOpen;
  TimeOfDay openTime;
  TimeOfDay closeTime;

  StoreScheduleDay({
    required this.dayName,
    this.isOpen = true,
    this.openTime = const TimeOfDay(hour: 9, minute: 0),
    this.closeTime = const TimeOfDay(hour: 21, minute: 0),
  });
}
