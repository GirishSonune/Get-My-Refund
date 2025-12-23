import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_my_refund/components/status_tracker.dart';
import '../components/app_scaffold.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const AppScaffold(
        title: 'Complaint Status',
        currentIndex: 1,
        body: Center(child: Text('Please login to view your complaints')),
      );
    }

    return AppScaffold(
      title: 'Complaint Status',
      currentIndex: 1,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .limit(1) // Currently showing only the latest complaint
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'No complaints found.\nSubmit a complaint to track its status.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }

          final doc = snapshot.data!.docs.first;
          final data = doc.data() as Map<String, dynamic>;
          final statusStr = data['status'] as String? ?? 'registered';
          
          // Filter updates by stage for the UI
          // This is a simplification; ideally, we'd structure the data to match the UI better
          // or have logic to distribute updates.
          // For now, we'll put all updates in the 'register' bucket or try to guess.
          // A better approach for the future is to have separate arrays in Firestore for each stage.
          
          // Helper to filter updates based on some criteria if we had it. 
          // Since we just have a flat list of updates in the proposed schema, 
          // we might need to adjust the schema or just show them all in the first valid slot 
          // or try to parse the 'stage' field I added.
          
          List<TextDto> getUpdatesForStage(String stage) {
             return (data['updates'] as List<dynamic>? ?? [])
                 .where((u) => (u as Map<String, dynamic>)['stage'] == stage)
                 .map((u) => TextDto(u['title'] as String?, u['date'] as String?))
                 .toList();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: ComplaintTracker(
              status: _parseStatus(statusStr),
              complaintRegister: getUpdatesForStage('registered'),
              formalComplaintFile: getUpdatesForStage('filed'),
              remainderToCompany: getUpdatesForStage('remainderSent'),
              legalNoticeSend: getUpdatesForStage('legalNoticeSent'),
              escalatedEmail: getUpdatesForStage('escalated'),
              refunded: getUpdatesForStage('refunded'),
              activeColor: const Color.fromRGBO(1, 127, 55, 1),
              inActiveColor: Colors.grey.shade300,
            ),
          );
        },
      ),
    );
  }

  ComplaintStatus _parseStatus(String status) {
    switch (status) {
      case 'registered': return ComplaintStatus.registered;
      case 'filed': return ComplaintStatus.filed;
      case 'remainderSent': return ComplaintStatus.remainderSent;
      case 'legalNoticeSent': return ComplaintStatus.legalNoticeSent;
      case 'escalated': return ComplaintStatus.escalated;
      case 'refunded': return ComplaintStatus.refunded;
      default: return ComplaintStatus.registered;
    }
  }
}
