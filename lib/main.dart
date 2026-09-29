import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/data/repositories/aadhaar_repository.dart';
import 'package:smgi.connect/viewmodels/aadhaar_viewmodel.dart';
import 'package:smgi.connect/viewmodels/application_viewmodel.dart';
import 'package:smgi.connect/viewmodels/auth_viewmodel.dart';
import 'package:smgi.connect/viewmodels/course_viewmodel.dart';
import 'package:smgi.connect/viewmodels/document_viewmodel.dart';
import 'package:smgi.connect/viewmodels/downloads_viewmodel.dart';
import 'package:smgi.connect/viewmodels/notification_viewmodel.dart';
import 'package:smgi.connect/viewmodels/payment_viewmodel.dart';
import 'package:smgi.connect/viewmodels/personal_details_viewmodel.dart';
import 'package:smgi.connect/viewmodels/profile_viewmodel.dart';
import 'package:smgi.connect/viewmodels/referral_viewmodel.dart';


import 'app.dart';
import 'core/network/api_client.dart';

// ── Repositories ─────────────────────────────────────
import 'data/repositories/application_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/course_repository.dart';
import 'data/repositories/document_repository.dart';
import 'data/repositories/notification_repository.dart';
import 'data/repositories/payment_repository.dart';
import 'data/repositories/referral_repository.dart';

// ── ViewModels ───────────────────────────────────────


void main() {
  final apiClient = ApiClient();

  runApp(
    MultiProvider(
      providers: [
        // ── Core ─────────────────────────────────────
        Provider<ApiClient>.value(value: apiClient),

        // ── Repositories ─────────────────────────────
        Provider(create: (_) => AuthRepository(apiClient)),
        Provider(create: (_) => CourseRepository(apiClient)),
        Provider(create: (_) => DocumentRepository(apiClient)),
        Provider(create: (_) => ApplicationRepository(apiClient)),
        Provider(create: (_) => NotificationRepository(apiClient)),
        Provider(create: (_) => PaymentRepository(apiClient)),
        Provider(create: (_) => ProfileRepository(apiClient)),
        Provider(create: (_) => ReferralRepository(apiClient)),

        // ── ViewModels ───────────────────────────────
        ChangeNotifierProvider(
          create: (c) => AuthViewModel(c.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(create: (_) => AadhaarViewModel()),
        ChangeNotifierProvider(create: (_) => PersonalDetailsViewModel()),
        ChangeNotifierProvider(
          create: (c) => CourseViewModel(c.read<CourseRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => DocumentViewModel(c.read<DocumentRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => ApplicationViewModel(c.read<ApplicationRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => NotificationViewModel(c.read<NotificationRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => PaymentViewModel(c.read<PaymentRepository>()),
        ),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(
          create: (c) => DownloadsViewModel(c.read<NotificationRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => ReferralViewModel(c.read<ReferralRepository>()),
        ),
      ],
      child: const SMGIApp(),
    ),
  );
}