import 'package:flutter/material.dart';

import '/components/dawa_design_system.dart';
import '/features/terms/clinician_terms.dart';

/// The terms and conditions screen.
///
/// [ClinicianTermsPage.agreement] is shown after the splash screen until the
/// current terms are accepted on this device. It is drawn above the app's
/// router (see `MyApp` in main.dart), which is blocked from touch, keyboard
/// and screen readers until then, so it uses no widgets that need a
/// navigator or overlay.
///
/// [ClinicianTermsPage.view] is the read-only version opened from the
/// account menu.
class ClinicianTermsPage extends StatefulWidget {
  const ClinicianTermsPage.agreement({
    super.key,
    required Future<void> Function() this.onAgree,
  });

  const ClinicianTermsPage.view({super.key}) : onAgree = null;

  /// Saves the agreement and opens the app. Null in view mode.
  final Future<void> Function()? onAgree;

  bool get asksForAgreement => onAgree != null;

  @override
  State<ClinicianTermsPage> createState() => _ClinicianTermsPageState();
}

class _ClinicianTermsPageState extends State<ClinicianTermsPage> {
  final _scrollController = ScrollController();
  bool _agreed = false;
  bool _saving = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _agree() async {
    final onAgree = widget.onAgree;
    if (onAgree == null || !_agreed || _saving) return;
    setState(() => _saving = true);
    try {
      await onAgree();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.all(DawaTokens.workspaceMobilePadding),
            child: LayoutBuilder(
              builder: (context, constraints) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _termsCard()),
                  if (widget.asksForAgreement) ...[
                    const SizedBox(height: 8),
                    // Scrolls on its own if large text makes it taller than
                    // this, so the terms and the button stay on screen.
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * 0.4,
                      ),
                      child: SingleChildScrollView(child: _agreementChoice()),
                    ),
                    const SizedBox(height: 8),
                    _agreeButton(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.asksForAgreement) {
      return Scaffold(
        backgroundColor: DawaTokens.surfaceSecondary,
        body: body,
      );
    }
    return Scaffold(
      backgroundColor: DawaTokens.surfaceSecondary,
      appBar: AppBar(
        title: Text('Terms and conditions', style: DawaTextStyles.cardTitle),
      ),
      body: body,
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            'Terms and conditions',
            style: DawaTextStyles.pageTitle.copyWith(
              color: DawaTokens.brandPrimary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Please read these terms and agree to them to use Dawa Clinician.',
          style: DawaTextStyles.secondary.copyWith(
            color: DawaTokens.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _termsCard() {
    return DawaCard(
      padding: EdgeInsets.zero,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Inside the scrolling card, so large text can never push the
              // checkbox and button off a small screen.
              if (widget.asksForAgreement) ...[
                _header(),
                const SizedBox(height: 16),
              ],
              Text(
                'Version ${ClinicianTerms.version}, effective '
                '${ClinicianTerms.effectiveDate}',
                style: DawaTextStyles.secondary.copyWith(
                  color: DawaTokens.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ClinicianTerms.introduction,
                style: DawaTextStyles.body.copyWith(
                  color: DawaTokens.textPrimary,
                ),
              ),
              for (final section in ClinicianTerms.sections) ...[
                const SizedBox(height: 20),
                Semantics(
                  header: true,
                  child: Text(
                    section.heading,
                    style: DawaTextStyles.cardTitle.copyWith(
                      color: DawaTokens.textPrimary,
                    ),
                  ),
                ),
                for (final paragraph in section.paragraphs)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      paragraph,
                      style: DawaTextStyles.body.copyWith(
                        color: DawaTokens.textSecondary,
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _agreementChoice() {
    return CheckboxListTile(
      key: const ValueKey('clinician-terms-agree-checkbox'),
      value: _agreed,
      onChanged:
          _saving ? null : (value) => setState(() => _agreed = value ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: DawaTokens.brandPrimary,
      title: Text(
        'I have read and agree to the terms and conditions.',
        style: DawaTextStyles.body.copyWith(color: DawaTokens.textPrimary),
      ),
    );
  }

  Widget _agreeButton() {
    return ElevatedButton(
      key: const ValueKey('clinician-terms-agree-button'),
      onPressed: _agreed && !_saving ? _agree : null,
      child: _saving
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: DawaTokens.textInverse,
              ),
            )
          : const Text('Agree and continue'),
    );
  }
}
