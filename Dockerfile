FROM ubuntu

RUN apt-get update -qq && apt-get install -qq \
  python \
  python-pip \
  python-enchant

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

WORKDIR docs
VOLUME docs

CMD sphinx-versioning -l conf.py build docs _build/html/
