import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/app_scaffold.dart';
import '../services/dashboard_service.dart';
import 'case_detail.dart';
import '../components/status_tracker.dart';
import '../components/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final dashboard = DashboardService();

    // --- FIX 1: Handle the user not being logged in ---
    if (user == null) {
      return AppScaffold(
        title: 'Dashboard',
        drawer: const MyDrawer(), // This will work now
        body: const Center(child: Text('Please log in to view the dashboard.')),
      );
    }
    // --- End of Fix 1 ---

    return AppScaffold(
      title: 'Dashboard',
      drawer: const MyDrawer(), // This will also work now
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Welcome, ${user.email ?? "User"}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            'Active Cases',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          StreamBuilder(
                            stream: dashboard.watchCasesForUser(user.uid),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text('Loading...');
                              }
                              final docs = snapshot.data!.docs;
                              return Text('${docs.length}');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            'Claims Won',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹0',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder(
                stream: dashboard.watchCasesForUser(user.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(child: Text('No cases found'));
                  }
                  return ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final d = docs[index].data() as Map<String, dynamic>;
                      final caseId = docs[index].id;
                      final statusStr =
                          (d['status'] as String?) ?? 'registered';
                      return ListTile(
                        title: Text(d['title'] ?? 'Case #$caseId'),
                        subtitle: Text(
                          'Amount: ₹${d['amount'] ?? 0} • Status: $statusStr',
                        ),
                        onTap: () {
                          // For now, show case detail with mock steps
                          final mock = <TextDto>[
                            TextDto(statusStr, '2025-10-01'),
                            TextDto('Followed up', '2025-10-05'),
                          ];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CaseDetailPage(
                                caseId: caseId,
                                mockSteps: mock,
                                status: ComplaintStatus.registered,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Using TextDto and ComplaintStatus from status_tracker.dart
