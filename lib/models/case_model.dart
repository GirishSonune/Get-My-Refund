import 'package:cloud_firestore/cloud_firestore.dart';

// This class represents a single case document from your Firestore database.
// It's based on the columns in your "Master Sheet-2025.csv".
class CaseModel {
  final String id;
  final String customerName;
  final String email;
  final String mobile;
  final String company;
  final double amount;
  final String status;
  final DateTime? caseOpenDate;
  final String? pgPortalDetails;

  CaseModel({
    required this.id,
    required this.customerName,
    required this.email,
    required this.mobile,
    required this.company,
    required this.amount,
    required this.status,
    this.caseOpenDate,
    this.pgPortalDetails,
  });

  // Factory constructor to create a CaseModel from a Firestore document snapshot.
  factory CaseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    return CaseModel(
      id: doc.id,
      customerName: data['customerName'] ?? 'N/A',
      email: data['email'] ?? 'N/A',
      mobile: data['mobile'] ?? 'N/A',
      company: data['company'] ?? 'N/A',
      // Ensure amount is parsed correctly as a double
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? 'No Status',
      // Convert Firestore Timestamp to Dart DateTime
      caseOpenDate: (data['caseOpenDate'] as Timestamp?)?.toDate(),
      pgPortalDetails: data['pgPortalDetails'],
    );
  }
}
