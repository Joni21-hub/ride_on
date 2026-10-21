import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://wtiwipevagosjupgzwlf.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_-KKzpEWLHY2dKgi4zC_nTw_3Ba3Q7v-',
  );

  static bool _isInitialized = false;

  /// Initialize Supabase Flutter SDK
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: kDebugMode,
      );
      _isInitialized = true;
      debugPrint('[SupabaseService] Connected to $supabaseUrl');
    } catch (e) {
      debugPrint('[SupabaseService] Initialization failed or already initialized: $e');
      _isInitialized = true;
    }
  }

  /// Supabase Client instance
  static SupabaseClient get client => Supabase.instance.client;

  /// Current authenticated user
  static User? get currentUser => client.auth.currentUser;

  /// Current user ID
  static String? get currentUserId => client.auth.currentUser?.id;

  /// Stream of auth changes
  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // ===========================================================================
  // AUTHENTICATION
  // ===========================================================================

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  // ===========================================================================
  // USER PROFILES & WALLET
  // ===========================================================================

  static Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      debugPrint('[SupabaseService] Error getProfile: $e');
      return null;
    }
  }

  static Future<void> upsertProfile(Map<String, dynamic> profileData) async {
    await client.from('profiles').upsert(profileData);
  }

  static Future<void> updateWalletBalance(String userId, double newBalance) async {
    await client.from('profiles').update({
      'wallet_balance': newBalance,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);
  }

  // ===========================================================================
  // ORDERS (Titip Belanja, FlexFood, FlexRide, FlexSend)
  // ===========================================================================

  static Future<Map<String, dynamic>?> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await client
          .from('orders')
          .insert(orderData)
          .select()
          .single();
      return response;
    } catch (e) {
      debugPrint('[SupabaseService] Error createOrder: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getOrder(String orderId) async {
    try {
      final response = await client
          .from('orders')
          .select('*, driver:profiles!driver_id(*), customer:profiles!customer_id(*)')
          .eq('id', orderId)
          .maybeSingle();
      return response;
    } catch (e) {
      debugPrint('[SupabaseService] Error getOrder: $e');
      return null;
    }
  }

  static Future<void> updateOrderStatus(
    String orderId,
    String status, {
    Map<String, dynamic>? extraFields,
  }) async {
    final Map<String, dynamic> updateData = {
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
      ...?extraFields,
    };

    await client.from('orders').update(updateData).eq('id', orderId);
  }

  /// Real-time stream for order tracking screen
  static Stream<List<Map<String, dynamic>>> streamOrder(String orderId) {
    return client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('id', orderId);
  }

  /// Real-time stream for driver radar (orders looking for driver)
  static Stream<List<Map<String, dynamic>>> streamAvailableOrders() {
    return client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('status', 'searching_driver')
        .order('created_at', ascending: false);
  }

  /// Real-time stream for merchant kitchen
  static Stream<List<Map<String, dynamic>>> streamMerchantOrders(String merchantId) {
    return client
        .from('orders')
        .stream(primaryKey: ['id'])
        .eq('merchant_id', merchantId)
        .order('created_at', ascending: false);
  }

  // ===========================================================================
  // CHAT SYSTEM
  // ===========================================================================

  static Future<void> sendChatMessage({
    required String orderId,
    required String senderId,
    required String senderRole,
    required String message,
    String? imageUrl,
  }) async {
    await client.from('chat_messages').insert({
      'order_id': orderId,
      'sender_id': senderId,
      'sender_role': senderRole,
      'message': message,
      'image_url': imageUrl,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Stream<List<Map<String, dynamic>>> streamChatMessages(String orderId) {
    return client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('order_id', orderId)
        .order('created_at', ascending: true);
  }

  // ===========================================================================
  // DRIVER GPS TRACKING
  // ===========================================================================

  static Future<void> updateDriverLocation({
    required String driverId,
    required double latitude,
    required double longitude,
    bool isActive = true,
    double? maxCashCapital,
  }) async {
    await client.from('driver_locations').upsert({
      'driver_id': driverId,
      'latitude': latitude,
      'longitude': longitude,
      'is_active': isActive,
      'max_cash_capital': ?maxCashCapital,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  static Stream<List<Map<String, dynamic>>> streamDriverLocation(String driverId) {
    return client
        .from('driver_locations')
        .stream(primaryKey: ['driver_id'])
        .eq('driver_id', driverId);
  }

  // ===========================================================================
  // MERCHANT MENU & CATALOG
  // ===========================================================================

  static Future<List<Map<String, dynamic>>> getMerchantMenuItems(String merchantId) async {
    try {
      final response = await client
          .from('merchant_menu_items')
          .select()
          .eq('merchant_id', merchantId)
          .order('category', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('[SupabaseService] Error getMerchantMenuItems: $e');
      return [];
    }
  }

  static Future<void> updateMenuItemAvailability(String itemId, bool isAvailable) async {
    await client
        .from('merchant_menu_items')
        .update({'is_available': isAvailable})
        .eq('id', itemId);
  }
}
