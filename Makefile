SRC_DIR = pootle
DOCS_DIR = docs
STATIC_DIR = ${SRC_DIR}/static
ASSETS_DIR = ${SRC_DIR}/assets
CSS_DIR = ${STATIC_DIR}/css
IMAGES_DIR = ${STATIC_DIR}/images
SPRITE_DIR = ${IMAGES_DIR}/sprite

all: help

build:
	mkdir -p ${ASSETS_DIR}
	python manage.py collectstatic --noinput --clear
	python manage.py assets build
	python setup.py build_mo
	# Make sure that the submodule with docs theme is pulled and up-to-date.
	git submodule update --init
	# The following creates the HTML docs.
	# NOTE: cd and make should to be in the same line.
	cd ${DOCS_DIR}; make html
	python setup.py sdist

sprite:
	glue --sprite-namespace="" --namespace="" ${SPRITE_DIR} --css=${CSS_DIR} --img=${IMAGES_DIR}

pot:
	@${SRC_DIR}/tools/createpootlepot

mo:
	python setup.py build_mo

mo-all:
	python setup.py build_mo --all

help:
	@echo "Help"
	@echo "----"
	@echo
	@echo "  build - create sdist with required prep"
	@echo "  sprite - create CSS sprite"
	@echo "  pot - update the POT translations templates"
	@echo "  mo - build MO files for languages listed in 'pootle/locale/LINGUAS'"
	@echo "  mo-all - build MO files for all languages (only use for testing)"
