# To build docs using this image, use the following command:
# docker run -ti -v <DOCS_GIT_ROOT_DIR>:/workspace rackerlabs/repose-docs
#
# To publish docs using this image, use the following command:
# docker run -ti -v <DOCS_GIT_ROOT_DIR>:/workspace -v <SSH_CONFIG_DIR>:/root/.ssh -v <GITCONFIG_FILE>:/root/.gitconfig <IMAGE_REF>
#
# Note that publishing docs requires a Git configuration and, in some cases,
# SSH configuration (to grant permission to push).
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
