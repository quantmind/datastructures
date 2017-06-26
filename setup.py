import os
import sys

from setuptools import setup, find_packages

from distutils.extension import Extension

import pkg_resources


numpy_incl = pkg_resources.resource_filename('numpy', 'core/include')
path = os.path.dirname(__file__)
lib_path = os.path.join(path, 'datastructures')
ext_file = os.path.join(lib_path, 'structures.c')
build_params = dict(
    include_dirs=[numpy_incl, lib_path]
)


if os.path.isfile(ext_file):
    ext_modules = [
        Extension('datastructures.structures', [ext_file], **build_params)
    ]

else:
    from Cython.Build import cythonize
    file_name = 'structures.pyx'
    ext_file = os.path.join(lib_path, 'structures.pyx')
    extra = {}
    if 'CYTHON_TRACE' in sys.argv:
        # coverage support for cython
        extra['compiler_directives'] = {'linetrace': True}

    ext_modules = cythonize(
        Extension('datastructures.structures', [ext_file], **build_params),
        **extra
    )


def read(name):
    filename = os.path.join(path, name)
    with open(filename) as fp:
        return fp.read()


def read_version():
    for line in read(os.path.join(lib_path, '__init__.py')).split('\n'):
        if line.startswith('__version__ = '):
            return line[15:-1]


meta = dict(
    name='datastructures',
    version=read_version(),
    author="Luca Sbardella",
    author_email="luca@quantmind.com",
    maintainer_email="luca@quantmind.com",
    url="https://github.com/quantmind/datastructures",
    license="BSD",
    long_description=read(os.path.join(path, 'README.rst')),
    include_package_data=True,
    setup_requires=['numpy', 'pulsar', 'wheel'],
    packages=find_packages(include=['datastructures', 'datastructures.*']),
    ext_modules=ext_modules,
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Environment :: Plugins',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Topic :: Utilities'
    ]
)


if __name__ == '__main__':
    setup(**meta)
