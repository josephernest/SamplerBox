samplerbox_audio.so: export CFLAGS=-mcpu=cortex-a7 -mtune=arm1176jzf-s -mfloat-abi=hard -mfpu=neon-vfpv4 -ftree-vectorize -ffast-math -O3
samplerbox_audio.so: samplerbox_audio.pyx samplerbox_audio_neon.pyx
	python setup.py build_ext --inplace
