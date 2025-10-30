import 'package:flutter/material.dart';
import 'package:get_my_refund/components/status_tracker.dart';
import '../components/app_scaffold.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example data
    final List<TextDto> registerUpdates = [
      const TextDto('Complaint submitted via app', '2025-10-18'),
      const TextDto('Reference ID #12345 generated', '2025-10-18'),
    ];

    final List<TextDto> filedUpdates = [
      const TextDto('Formal complaint document sent', '2025-10-19'),
    ];

    final List<TextDto> remainderUpdates = [
      const TextDto('Follow-up email sent', '2025-10-22'),
    ];

    final List<TextDto> legalNotice = [
      // const TextDto('Formal complaint document sent', '2025-10-19'),
    ];

    final List<TextDto> escalatedEmail = [
      // const TextDto('Follow-up email sent', '2025-10-22'),
    ];

    return AppScaffold(
      title: 'Complaint Status',
      currentIndex: 1, // Track tab
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: ComplaintTracker(
          // 1. Set the current status
          status: ComplaintStatus.remainderSent,

          // 2. Provide the lists of updates for each stage
          complaintRegister: registerUpdates,
          formalComplaintFile: filedUpdates,
          remainderToCompany: remainderUpdates,
          legalNoticeSend: legalNotice,
          escalatedEmail: escalatedEmail,
          // refunded: refunded,

          // Other stages will show "No updates"
          // legalNoticeSend: const [],
          // escalatedEmail: const [],
          refunded: const [],

          // 3. (Optional) Customize colors
          activeColor: const Color.fromRGBO(1, 127, 55, 1),
          inActiveColor: Colors.grey.shade300,
        ),
      ),
    );
  }
}
