import 'package:flutter/material.dart';
import '../components/status_tracker.dart';

class CaseDetailPage extends StatelessWidget {
  final String caseId;
  final List<TextDto> mockSteps;
  final ComplaintStatus status;

  const CaseDetailPage({
    super.key,
    required this.caseId,
    required this.mockSteps,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Case Detail')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Case: $caseId',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ComplaintTracker(
                status: status,
                complaintRegister: mockSteps,
                formalComplaintFile: const [],
                remainderToCompany: const [],
                legalNoticeSend: const [],
                escalatedEmail: const [],
                refunded: const [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
