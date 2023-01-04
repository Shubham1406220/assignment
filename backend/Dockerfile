FROM python:3.8-slim-buster

WORKDIR .
COPY app.py app.py
COPY wsgi.py wsgi.py
COPY requirements.txt requirements.txt

EXPOSE 5000

RUN pip install -r requirements.txt

CMD ["gunicorn", "wsgi:app", "-w", "2", "--threads", "2", "-b", "0.0.0.0:5000"]