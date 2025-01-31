colima-start:
	colima start --arch x86_64 --memory 6

colima-stop:
	colima stop

install:
	rm -rf .venv
	python3 -m venv .venv && \
		.venv/bin/pip install --upgrade pip && \
		.venv/bin/pip install -r requirements.txt
