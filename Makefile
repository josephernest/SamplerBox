samplerbox_audio.so: samplerbox_audio.pyx samplerbox_audio_neon.pyx
	python setup.py build_ext --inplace
