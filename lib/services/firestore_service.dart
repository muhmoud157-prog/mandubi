import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mandubi/models/doctor.dart';
import 'package:mandubi/models/visit.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  const FirebaseFirestore.

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  // ==================== Doctors ====================
  Future<Doctor> addDoctor(Doctor doctor) async {
    try {
      final docId = doctor.id.isEmpty ? const Uuid().v4() : doctor.id;
      await _firestore.collection('doctors').doc(docId).set(
        doctor.copyWith(id: docId).toMap(),
      );
      return doctor.copyWith(id: docId);
    } catch (e) {
      throw Exception('Error adding doctor: $e');
    }
  }

  Future<void> updateDoctor(Doctor doctor) async {
    try {
      await _firestore.collection('doctors').doc(doctor.id).update(
        doctor.toMap(),
      );
    } catch (e) {
      throw Exception('Error updating doctor: $e');
    }
  }

  Future<void> deleteDoctor(String doctorId) async {
    try {
      await _firestore.collection('doctors').doc(doctorId).delete();
      // Delete all visits for this doctor
      final visitsSnapshot = await _firestore
          .collection('visits')
          .where('doctorId', isEqualTo: doctorId)
          .get();
      for (final doc in visitsSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Error deleting doctor: $e');
    }
  }

  Future<Doctor?> getDoctor(String doctorId) async {
    try {
      final snapshot = await _firestore.collection('doctors').doc(doctorId).get();
      if (snapshot.exists) {
        return Doctor.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting doctor: $e');
    }
  }

  Future<List<Doctor>> getAllDoctors() async {
    try {
      final snapshot = await _firestore
          .collection('doctors')
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Doctor.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error getting doctors: $e');
    }
  }

  Future<List<Doctor>> getDoctorsByClassification(String classification) async {
    try {
      final snapshot = await _firestore
          .collection('doctors')
          .where('classification', isEqualTo: classification)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Doctor.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error getting doctors by classification: $e');
    }
  }

  Stream<List<Doctor>> getDoctorsStream() {
    return _firestore
        .collection('doctors')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Doctor.fromMap(doc.data(), doc.id))
            .toList());
  }

  // ==================== Visits ====================
  Future<Visit> addVisit(Visit visit) async {
    try {
      final visitId = visit.id.isEmpty ? const Uuid().v4() : visit.id;
      final newVisit = visit.copyWith(id: visitId);
      
      await _firestore.collection('visits').doc(visitId).set(
        newVisit.toMap(),
      );

      // Update doctor's last visit
      await _firestore.collection('doctors').doc(visit.doctorId).update({
        'lastVisit': Timestamp.now(),
        'visitCount': FieldValue.increment(1),
      });

      return newVisit;
    } catch (e) {
      throw Exception('Error adding visit: $e');
    }
  }

  Future<void> updateVisit(Visit visit) async {
    try {
      await _firestore.collection('visits').doc(visit.id).update(
        visit.toMap(),
      );
    } catch (e) {
      throw Exception('Error updating visit: $e');
    }
  }

  Future<void> deleteVisit(String visitId) async {
    try {
      await _firestore.collection('visits').doc(visitId).delete();
    } catch (e) {
      throw Exception('Error deleting visit: $e');
    }
  }

  Future<Visit?> getVisit(String visitId) async {
    try {
      final snapshot = await _firestore.collection('visits').doc(visitId).get();
      if (snapshot.exists) {
        return Visit.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting visit: $e');
    }
  }

  Future<List<Visit>> getAllVisits() async {
    try {
      final snapshot = await _firestore
          .collection('visits')
          .orderBy('visitDate', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Visit.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error getting visits: $e');
    }
  }

  Future<List<Visit>> getVisitsByDoctor(String doctorId) async {
    try {
      final snapshot = await _firestore
          .collection('visits')
          .where('doctorId', isEqualTo: doctorId)
          .orderBy('visitDate', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => Visit.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Error getting visits by doctor: $e');
    }
  }

  Stream<List<Visit>> getVisitsStream() {
    return _firestore
        .collection('visits')
        .orderBy('visitDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Visit.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<Visit>> getVisitsByDoctorStream(String doctorId) {
    return _firestore
        .collection('visits')
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('visitDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Visit.fromMap(doc.data(), doc.id))
            .toList());
  }
}
