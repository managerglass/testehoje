indenter:
	find backend -name "*.html" | xargs djhtml -t 4 -i

autopep8:
	find backend -name "*.py" | xargs autopep8 --max-line-length 80 --in-place

isort:
	isort -m 3 *

lint: autopep8 isort indenter
