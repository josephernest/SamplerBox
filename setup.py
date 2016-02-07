from distutils.core import setup
from Cython.Build import cythonize
from distutils.extension import Extension
import numpy

extensions = [
    Extension("samplerbox_audio", ["samplerbox_audio.pyx"]),
    Extension("samplerbox_audio_neon", ["samplerbox_audio_neon.pyx"],
        extra_compile_args=["-mcpu=cortex-a7", "-mtune=arm1176jzf-s", "-mfloat-abi=hard", "-mfpu=neon-vfpv4", "-ftree-vectorize", "-ffast-math", "-O3"]),
]

setup(ext_modules = cythonize(extensions), include_dirs=[numpy.get_include()])
