#!/bin/bash

# Check arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input> <output>"
    exit 1
fi

# Temporary file
TMP="tmp.wav"

# Run phase_limiter with default settings
/etc/phaselimiter/bin/phase_limiter --input "$1" --output "$TMP" --ffmpeg ffmpeg \
 --mastering true --mastering_mode mastering5 \
 --sound_quality2_cache /etc/phaselimiter/resource/sound_quality2_cache \
 --mastering_matching_level 1.0000000 --mastering_ms_matching_level 1.0000000 \
 --mastering5_mastering_level 1.0000000 --erb_eval_func_weighting true \
 --reference -9.0000000

# Move output to destination
mv "$TMP" "$2"
rm -f "$TMP"
