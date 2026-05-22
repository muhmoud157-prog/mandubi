import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String classification; // A, B, C
  final String specialty;
  final String clinicHospital;
  final String region;
  final String phoneNumber;
  final String pharmaciesNotes;
  final DateTime createdAt;
  final DateTime? lastVisit;
  final int visitCount;

  Doctor({
    required this.id,
    required this.name,
    required this.classification,
    required this.specialty,
    required this.clinicHospital,
    required this.region,
    required this.phoneNumber,
    required this.pharmaciesNotes,
    required this.createdAt,
    this.lastVisit,
    this.visitCount = 0,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'classification': classification,
      'specialty': specialty,
      'clinicHospital': clinicHospital,
      'region': region,
      'phoneNumber': phoneNumber,
      'pharmaciesNotes': pharmaciesNotes,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastVisit': lastVisit != null ? Timestamp.fromDate(lastVisit!) : null,
      'visitCount': visitCount,
    };
  }

  // Create Doctor from Firestore document
  factory Doctor.fromMap(Map<String, dynamic> map, String id) {
    return Doctor(
      id: id,
      name: map['name'] as String? ?? '',
      classification: map['classification'] as String? ?? 'A',
      specialty: map['specialty'] as String? ?? '',
      clinicHospital: map['clinicHospital'] as String? ?? '',
      region: map['region'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      pharmaciesNotes: map['pharmaciesNotes'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastVisit: (map['lastVisit'] as Timestamp?)?.toDate(),
      visitCount: map['visitCount'] as int? ?? 0,
    );
  }

  // Copy with method
  Doctor copyWith({
    String? id,
    String? name,
    String? classification,
    String? specialty,
    String? clinicHospital,
    String? region,
    String? phoneNumber,
    String? pharmaciesNotes,
    DateTime? createdAt,
    DateTime? lastVisit,
    int? visitCount,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      classification: classification ?? this.classification,
      specialty: specialty ?? this.specialty,
      clinicHospital: clinicHospital ?? this.clinicHospital,
      region: region ?? this.region,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pharmaciesNotes: pharmaciesNotes ?? this.pharmaciesNotes,
      createdAt: createdAt ?? this.createdAt,
      lastVisit: lastVisit ?? this.lastVisit,
      visitCount: visitCount ?? this.visitCount,
    );
  }
}
