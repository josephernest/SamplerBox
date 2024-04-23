from setuptools import setup, Extension


def my_build_ext(pars):
    from setuptools.command.build_ext import build_ext as _build_ext

    class build_ext(_build_ext):
        def finalize_options(self):
            _build_ext.finalize_options(self)
            __builtins__.__NUMPY_SETUP__ = False
            import numpy
            self.include_dirs.append(numpy.get_include())

    return build_ext(pars)


setup(ext_modules=[Extension(name="samplerbox_audio",
                             sources=["samplerbox_audio.pyx"])],
      cmdclass={'build_ext': my_build_ext},
      setup_requires=[
          "cython",
          "numpy"
      ],
      install_requires=[
          'cffi',
          'numpy',
          'pyserial',
          'python-rtmidi; python_version >= "3.9"',
          'rtmidi-python; python_version < "3.9"',
          'smbus',
          'sounddevice',
      ],
      )
