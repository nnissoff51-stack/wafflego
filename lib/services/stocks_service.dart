import 'package:supabase_flutter/supabase_flutter.dart';

class StocksService {
  StocksService._();

  static final _client = Supabase.instance.client;

  // Fetch all stocks
  static Future<List<Map<String, dynamic>>> fetchStocks() async {
    final data = await _client
        .from('stocks')
        .select('id, item_name, price, quantity')
        .order('item_name');

    return List<Map<String, dynamic>>.from(data as List);
  }

  // Realtime subscribe (bila ada update quantity)
  static RealtimeChannel subscribe(void Function() onChange) {
    final channel = _client.channel('stocks_channel');

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'stocks',
          callback: (_) => onChange(),
        )
        .subscribe();

    return channel;
  }

  static Future<void> unsubscribe(RealtimeChannel channel) async {
    await _client.removeChannel(channel);
  }
}
