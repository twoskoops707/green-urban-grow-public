#!/bin/bash

# Create assets directory
mkdir -p assets

# Add the TFLite model (replace with real model bytes if needed)
echo "TFLITE_MODEL_BYTES_PLACEHOLDER" > assets/model.tflite

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

