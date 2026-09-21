import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smgi.connect/features/aadhar/provider/adhar_provider.dart';
import 'app.dart';
import 'features/auth/provider/auth_provider.dart';
import 'features/api/provider/api_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AadhaarProvider()),
        ChangeNotifierProvider(create: (_) => ApiProvider()),
      ],
      child: const SMGIApp(),
    ),
  );
}
