import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_mind/features/app/green_mind_app.dart';
import 'package:green_mind/global/di/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleFonts.pendingFonts([GoogleFonts.cairo()]);
  await configureDependencies();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      body: Center(child: Text('حدث خطأ غير متوقع: ${details.exception}')),
    );
  };

  runApp(const GreenMindApp());
}
