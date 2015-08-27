dist: articles theme 
	@echo $(theme)

articles:
	@echo hello

theme:
	@ifdef theme 
		ls $(theme)
	@endif
venv:
		test -d venv || virtualenv venv
			. venv/bin/activate
				pip install -i http://pypi.douban.com/simple -r app/requirements.txt
buildweb:
		cd web; npm install; bower install; grunt --force; cd ..
clean: 
		rm -rf dist; cd app; python setup.py clean
clean_pyc:
		find ./app -name '*.py[co]' -exec rm {} \;
clean_web:
		cd web; grunt clean; cd ..
devweb:
		cd web; grunt serve; cd ..
dev: buildweb
		cd web; grunt --force	
install: build 
		 python app/setup.py install

shell:
		ls

