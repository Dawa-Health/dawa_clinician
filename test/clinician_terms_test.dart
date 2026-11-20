import 'dart:io';

import 'package:clinician/features/terms/clinician_terms.dart';
import 'package:clinician/features/terms/clinician_terms_consent.dart';
import 'package:clinician/features/terms/clinician_terms_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clinician_navigation_test.dart' show loadNavigationFonts;

void main() {
  setUpAll(() async {
    await loadNavigationFonts();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('ClinicianTermsConsent', () {
    test('asks for agreement when nothing has been accepted', () async {
      SharedPreferences.setMockInitialValues({});
      final consent = await ClinicianTermsConsent.load();
      expect(consent.hasAcceptedCurrentTerms, isFalse);
      expect(consent.acceptedVersion, isNull);
    });

    test('remembers the accepted version and when it was accepted', () async {
      SharedPreferences.setMockInitialValues({});
      final consent = await ClinicianTermsConsent.load();
      await consent.accept(now: DateTime.utc(2026, 11, 20, 8));

      final reloaded = await ClinicianTermsConsent.load();
      expect(reloaded.hasAcceptedCurrentTerms, isTrue);
      expect(reloaded.acceptedVersion, ClinicianTerms.version);
      expect(reloaded.acceptedAt, DateTime.utc(2026, 11, 20, 8));
    });

    test('asks again after the terms change', () async {
      SharedPreferences.setMockInitialValues({
        ClinicianTermsConsent.acceptedVersionKey: ClinicianTerms.version - 1,
      });
      final consent = await ClinicianTermsConsent.load();
      expect(consent.hasAcceptedCurrentTerms, isFalse);
    });
  });

  group('ClinicianTermsPage', () {
    // Shown the way main.dart shows it: from MaterialApp.builder, above the
    // router, so nothing in it may need a navigator or overlay.
    Future<void> pumpAgreement(
      WidgetTester tester,
      Future<void> Function() onAgree, {
      Size size = const Size(390, 844),
    }) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: false),
          builder: (context, child) =>
              ClinicianTermsPage.agreement(onAgree: onAgree),
          home: const SizedBox(),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('can only continue after ticking the box', (tester) async {
      var agreed = 0;
      await pumpAgreement(tester, () async {
        agreed++;
      });
      expect(tester.takeException(), isNull);

      final button = find.byKey(const ValueKey('clinician-terms-agree-button'));
      expect(tester.widget<ElevatedButton>(button).onPressed, isNull);

      await tester.tap(
        find.byKey(const ValueKey('clinician-terms-agree-checkbox')),
      );
      await tester.pump();
      expect(tester.widget<ElevatedButton>(button).onPressed, isNotNull);

      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(agreed, 1);
    });

    testWidgets('shows the terms text', (tester) async {
      await pumpAgreement(tester, () async {});
      expect(find.text(ClinicianTerms.introduction), findsOneWidget);
      expect(find.text(ClinicianTerms.sections.first.heading), findsOneWidget);
    });

    testWidgets('fits a small phone with large text', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpAgreement(tester, () async {}, size: const Size(320, 568));
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(const ValueKey('clinician-terms-agree-button')),
        findsOneWidget,
      );
    });

    testWidgets('view mode from the account menu has no agreement controls',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(useMaterial3: false),
          home: const ClinicianTermsPage.view(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Terms and conditions'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('clinician-terms-agree-checkbox')),
        findsNothing,
      );
    });
  });

  test('the app covers the router with the terms after the splash', () {
    final main = File('lib/main.dart').readAsStringSync();
    expect(main, contains('ClinicianTermsConsent.load()'));
    expect(
      main,
      contains('ClinicianTermsPage.agreement(onAgree: _acceptTerms)'),
    );
    // The router underneath cannot be used until the terms are accepted.
    for (final guard in [
      'ExcludeFocus(',
      'ExcludeSemantics(',
      'IgnorePointer(',
    ]) {
      expect(main, contains(guard), reason: guard);
    }
    expect(main, contains('excluding: _termsPending'));
    expect(main, contains('ignoring: _termsPending'));
  });
}
