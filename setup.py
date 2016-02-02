from distutils.core import setup
from Cython.Build import cythonize
from distutils.extension import Extension
import numpy

extensions = [
    Extension("samplerbox_audio", ["samplerbox_audio.pyx"]),
    Extension("samplerbox_audio_neon", ["samplerbox_audio_neon.pyx"]),
]

setup(ext_modules = cythonize(extensions), include_dirs=[numpy.get_include()])
