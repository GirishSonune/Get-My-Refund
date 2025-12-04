import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  State<ComplaintPage> createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _issueCtrl = TextEditingController();

  final List<PlatformFile> _files = [];
  bool _agree = false;
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _issueCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      withData: false,
    );
    if (res != null && res.files.isNotEmpty) {
      setState(() {
        final existing = _files.map((f) => '${f.name}-${f.size}').toSet();
        for (final f in res.files) {
          final key = '${f.name}-${f.size}';
          if (!existing.contains(key)) _files.add(f);
        }
      });
    }
  }

  void _removeFile(PlatformFile f) {
    setState(() => _files.remove(f));
  }

  Future<void> _submit() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok || !_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and agree to terms'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      // SMTP server configuration
      final smtpServer = gmail(
        'girish.sonune@gmail.com', // Replace with your Gmail address
        'rucg flzd qemn fzqy', // Replace with your Gmail App Password
      );

      // Prepare email content
      final emailContent =
          '''
Name: ${_nameCtrl.text.trim()}
Phone: ${_phoneCtrl.text.trim()}
Email: ${_emailCtrl.text.trim()}

Issue Details:
${_issueCtrl.text.trim()}

Attachments: ${_files.map((f) => f.name).join(', ')}
''';

      // Create email message
      final message = Message()
        ..from = Address('girish.sonune@gmail.com', 'GetMyRefund Support')
        ..recipients = ['girish.sonune@gmail.com']
        ..subject = 'New Complaint Submission - GetMyRefund'
        ..text = emailContent;

      // Add attachments
      for (final file in _files) {
        if (file.path != null) {
          message.attachments.add(
            FileAttachment(File(file.path!))
              ..fileName = file.name
              ..contentType = 'application/octet-stream',
          );
        }
      }

      // Send email
      await send(message, smtpServer);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complaint submitted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _showTermsAndConditions() async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.article, color: Colors.white),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fee Notice Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.orange[800]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'आपको आपके पैसे मिलने के बाद आप GetMyRefund को १०% राशि का भुगतान करने के लिए सहमत हैं',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[900],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You agree to pay 10% of the refunded amount after you get your money back in your original mode of payment',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Welcome Text
                    const Text(
                      'Welcome to GetMyRefund, India\'s first online platform which helps you get back what is legally yours.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Terms List
                    _buildTermItem(
                      '1',
                      'As per our conversation, please send us the details of your transaction, booking details, invoices, complaint date and one original photo id address proof of the account holder.',
                    ),
                    _buildTermItem(
                      '2',
                      'Please note that we have assured to help you get your money back as a refund in your own original mode of payment within a maximum of 90 working days. You will not be charged anything till you get your refund back. You have agreed to pay us a Success fee of 10% of the refunded amount, only AFTER you have received your refund in your original mode of payment.',
                    ),
                    _buildTermItem(
                      '3',
                      'We do not have any other hidden charges or taxes, flat 10% of the refunded amount is all you have to pay as our charges. We will always chase for a full refund but our charges of flat 10% will be applicable on any refunded amount.',
                    ),
                    _buildTermItem(
                      '4',
                      'Sending your details to us will be considered as an acknowledgement of acceptance of all our terms and conditions.',
                    ),
                    _buildTermItem(
                      '5',
                      'We will provide all support and assistance needed including filing complaints on government portals, sending legal notices if needed etc. All this will be done only with your authorization and approval. You will be kept informed about progress at each stage.',
                    ),
                    _buildTermItem(
                      '6',
                      'You agree to pay our charges of flat 10% of the refunded amount as soon as you get your money back in your original mode of payment, irrespective of the amount of legal work done. No hidden or extra charges applicable.',
                    ),
                    _buildTermItem(
                      '7',
                      'As soon as you get a refund, you have to pay us flat 10% of that refunded amount as our fee, irrespective of how much refund is still pending.',
                    ),
                    _buildTermItem(
                      '8',
                      'After you accept these terms, our charges of flat 10% are applicable on all future refunds for this particular case. You will not have to pay any fee on amounts already refunded before you send us documents.',
                    ),
                    _buildTermItem(
                      '9',
                      'Once you accept our terms or send us your documents, our charges will be applicable from that moment. Make sure you read all terms properly before accepting.',
                    ),
                    _buildTermItem(
                      '10',
                      'Failure to pay our charges as soon as you get your money back can lead to initiation of legal proceedings against you for non-payment of our dues.',
                    ),
                    const SizedBox(height: 20),

                    // Disclaimer Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Important Notice',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'GetMyRefund.in provides general consumer guidance and does not act as a law firm. We operate as an independent platform and are not affiliated with any brand, company, government body, or forum.',
                            style: TextStyle(
                              color: Colors.blue[900],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // How We Help Section
                    const Text(
                      'How We Help Consumers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'We follow a structured four-step process:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    _buildProcessStep(
                      '1',
                      'Direct Company Intervention',
                      'We reach out to the company on your behalf.',
                    ),
                    _buildProcessStep(
                      '2',
                      'Government Portals',
                      'Guide you to file complaints on official portals.',
                    ),
                    _buildProcessStep(
                      '3',
                      'Company Escalation',
                      'Connect with experts to escalate to top management.',
                    ),
                    _buildProcessStep(
                      '4',
                      'Consumer Forum',
                      'Guide on escalating to appropriate consumer forum.',
                    ),
                    const SizedBox(height: 20),

                    // Accept Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() => _agree = true);
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('I Accept Terms & Conditions'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessStep(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _dec(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: const Color(0xFFF1F4F8),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE0E3EB)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE0E3EB)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF9AA4B2)),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Submit your complaint')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Text(
                  'SUBMIT YOUR COMPLAINT',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'अपनी शिकायत दर्ज करें',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _nameCtrl,
                  decoration: _dec('Name / नाम'),
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Name required' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _phoneCtrl,
                  decoration: _dec('Phone / फोन'),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().length < 8)
                      ? 'Enter a valid phone'
                      : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _emailCtrl,
                  decoration: _dec('Email*'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    final emailOk = RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(t);
                    return emailOk ? null : 'Enter a valid email';
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _issueCtrl,
                  decoration: _dec(
                    'Your issue with the company/brand / कंपनी/ब्रांड के साथ आपकी समस्या',
                  ),
                  maxLines: 6,
                  validator: (v) => (v == null || v.trim().length < 10)
                      ? 'Please describe your issue'
                      : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Icon(Icons.attachment, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Documents to support Complaint',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    Text(
                      'Attachments (${_files.length})',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _pickFiles,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Choose files'),
                ),
                if (_files.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _files.map((f) {
                      return Chip(
                        label: Text(f.name, overflow: TextOverflow.ellipsis),
                        onDeleted: () => _removeFile(f),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 12),

                // Terms & Conditions Section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _agree ? Colors.blue : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: _agree,
                        onChanged: (v) => setState(() => _agree = v ?? false),
                        title: const Text(
                          'I agree to the terms & conditions',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      TextButton.icon(
                        onPressed: _showTermsAndConditions,
                        icon: const Icon(Icons.article_outlined, size: 20),
                        label: const Text('Read Full Terms & Conditions'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('SEND'),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'This app is protected by reCAPTCHA and the Google Privacy Policy and Terms of Service apply.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
