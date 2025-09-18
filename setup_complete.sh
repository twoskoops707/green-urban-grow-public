#!/bin/bash

# Create assets directory
mkdir -p assets

# Add example TFLite model file (replace with your actual model bytes)
echo -n > assets/model.tflite

# Create labels.txt
cat > assets/labels.txt << 'LABELS'
Rose
Tulip
Sunflower
Daisy
Orchid
LABELS

# Create care_tips.json
cat > assets/care_tips.json << 'CARE'
{
  "Rose": "Water daily, full sun.",
  "Tulip": "Water moderately, partial sun.",
  "Sunflower": "Water moderately, full sun.",
  "Daisy": "Water daily, partial sun.",
  "Orchid": "Water weekly, indirect light."
}
CARE

# Update pubspec.yaml to include assets
cat > pubspec.yaml << 'PUBSPEC'
name: green_urban_grow
description: Auto plant scan MVP offline
version: 0.0.1
environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  tflite_flutter: ^0.10.0
  image: ^4.0.15
  image_picker: ^1.0.4
  permission_handler: ^11.0.1

flutter:
  uses-material-design: true
  assets:
    - assets/model.tflite
    - assets/labels.txt
    - assets/care_tips.json
PUBSPEC

# Run flutter pub get
flutter pub get
