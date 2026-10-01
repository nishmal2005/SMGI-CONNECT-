import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/constants/api_endpoints.dart';
import 'core/network/api_client.dart';

// ── Repositories ─────────────────────────────────────
import 'data/repositories/aadhaar_repository.dart';
import 'data/repositories/application_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/course_repository.dart';
import 'data/repositories/document_repository.dart';
import 'data/repositories/notification_repository.dart';
import 'data/repositories/payment_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'data/repositories/referral_repository.dart';

// ── ViewModels ───────────────────────────────────────
import 'viewmodels/aadhaar_viewmodel.dart';
import 'viewmodels/application_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/course_viewmodel.dart';
import 'viewmodels/document_viewmodel.dart';
import 'viewmodels/downloads_viewmodel.dart';
import 'viewmodels/notification_viewmodel.dart';
import 'viewmodels/payment_viewmodel.dart';
import 'viewmodels/personal_details_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/referral_viewmodel.dart';

// ── Screens ──────────────────────────────────────────
import 'views/auth/login_screen.dart';

void main() {
  ApiEndpoints.validate();

  final apiClient = ApiClient();
  final authVm = AuthViewModel(AuthRepository(apiClient));

  /// Push the LoginScreen and wipe the navigation stack.
  void goToLogin() {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  // Session expired → logout and redirect.
  apiClient.onSessionExpired = () {
    authVm.forceLogout();
    // forceLogout fires onLoggedOut which navigates.
  };

  // Logout complete → redirect.
  authVm.onLoggedOut = goToLogin;

  runApp(
    MultiProvider(
      providers: [
        // ── Core ─────────────────────────────────────
        Provider<ApiClient>.value(value: apiClient),

        // ── Repositories ─────────────────────────────
        Provider(create: (_) => AuthRepository(apiClient)),
        Provider(create: (_) => AadhaarRepository(apiClient)),
        Provider(create: (_) => ProfileRepository(apiClient)),
        Provider(create: (_) => CourseRepository(apiClient)),
        Provider(create: (_) => DocumentRepository(apiClient)),
        Provider(create: (_) => ApplicationRepository(apiClient)),
        Provider(create: (_) => NotificationRepository(apiClient)),
        Provider(create: (_) => PaymentRepository(apiClient)),
        Provider(create: (_) => ReferralRepository(apiClient)),

        // ── ViewModels ───────────────────────────────
        ChangeNotifierProvider.value(value: authVm),
        ChangeNotifierProvider(
          create: (c) => AadhaarViewModel(c.read<AadhaarRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => PersonalDetailsViewModel(c.read<ProfileRepository>()),
        ),
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
          create: (c) =>
              NotificationViewModel(c.read<NotificationRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => PaymentViewModel(c.read<PaymentRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => DownloadsViewModel(c.read<NotificationRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => ReferralViewModel(c.read<ReferralRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => ProfileViewModel(c.read<ProfileRepository>()),
        ),
      ],
      child: const SMGIApp(),
    ),
  );
}