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

# Create a .gitconfig file so that a single file can be mounted
RUN touch /root/.gitconfig

# Declare a volume to mount ssh configuration
VOLUME /root/.ssh

WORKDIR workspace
VOLUME workspace

# todo: copy the Makefile into the image, then use that to run Sphinx? `make spelling` works to run spell checking.
# todo: add publishing sphinx-versioning push -P origin-ssh docs gh-pages .
CMD sphinx-versioning build docs docs/_build/html/
