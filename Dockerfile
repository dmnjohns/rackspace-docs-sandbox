FROM ubuntu

RUN apt-get update -qq && apt-get install -qq \
  git \
  python \
  python-pip \
  python-enchant

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

WORKDIR workspace
VOLUME workspace
VOLUME /root/.ssh

CMD sphinx-versioning -l docs/conf.py build docs docs/_build/html/
