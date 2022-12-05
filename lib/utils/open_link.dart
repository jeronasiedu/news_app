import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void openLink({required BuildContext context, required String url}) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error opening url")),
    );
  }
}
