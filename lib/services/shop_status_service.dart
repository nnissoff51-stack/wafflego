import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShopStatusService {
  ShopStatusService._();

  static final _client = Supabase.instance.client;

  /// Get current shop status from shop_settings.id = 1
  static Future<bool> fetchIsOpen() async {
    try {
      final data = await _client
          .from('shop_settings')
          .select('is_open')
          .eq('id', 1)
          .maybeSingle(); // ✅ tak crash kalau kosong

      final open = (data?['is_open'] as bool?) ?? true;
      debugPrint("fetchIsOpen => $open");
      return open;
    } catch (e) {
      debugPrint("fetchIsOpen ERROR => $e");
      return true; // fallback
    }
  }

  /// Update shop status (id=1)
  static Future<void> setIsOpen(bool value) async {
    debugPrint("setIsOpen CALLED => $value");
    try {
      // ✅ .select() optional. Kalau nak debug boleh kekalkan.
      final res = await _client
          .from('shop_settings')
          .update({
            'is_open': value,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', 1)
          .select()
          .maybeSingle();

      debugPrint("setIsOpen RESULT => $res");
    } catch (e) {
      debugPrint("setIsOpen ERROR => $e");
      rethrow;
    }
  }

  /// Realtime subscribe updates
  static RealtimeChannel subscribe(void Function(bool isOpen) onChange) {
    final channel = _client.channel('shop_settings_channel');

    channel.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'shop_settings',
      callback: (payload) {
        final newRecord = payload.newRecord;

        final id = newRecord['id'];
        if (id != 1) return;

        final isOpen = (newRecord['is_open'] as bool?) ?? true;
        debugPrint("REALTIME UPDATE => is_open=$isOpen");
        onChange(isOpen);
      },
    );

    channel.subscribe();
    return channel;
  }

  static Future<void> unsubscribe(RealtimeChannel channel) async {
    await _client.removeChannel(channel);
  }
}
