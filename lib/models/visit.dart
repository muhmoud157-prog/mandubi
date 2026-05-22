import 'package:cloud_firestore/cloud_firestore.dart';

class Visit {
  final String id;
  final String doctorId;
  final String doctorName;
  final DateTime visitDate;
  final String productsDetailed;
  final String sampleGiven;
  final String feedbackNotes;
  final DateTime nextFollowUpDate;
  final DateTime createdAt;

  Visit({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.visitDate,
    required this.productsDetailed,
    required this.sampleGiven,
    required this.feedbackNotes,
    required this.nextFollowUpDate,
    required this.createdAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'doctorName': doctorName,
      'visitDate': Timestamp.fromDate(visitDate),
      'productsDetailed': productsDetailed,
      'sampleGiven': sampleGiven,
      'feedbackNotes': feedbackNotes,
      'nextFollowUpDate': Timestamp.fromDate(nextFollowUpDate),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create Visit from Firestore document
  factory Visit.fromMap(Map<String, dynamic> map, String id) {
    return Visit(
      id: id,
      doctorId: map['doctorId'] as String? ?? '',
      doctorName: map['doctorName'] as String? ?? '',
      visitDate: (map['visitDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      productsDetailed: map['productsDetailed'] as String? ?? '',
      sampleGiven: map['sampleGiven'] as String? ?? '',
      feedbackNotes: map['feedbackNotes'] as String? ?? '',
      nextFollowUpDate: (map['nextFollowUpDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Copy with method
  Visit copyWith({
    String? id,
    String? doctorId,
    String? doctorName,
    DateTime? visitDate,
    String? productsDetailed,
    String? sampleGiven,
    String? feedbackNotes,
    DateTime? nextFollowUpDate,
    DateTime? createdAt,
  }) {
    return Visit(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      visitDate: visitDate ?? this.visitDate,
      productsDetailed: productsDetailed ?? this.productsDetailed,
      sampleGiven: sampleGiven ?? this.sampleGiven,
      feedbackNotes: feedbackNotes ?? this.feedbackNotes,
      nextFollowUpDate: nextFollowUpDate ?? this.nextFollowUpDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
