import 'package:flutter/material.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';
import 'src/app.dart';

void main() {
  // Register the default brand before runApp.
  BrandRegistry.instance.register(defaultBrand);

  runApp(const ShowcaseApp());
}
