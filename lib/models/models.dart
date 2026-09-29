import 'package:flutter/material.dart';

class Service {
  final String id;
  final String category;
  final String name;
  final String description;
  final String iconName;
  final int basePrice;
  final String priceUnit;
  final double estimatedHours;
  final String defaultAttire;

  Service({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.iconName,
    required this.basePrice,
    required this.priceUnit,
    required this.estimatedHours,
    required this.defaultAttire,
  });

  factory Service.fromMap(Map<String, dynamic> m) => Service(
        id: m['id'] as String,
        category: m['category'] as String,
        name: m['name'] as String,
        description: (m['description'] ?? '') as String,
        iconName: (m['icon_name'] ?? 'sparkles') as String,
        basePrice: (m['base_price'] as num).toInt(),
        priceUnit: (m['price_unit'] ?? 'job') as String,
        estimatedHours: (m['estimated_hours'] as num?)?.toDouble() ?? 3,
        defaultAttire: (m['default_attire'] ?? 'practical') as String,
      );

  IconData get icon => _iconForName(iconName);

  static IconData _iconForName(String name) {
    switch (name) {
      case 'home':
        return Icons.home_outlined;
      case 'sparkles':
        return Icons.auto_awesome_outlined;
      case 'shirt':
        return Icons.local_laundry_service_outlined;
      case 'bed':
        return Icons.bed_outlined;
      case 'building':
        return Icons.business_outlined;
      case 'party-popper':
        return Icons.celebration_outlined;
      case 'utensils':
        return Icons.restaurant_outlined;
      case 'truck':
        return Icons.local_shipping_outlined;
      default:
        return Icons.cleaning_services_outlined;
    }
  }
}

class Worker {
  final String id;
  final String fullName;
  final String? phone;
  final String? photoUrl;
  final String area;
  final double latitude;
  final double longitude;
  final List<String> languages;
  final int experienceYears;
  final String bio;
  final int level;
  final String levelName;
  final String verificationStatus;
  final double ratingAvg;
  final int jobsCompleted;
  final List<String> badges;
  final List<String> services;
  final int expectedRate;
  final bool isOnline;
  final bool isAvailable;

  Worker({
    required this.id,
    required this.fullName,
    this.phone,
    this.photoUrl,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.languages,
    required this.experienceYears,
    required this.bio,
    required this.level,
    required this.levelName,
    required this.verificationStatus,
    required this.ratingAvg,
    required this.jobsCompleted,
    required this.badges,
    required this.services,
    required this.expectedRate,
    required this.isOnline,
    required this.isAvailable,
  });

  factory Worker.fromMap(Map<String, dynamic> m) => Worker(
        id: m['id'] as String,
        fullName: m['full_name'] as String,
        phone: m['phone'] as String?,
        photoUrl: m['photo_url'] as String?,
        area: (m['area'] ?? 'Nairobi') as String,
        latitude: (m['latitude'] as num?)?.toDouble() ?? -1.2186,
        longitude: (m['longitude'] as num?)?.toDouble() ?? 36.9089,
        languages: ((m['languages'] as List?) ?? []).cast<String>(),
        experienceYears: (m['experience_years'] as num?)?.toInt() ?? 1,
        bio: (m['bio'] ?? '') as String,
        level: (m['level'] as num?)?.toInt() ?? 1,
        levelName: (m['level_name'] ?? 'Registered Worker') as String,
        verificationStatus: (m['verification_status'] ?? 'pending') as String,
        ratingAvg: (m['rating_avg'] as num?)?.toDouble() ?? 0,
        jobsCompleted: (m['jobs_completed'] as num?)?.toInt() ?? 0,
        badges: ((m['badges'] as List?) ?? []).cast<String>(),
        services: ((m['services'] as List?) ?? []).cast<String>(),
        expectedRate: (m['expected_rate'] as num?)?.toInt() ?? 200,
        isOnline: (m['is_online'] as bool?) ?? false,
        isAvailable: (m['is_available'] as bool?) ?? true,
      );

  String get firstName => fullName.split(' ').first;
  String get initials {
    final parts = fullName.split(' ');
    return parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'
        : parts.isNotEmpty
            ? parts[0][0]
            : '?';
  }

  bool get isVerified => verificationStatus == 'verified';
  bool get isTeamLeader => level >= 3;
}

class Team {
  final String id;
  final String name;
  final String? leaderId;
  final String leaderName;
  final String area;
  final int maxSize;
  final double rating;
  final int jobsCompleted;
  final String status;

  Team({
    required this.id,
    required this.name,
    this.leaderId,
    required this.leaderName,
    required this.area,
    required this.maxSize,
    required this.rating,
    required this.jobsCompleted,
    required this.status,
  });

  factory Team.fromMap(Map<String, dynamic> m) => Team(
        id: m['id'] as String,
        name: m['name'] as String,
        leaderId: m['leader_id'] as String?,
        leaderName: (m['leader_name'] ?? '') as String,
        area: (m['area'] ?? 'Nairobi') as String,
        maxSize: (m['max_size'] as num?)?.toInt() ?? 15,
        rating: (m['rating'] as num?)?.toDouble() ?? 0,
        jobsCompleted: (m['jobs_completed'] as num?)?.toInt() ?? 0,
        status: (m['status'] ?? 'active') as String,
      );
}

class Booking {
  final String id;
  final String customerName;
  final String customerType;
  final String? serviceId;
  final String serviceName;
  final String bookingType;
  final String status;
  final String? address;
  final double latitude;
  final double longitude;
  final DateTime? scheduledDate;
  final String? scheduledTime;
  final double durationHours;
  final int workersRequired;
  final int totalPrice;
  final String? workerId;
  final String? teamId;
  final int progress;

  Booking({
    required this.id,
    required this.customerName,
    required this.customerType,
    this.serviceId,
    required this.serviceName,
    required this.bookingType,
    required this.status,
    this.address,
    required this.latitude,
    required this.longitude,
    this.scheduledDate,
    this.scheduledTime,
    required this.durationHours,
    required this.workersRequired,
    required this.totalPrice,
    this.workerId,
    this.teamId,
    required this.progress,
  });

  factory Booking.fromMap(Map<String, dynamic> m) => Booking(
        id: m['id'] as String,
        customerName: (m['customer_name'] ?? '') as String,
        customerType: (m['customer_type'] ?? 'household') as String,
        serviceId: m['service_id'] as String?,
        serviceName: (m['service_name'] ?? '') as String,
        bookingType: (m['booking_type'] ?? 'individual') as String,
        status: (m['status'] ?? 'pending') as String,
        address: m['address'] as String?,
        latitude: (m['latitude'] as num?)?.toDouble() ?? -1.2186,
        longitude: (m['longitude'] as num?)?.toDouble() ?? 36.9089,
        scheduledDate: m['scheduled_date'] != null
            ? DateTime.tryParse(m['scheduled_date'].toString())
            : null,
        scheduledTime: m['scheduled_time'] as String?,
        durationHours: (m['duration_hours'] as num?)?.toDouble() ?? 3,
        workersRequired: (m['workers_required'] as num?)?.toInt() ?? 1,
        totalPrice: (m['total_price'] as num?)?.toInt() ?? 0,
        workerId: m['worker_id'] as String?,
        teamId: m['team_id'] as String?,
        progress: (m['progress'] as num?)?.toInt() ?? 0,
      );
}

class Rating {
  final String id;
  final String fromRole;
  final String? toWorkerId;
  final int score;
  final String comment;
  final List<String> tags;

  Rating({
    required this.id,
    required this.fromRole,
    this.toWorkerId,
    required this.score,
    required this.comment,
    required this.tags,
  });

  factory Rating.fromMap(Map<String, dynamic> m) => Rating(
        id: m['id'] as String,
        fromRole: (m['from_role'] ?? 'customer') as String,
        toWorkerId: m['to_worker_id'] as String?,
        score: (m['score'] as num?)?.toInt() ?? 5,
        comment: (m['comment'] ?? '') as String,
        tags: ((m['tags'] as List?) ?? []).cast<String>(),
      );
}

class RequirementProfile {
  final String id;
  final String name;
  final String customerType;
  final String attire;
  final int arrivalMinutes;
  final String equipment;
  final String notes;

  RequirementProfile({
    required this.id,
    required this.name,
    required this.customerType,
    required this.attire,
    required this.arrivalMinutes,
    required this.equipment,
    required this.notes,
  });

  factory RequirementProfile.fromMap(Map<String, dynamic> m) =>
      RequirementProfile(
        id: m['id'] as String,
        name: m['name'] as String,
        customerType: (m['customer_type'] ?? 'hotel') as String,
        attire: (m['attire'] ?? '') as String,
        arrivalMinutes: (m['arrival_minutes'] as num?)?.toInt() ?? 30,
        equipment: (m['equipment'] ?? '') as String,
        notes: (m['notes'] ?? '') as String,
      );
}
