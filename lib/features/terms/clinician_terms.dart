/// Dawa Clinician's terms and conditions, shown after the splash screen until
/// they are accepted on a device, and from the account menu at any time.
///
/// DRAFT: written from what the app actually does. Have it reviewed by a
/// lawyer (including the liability and data-protection wording, and which
/// country's law applies) before release.
///
/// To change the terms: edit the text, raise [ClinicianTerms.version] by one
/// and update [ClinicianTerms.effectiveDate]. Everyone who agreed to an older
/// version is asked to agree again the next time they open the app.
abstract final class ClinicianTerms {
  static const version = 1;
  static const effectiveDate = '30 April 2026';

  static const introduction =
      'These terms explain how you may use Dawa Clinician, an app from Dawa '
      'Health for health workers and clinic staff. Please read them '
      'carefully. By tapping "Agree and continue", you accept them.';

  static const sections = <ClinicianTermsSection>[
    ClinicianTermsSection('1. About Dawa Clinician', [
      'Dawa Clinician helps care teams register patients, record encounters, '
          'manage appointments, and run point-of-care screenings. It works '
          'with DawaMom, the app for mothers, and is provided by Dawa Health.',
    ]),
    ClinicianTermsSection('2. Who may use it', [
      'Only health workers and staff who have been given an account by a '
          'participating clinic or by Dawa Health may use Dawa Clinician, and '
          'only for their work.',
      'Use only your own account. Keep your password and administrator PIN '
          'private, and do not let anyone else work while you are signed in. '
          'Sign out on shared devices.',
    ]),
    ClinicianTermsSection('3. Your clinical judgment comes first', [
      'Dawa Clinician supports clinical work. It is not a medical device and '
          'does not replace your professional judgment.',
      'Screening results come from AI models and devices that can be wrong. '
          'Treat every result as decision support, confirm it using your '
          'training and your clinic\'s protocols, and refer patients when '
          'needed. You remain responsible for the clinical decisions you make.',
      'If a patient may be in an emergency, follow your clinic\'s emergency '
          'procedure.',
    ]),
    ClinicianTermsSection('4. Patient information and confidentiality', [
      'Open and record information only about patients you are caring for or '
          'are authorised to see. Keep all patient information confidential, '
          'and follow your clinic\'s policies and the data protection laws '
          'that apply where you work.',
      'Make sure patients are informed, and give consent where it is '
          'required, before you capture images or run screenings.',
      'Do not copy, export, photograph or share patient information outside '
          'Dawa Clinician unless your clinic\'s policy and the law allow it.',
    ]),
    ClinicianTermsSection('5. Working offline', [
      'So that you can keep working without a connection, Dawa Clinician '
          'stores some patient information on your device until it syncs. '
          'Keep your device locked with a PIN, password or fingerprint, and '
          'report a lost or stolen device to your clinic straight away.',
    ]),
    ClinicianTermsSection('6. Online analysis', [
      'Screening images are analysed on the point-of-care device first. When '
          'the device is not available, some tools may send images to Dawa '
          'Health\'s online analysis services, as set out for each tool. '
          'Make sure patients know this can happen.',
    ]),
    ClinicianTermsSection('7. Information shared with DawaMom', [
      'Appointment requests, appointment status changes, the service catalog '
          'and risk alerts are shared between Dawa Clinician and DawaMom. '
          'Mothers see the status updates you make to their appointments, so '
          'keep them accurate.',
    ]),
    ClinicianTermsSection('8. Using Dawa Clinician fairly', [
      'Do not try to access information you are not authorised to see, '
          'interfere with the service or its devices, or use Dawa Clinician '
          'for anything unlawful or harmful. If you find a security problem, '
          'report it to Dawa Health and do not use it.',
    ]),
    ClinicianTermsSection('9. Open source', [
      'The Dawa Clinician source code is free software, released under the '
          'GNU Affero General Public License version 3. These terms cover '
          'your use of the Dawa Clinician service. The licence covers the '
          'code.',
    ]),
    ClinicianTermsSection('10. Availability and changes', [
      'We work to keep Dawa Clinician available and accurate, but we cannot '
          'promise that it, the devices it connects to, or the online '
          'services will always work without interruptions or errors. We may '
          'change or stop features.',
      'As far as the law allows, Dawa Health is not responsible for loss or '
          'harm caused by relying on a screening result or other information '
          'in Dawa Clinician without appropriate clinical judgment.',
      'If we change these terms in a way that matters, we will ask you to '
          'read and agree to them again.',
    ]),
    ClinicianTermsSection('11. Contact us', [
      'If you have questions about these terms, contact your clinic '
          'administrator or Dawa Health at dawa-health.com.',
    ]),
  ];
}

class ClinicianTermsSection {
  const ClinicianTermsSection(this.heading, this.paragraphs);

  final String heading;
  final List<String> paragraphs;
}
