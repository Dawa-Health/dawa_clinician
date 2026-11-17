# Dawa Clinician

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](LICENSE.txt)

Dawa Clinician is the clinician-facing Flutter app from Dawa Health. It is the
care-team companion to **DawaMom**, the maternal health app for patients:
appointment requests that patients make in DawaMom come through to clinicians
here, and Dawa Clinician is the source of the clinician details DawaMom shows
when a patient books. Clinicians also use it to run point-of-care diagnostics.

The app started as a FlutterFlow project and runs on the Flutter stable
release. Its backend is Supabase. The `firebase/` folder and
`tools/firebase_to_supabase/` are kept from the move off Firebase.

## Point-of-Care Diagnostics

Dawa Clinician lets clinicians run point-of-care diagnostics for:

- Anemia
- Cervical cancer screening
- Ultrasound

## Tech Stack

- Flutter stable / Dart (originally generated with FlutterFlow)
- Supabase Auth, Postgres, Row Level Security, and Edge Functions
- Android, iOS, and web targets

## How It Connects to DawaMom

The two apps share data through Supabase:

- **Appointment requests.** DawaMom stores patient bookings in
  `public.appointments` with `status = pending` and `source = dawa_mom`.
  Clinicians review these requests in Dawa Clinician.
- **Clinical observations.** `public.encounters` holds clinician-owned clinical
  observations, plus legacy records.
- **Clinician directory.** DawaMom lists bookable clinicians through the
  `get_bookable_clinicians` RPC, which reads an imported cache of clinician
  rows. The optional `clinician-directory` Edge Function is the adapter for a
  future authoritative endpoint served from Dawa Clinician. The interface is
  described in `docs/dawa-clinician-integration-contract.md` in the DawaMom
  repository.
- **Access control.** Row Level Security policies cover the patient, doctor,
  and admin roles. A clinician should only see the appointments and records
  they are allowed to see.

Changes to shared tables, RPCs, or RLS policies affect both apps. Test them
from DawaMom and from Dawa Clinician before deploying.

## Repository Layout

| Path | Contents |
| --- | --- |
| `lib/` | App source code |
| `assets/` | Images, fonts, and other bundled files |
| `android/`, `ios/`, `web/` | Platform projects |
| `supabase/` | Supabase project files |
| `firebase/` | Legacy Firebase configuration from before the move to Supabase |
| `tools/firebase_to_supabase/` | Scripts for moving data from Firebase to Supabase |
| `docs/` | Project documentation |
| `test/` | Automated tests |
| `pubspec.yaml` | Dependencies and app metadata |
| `analysis_options.yaml` | Dart analyzer and lint rules |

## Local Checks

```powershell
flutter pub get
flutter analyze --no-pub
flutter test --no-pub
```

To measure test coverage:

```powershell
flutter test --no-pub --coverage
```

This writes a line-level report to `coverage/lcov.info`.

## Running the App

```powershell
flutter run
```

To run in a browser:

```powershell
flutter run -d chrome
```

To build the web app:

```powershell
flutter build web
```

The output is written to `build/web`.

## Runtime Configuration

The app needs a Supabase project URL and anon key. Both are public values and
are safe to ship in the Flutter client.

Service-role keys, AI provider keys, and any other private keys belong in
Supabase Edge Function secrets or backend environment variables. Never put
them in Flutter client code.

## Supabase Notes

Apply migrations to the linked project:

```powershell
supabase db push --linked
```

After changing Supabase-facing code, check:

- Clinician sign-in
- Reading and updating `public.appointments` requests from DawaMom
- Reading and writing `public.encounters`
- RLS policies for patient, doctor, and admin roles
- That DawaMom can still list and book clinicians

### Migrating from Firebase

`tools/firebase_to_supabase/` contains the scripts used to move data from the
original Firebase backend to Supabase. See that folder for usage.

## License

Dawa Clinician is free software released under the
[GNU Affero General Public License v3.0](LICENSE.txt) (AGPL-3.0). You may use,
study, modify, and share it under the terms of that license.

In particular, if you run a modified version of Dawa Clinician as a network
service, you must make the corresponding source code of your modified version
available to the users of that service, under the same license.

Copyright (C) 2026 Dawa Health.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

Dawa Clinician is not a medical device. It supports clinical work and does not
replace professional clinical judgment.

Third-party dependencies keep their own licenses.

## Contributing

By contributing to this repository, you agree that your contributions will be
licensed under the AGPL-3.0, the same license as the project.
