import os

from setuptools import setup, find_packages

from distutils.extension import Extension

import pkg_resources


lib_path = os.path.join(os.path.dirname(__file__), 'datastructures')
ext_file = os.path.join(lib_path, 'structures.c')
use_cython = not os.path.isfile(ext_file)
file_name = 'structures.pyx' if use_cython else 'structures.c'
numpy_incl = pkg_resources.resource_filename('numpy', 'core/include')


def read(name):
    filename = os.path.join(os.path.dirname(__file__), name)
    with open(filename) as fp:
        return fp.read()


meta = dict(
    name='datastructures',
    author="Luca Sbardella",
    author_email="luca@quantmind.com",
    maintainer_email="luca@quantmind.com",
    url="https://github.com/quantmind/datastructures",
    license="BSD",
    long_description=read('README.rst'),
    include_package_data=True,
    setup_requires=['numpy', 'pulsar', 'wheel'],
    packages=find_packages(include=['datastructures', 'datastructures.*']),
    ext_modules=[
        Extension(
            'datastructures.structures',
            [os.path.join(lib_path, file_name)],
            include_dirs=[numpy_incl, lib_path])
    ]
)


if __name__ == '__main__':
    setup(**meta)
