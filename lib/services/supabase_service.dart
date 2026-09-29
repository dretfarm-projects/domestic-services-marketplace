import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class SupabaseService {
  static SupabaseService? _instance;
  final SupabaseClient client;

  SupabaseService._(this.client);

  static Future<SupabaseService> initialize() async {
    if (_instance != null) return _instance!;

    const url = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://0ec90b57d6e95fcbda19832f.supabase.co',
    );
    const anonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJib2x0IiwicmVmIjoiMGVjOTBiNTdkNmU5NWZjYmRhMTk4MzJmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg4ODE1NzQsImV4cCI6MTc1ODg4MTU3NH0.9I8-U0x86Ak8t2DGaIk0HfvTSL5Ayzdnz-Nw00mMkKw',
    );

    await Supabase.initialize(url: url, publishableKey: anonKey);
    _instance = SupabaseService._(Supabase.instance.client);
    return _instance!;
  }

  static SupabaseService get instance {
    assert(_instance != null, 'Call SupabaseService.initialize() first');
    return _instance!;
  }

  // ---- Services ----
  Future<List<Service>> fetchServices() async {
    final res = await client
        .from('services')
        .select()
        .eq('is_active', true)
        .order('sort_order');
    return (res as List).map((e) => Service.fromMap(e as Map<String, dynamic>)).toList();
  }

  // ---- Workers ----
  Future<List<Worker>> fetchWorkers({String? serviceFilter}) async {
    var query = client.from('workers').select();
    if (serviceFilter != null && serviceFilter.isNotEmpty) {
      query = query.contains('services', [serviceFilter]);
    }
    final res = await query.order('rating_avg', ascending: false);
    return (res as List).map((e) => Worker.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<Worker> fetchWorker(String id) async {
    final res = await client.from('workers').select().eq('id', id).maybeSingle();
    return Worker.fromMap(res as Map<String, dynamic>);
  }

  // ---- Teams ----
  Future<List<Team>> fetchTeams() async {
    final res = await client.from('teams').select().eq('status', 'active');
    return (res as List).map((e) => Team.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<List<Worker>> fetchTeamMembers(String teamId) async {
    final res = await client
        .from('team_members')
        .select('worker_id, workers(*)')
        .eq('team_id', teamId)
        .eq('status', 'active');
    final list = res as List;
    final workers = <Worker>[];
    for (final row in list) {
      final w = row['workers'];
      if (w != null) workers.add(Worker.fromMap(w as Map<String, dynamic>));
    }
    return workers;
  }

  // ---- Bookings ----
  Future<List<Booking>> fetchBookings() async {
    final res =
        await client.from('bookings').select().order('created_at', ascending: false);
    return (res as List).map((e) => Booking.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<Booking> createBooking(Map<String, dynamic> data) async {
    final res = await client.from('bookings').insert(data).select().maybeSingle();
    return Booking.fromMap(res as Map<String, dynamic>);
  }

  Future<void> updateBooking(String id, Map<String, dynamic> data) async {
    await client.from('bookings').update(data).eq('id', id);
  }

  // ---- Ratings ----
  Future<List<Rating>> fetchWorkerRatings(String workerId) async {
    final res = await client
        .from('ratings')
        .select()
        .eq('to_worker_id', workerId)
        .order('created_at', ascending: false);
    return (res as List).map((e) => Rating.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<void> createRating(Map<String, dynamic> data) async {
    await client.from('ratings').insert(data);
  }

  // ---- Requirement Profiles ----
  Future<List<RequirementProfile>> fetchRequirementProfiles() async {
    final res = await client.from('requirement_profiles').select();
    return (res as List)
        .map((e) => RequirementProfile.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
