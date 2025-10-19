import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
        // Avoid duplicates by name + size
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
    if (!ok || !_agree) return;
    setState(() => _submitting = true);
    try {
      // TODO: send to backend / Firestore; attach _files paths for upload
      await Future<void>.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint submitted')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
    final canSend = (_formKey.currentState?.validate() ?? false) && _agree && !_submitting;

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
                Text('अपनी शिकायत दर्ज करें', style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _nameCtrl,
                  decoration: _dec('Name / नाम'),
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name required' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _phoneCtrl,
                  decoration: _dec('Phone / फोन'),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().length < 8) ? 'Enter a valid phone' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _emailCtrl,
                  decoration: _dec('Email*'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t);
                    return emailOk ? null : 'Enter a valid email';
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _issueCtrl,
                  decoration: _dec('Your issue with the company/brand / कंपनी/ब्रांड के साथ आपकी समस्या'),
                  maxLines: 6,
                  validator: (v) => (v == null || v.trim().length < 10) ? 'Please describe your issue' : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Icon(Icons.attachment, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text('Documents to support Complaint', style: theme.textTheme.bodyMedium),
                    const Spacer(),
                    Text('Attachments (${_files.length})', style: theme.textTheme.bodySmall),
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
                        label: Text(
                          f.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onDeleted: () => _removeFile(f),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 12),

                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _agree,
                  onChanged: (v) => setState(() => _agree = v ?? false),
                  title: const Text('I agree to the terms & conditions listed below'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: canSend ? _submit : null,
                    child: _submitting
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('SEND'),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'This app is protected by reCAPTCHA and the Google Privacy Policy and Terms of Service apply.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
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
