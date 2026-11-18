# Contributing to Dawa Clinician

Thank you for helping to improve Dawa Clinician. Fixes and improvements are welcome, especially from clinicians who use the app and from people who work with the point-of-care devices.

By taking part you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md).

## Ways to contribute

- **Report a problem.** A bug, a screen that breaks at some sizes or with large text, a result shown without its device or connection state, an offline sync problem, a device that will not connect.
- **Fix or improve the app.** Screens, modules, offline support, device support and Supabase functions.
- **Add a screening tool or device.** See "Adding a screening tool" below.
- **Improve the project.** Tests, coverage and the documentation in `docs/`.

You do not need to write code to contribute. If you are not comfortable with Git, open an issue describing the problem, or email developers@dawa-health.com, and a maintainer will make the change and credit you.

## Rules for all contributions

- **No personal or patient information.** Never include names, contact details, patient records, encounters, appointments, screening results or case details from real people, even if de-identified. Use made-up patients in examples, test data and the QA screenshots in `docs/qa/`.
- **Use images you have the right to use.** Screening and ultrasound images in tests and examples must be synthetic, or come from a published dataset whose license allows it. Say where they came from.
- **No private keys or device settings.** Service-role keys, AI provider keys and other private keys belong in Supabase Edge Function secrets or backend environment variables. Never commit them, and never commit private device settings. The Supabase URL and anon key are public.
- **Only share what you have the right to share.** Do not copy text, code or images unless their license allows it, and say where they came from.
- **Health content must be accurate and safe.** Base clinical content, thresholds and wording on current national or WHO guidance, and say which in the pull request.
- **Results must stay honest.** Show device and connection problems clearly, and never present a stale or fallback result as if it were fresh. Every result is decision support, not a diagnosis.

## Reporting a problem

Open an issue and include:

- the screen or care tool, and what you were doing;
- what went wrong, and what you expected;
- your platform (Android, iOS or web), your screen size, and whether you were offline;
- the device and what its status indicator showed, for device problems;
- a source, for clinical corrections.

For a security vulnerability, or personal information that has been published by mistake, do not open a public issue. Email developers@dawa-health.com.

## Making a change

Nobody commits directly to `main`. All changes go through a pull request.

1. Open an issue first for anything larger than a small fix, so it can be discussed before you do the work. Adding a screening tool or device, changing analysis or fallback rules, or changing shared Supabase tables, RPCs, RLS policies or sync functions always needs an issue.

2. Fork the repository and create a branch. Name it after the change:

   ```
   git checkout -b fix/cacx-draft-sync
   git checkout -b add/bp-monitor-history
   git checkout -b docs/edge-device-setup
   ```

3. Make the change. See "Working on the code" below.

4. Run the checks on your machine. See "Checks" below.

5. Commit with a short message that says what changed and where:

   ```
   Fix offline sync of cervical scan drafts
   ```

6. Open a pull request against `main`. Say what changed, why, and how you tested it, including the screen sizes and devices you used. Link the issue it resolves. If the change should be in the changelog, add a line to `docs/changelog.md`.

7. Respond to review. Push further commits to the same branch. A maintainer merges the pull request once it is approved and the checks pass.

## Working on the code

- **Put new work in the right place.** New features go in `lib/features/`, split into `data/`, `domain/` and `presentation/` like `lib/features/appointments/`. Shared UI goes in `lib/components/` and services in `lib/services/`. Do not add new work to the generated code in `lib/flutter_flow/`.
- **Use the design system.** Take colours, spacing and navigation styles from `dawa_design_system.dart` and `navigation_design_system.dart`.
- **Keep the compatibility layer stable.** Changes to `supabase_firestore_compat.dart` must keep `legacy_query_contract_test.dart` and `legacy_record_contract_test.dart` passing. If you need to change a contract test, explain why in the pull request.
- **Work offline.** Clinical reads and writes go through `supabase_offline_cache.dart` and `clinical_offline_store.dart`, so they keep working without a connection and sync when it returns.
- **Sync through the outbox.** Changes that must reach DawaMom are written to an outbox table and delivered by a scheduled function, so a failed delivery is retried instead of lost.
- **Document configuration.** Add new environment variables and device settings to `docs/environment-variables.md`.
- **Keep changes small.** One module or one kind of fix per pull request is easier to review.

### Supabase changes

Apply migrations to the linked project:

```
supabase db push --linked
```

After changing Supabase-facing code, check:

- clinician sign-in;
- reading and updating `public.appointments` requests from DawaMom;
- reading and writing `public.encounters`;
- RLS policies for the patient, doctor and admin roles;
- that DawaMom can still list and book clinicians.

Shared tables, RPCs and RLS policies are used by DawaMom too. Test changes to them from both apps before deploying.

## Checks

Before opening a pull request, run:

```
flutter pub get
flutter analyze --no-pub
flutter test --no-pub
```

Where it applies, also:

- run `tool/verify_coverage.sh` when you touch a module listed in `tool/coverage_required_sources.txt`;
- review changed screens in the collapsed sidebar, desktop, laptop, tablet, mobile and large-text layouts;
- for device work, run the mock-hub tests first, then the live device tests against real hardware.

Live device and Supabase tests need real hardware or a real project, so they are not part of the default run. Say in the pull request whether you ran them.

## Adding a screening tool

Open an issue first. The proposal should name the clinical reviewer, say which model or device does the analysis and how it was validated, and set out the analysis policy, including whether an online fallback is allowed when the device is unavailable.

Build the tool as a module with a controller, a repository, a service and a screen, like `application/hemonix/`, and register it in `care_tool_registry.dart`. Write down its fallback rules in `docs/`, as the existing tools do.

## Review and approval

| Change | Approvals needed |
| --- | --- |
| Documentation, tests and UI | One maintainer |
| Screening tools, analysis and fallback rules, and clinical content | One maintainer and one clinical reviewer |
| Supabase schema, RLS policies, shared tables and sync functions | One maintainer, after testing from both Dawa Clinician and DawaMom |
| Device integration | One maintainer, after the mock-hub and live device tests |

A change that falls under more than one row needs all of those approvals. Reviewers check that the change is accurate and safe, contains no personal information, keys or private device settings, and does not weaken how health data is protected. Maintainers aim to give a first response within seven days.

## Credit

Contributors are credited through their commits and, where a change is listed there, in `docs/changelog.md`. When a maintainer makes a change for you from an issue or an email, they credit you as a co-author.

## License

The project is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0). By submitting a contribution you agree that it is licensed under the same terms, and you confirm that you have the right to submit it. Third-party dependencies keep their own licenses.

## Questions

Open an issue, or email developers@dawa-health.com.
