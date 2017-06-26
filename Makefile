
.PHONY: default clean cover test bench

default: test ;


clean:
	rm -rf datastructures/structures.c datastructures/*.so

cover:
	make clean
	python setup.py build_ext -i -D CYTHON_TRACE
	python setup.py test --coverage

test:
	make clean
	flake8
	python setup.py test

bench:
	make clean
	python setup.py bench
