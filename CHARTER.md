# Dawa Clinician Project Charter

This charter describes what the Dawa Clinician project is for, what it covers, who is responsible for it and how decisions are made. It applies to everything in this repository.

## 1. Mission

Dawa Clinician exists to give maternal health care teams a reliable point-of-care workspace for registering patients, recording encounters, managing appointments and running screening. It works in clinics with or without an internet connection, and connects care teams to patients who use DawaMom.

## 2. Goals

- Give clinicians screening tools whose results are clear about where they came from and are always confirmed by clinical judgment.
- Keep core workflows working offline, and sync results when the connection returns.
- Connect clinicians and patients through DawaMom: appointment requests, the clinician directory, risk alerts and the service catalog.
- Work with point-of-care devices on the clinic's local network.
- Protect patient identities, records and images.
- Work at every screen size, from mobile to desktop, and with large text.
- Keep the code open, tested and documented.

## 3. Scope

**In scope**

- The Flutter app (`lib/`) and its Android, iOS and web projects.
- Supabase migrations, Edge Functions, SQL tests and admin scripts (`supabase/`), including the sync with DawaMom.
- The edge device client, the device contract, the development proxy and the device self-test.
- Tests, coverage tools, documentation and QA screenshots (`test/`, `tool/`, `docs/`).
- The scripts used to move data from Firebase to Supabase (`tools/firebase_to_supabase/`).
- New screening tools and devices, and corrections to clinical content.

**Out of scope**

- Personal, patient or user data of any kind, including de-identified records.
- Screening model weights and training code, and the software that runs on edge devices. This repository holds the app and the contract it uses to talk to devices.
- DawaMom, which has its own repository. The tables, functions and contract the two apps share are agreed between both projects.
- Diagnosis. Dawa Clinician is not a medical device and does not replace professional clinical judgment.
- Content that Dawa Health or the contributor does not have the right to share.

## 4. Principles

- **Clinical judgment first.** Results are decision support. A stale or fallback result is never presented as fresh, and device and connection problems are shown clearly. Clinical content and screening tools are reviewed by a qualified health professional before they are merged.
- **Works where care happens.** Core workflows work offline, and devices are reached on the clinic's own network.
- **Privacy and security.** Nothing that could identify a person is accepted into the repository. Screening images in tests and examples are synthetic or come from a published dataset whose license allows it. Row Level Security protects every shared table, sensitive administrator actions need a PIN, and private keys never ship in the app.
- **Shared responsibility with DawaMom.** Changes to shared tables, functions and policies are tested from both apps.
- **Openness.** The code and its history are public. Known problems are recorded, not hidden.

## 5. Roles and responsibilities

| Role | Responsibilities |
| --- | --- |
| Project steward (Dawa Health) | Owns the repository, holds the copyright, sets direction and appoints maintainers. |
| Maintainers | Review and merge pull requests, cut releases, keep documentation and tests current, and enforce this charter and the Code of Conduct. |
| Clinical reviewers | Check screening tools, analysis and fallback rules, and clinical content for accuracy and safety. At least one must approve any change to them. |
| Contributors | Anyone who opens an issue or pull request. Contributors follow the contributing guide and the Code of Conduct. |

Current maintainers and reviewers:

| Name | Role | Area |
| --- | --- | --- |
| Tariro F Munzwa | Maintainer | Repository and releases |
| Tafadzwa K Munzwa, MD | Clinical reviewer | Screening tools and clinical content |

## 6. Decision making

- Day-to-day changes are decided by pull request review. A change is merged when it has the approvals in section 7 and the checks pass.
- Maintainers aim for consensus. If maintainers cannot agree, the project steward decides.
- Larger changes need an issue for discussion first, open for at least seven days. These include adding a screening tool or device, changing analysis or fallback rules, changing the tables, functions, RLS policies or integration contract shared with DawaMom, and changing the license.
- Changes to anything shared with DawaMom are agreed with the DawaMom maintainers before they are merged.
- An urgent fix for a safety, security or privacy problem can be merged without the seven-day wait. It is discussed in an issue afterwards.
- Clinical disagreements are settled by the clinical reviewers, with reference to current national and WHO guidance. Where guidance differs between countries, the content says which it follows.

## 7. How changes are made

1. Open an issue describing the problem or proposal, unless the change is a small fix.
2. Create a branch and make the change. Nobody commits directly to `main`.
3. Open a pull request that says what changed, why, and how it was tested, including the screen sizes and devices used.
4. Run `flutter analyze` and `flutter test`, and any other checks the change needs, as described in the contributing guide.
5. Review and approval:
   - any change: one maintainer;
   - screening tools, analysis and fallback rules, and clinical content: one maintainer and one clinical reviewer;
   - Supabase schema, RLS policies, shared tables and sync functions: one maintainer, after testing from both Dawa Clinician and DawaMom;
   - device integration: one maintainer, after the mock-hub and live device tests.
6. A maintainer merges the pull request.

Details are in [CONTRIBUTING.md](CONTRIBUTING.md).

## 8. Quality

- Every pull request passes `flutter analyze` and `flutter test`. The source files listed in `tool/coverage_required_sources.txt` stay covered.
- Contract tests pin the Firestore compatibility layer, and the sync functions have fixture-based tests.
- Changed screens are reviewed in the collapsed sidebar, desktop, laptop, tablet, mobile and large-text layouts.
- Device work is tested against the mock hub, then against real hardware.
- A sample of real screenings is reviewed regularly with clinicians, and corrections are fed back into the models and the app. Patient data from those reviews never enters this repository.
- Verification reports and QA audits are kept in `docs/`. Known problems are tracked in issues until they are fixed.
- Corrections from clinicians are treated as a priority.

## 9. Releases

- Releases use version numbers of the form MAJOR.MINOR.PATCH.
  - MAJOR: a change that DawaMom, the devices or existing deployments must act on, such as a change to shared tables, sync functions or the device contract.
  - MINOR: new features, screening tools or devices.
  - PATCH: fixes, corrections and documentation.
- Each release has a tag and an entry in `docs/changelog.md`.
- Any change to a screening tool's analysis or fallback rules is named in the changelog.

## 10. License and contributions

The project is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0). Copyright is held by Dawa Health. Contributions are accepted under the same license, and contributors confirm they have the right to share what they submit. Third-party dependencies keep their own licenses.

## 11. Code of Conduct

Everyone taking part in the project follows the [Code of Conduct](CODE_OF_CONDUCT.md). Reports go to developers@dawa-health.com.

## 12. Funding and independence

Where the project receives outside funding, funders do not decide what is merged; that is decided through the process in this charter.

## 13. Changes to this charter

Changes to this charter or to the Code of Conduct are proposed by pull request, discussed in an issue for at least seven days, and approved by the project steward.

## Contact

developers@dawa-health.com
