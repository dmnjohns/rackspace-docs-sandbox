All of the files in this directory except for the `Makefile`
are meant to coordinate the Jenkins job
which will build the docs and push them onto the `gh-pages` branch.

We should not need any of that.
Instead, we will use sphinx-versioning directly.

Note:
"It is required to push doc files to origin.
SCVersioning only works with remote branches/tags and ignores any local changes
(committed, staged, unstaged, etc).
If you don’t push to origin SCVersioning won’t see them.
This eliminates race conditions when multiple CI jobs are building docs at the
same time."

Do we want to use Docker to set up the environment that will run Sphynx?
https://hub.docker.com/r/plaindocs/docker-sphinx/

Issue with Sphinx 1.7.2 and versioned docs:
https://github.com/Robpol86/sphinxcontrib-versioning/issues/39
Sphinx 1.5.6 can be used for the time being.

While it may be possible for Sphinx to support Asciidoc or Asciidoctor sources,
I was unable to find support for such at this time.
However, Markdown is supported:
http://www.sphinx-doc.org/en/master/usage/markdown.html
While the mechanisms to support Asciidoctor sources exist within Sphinx, it
would be non-trivial to implement, and I would be concerned that the support
would not be fully-featured or not be maintained.

While I was able to find tools to convert ReStructuredText into Asciidoc, I
was not able to find tools that would convert Asciidoc to ReStructuredText.
There are certainly no tools to convert Asciidoctor content directory to
RestructuredText.
The Pandoc product could be used for this task if it supported Asciidoc input:
https://pandoc.org/
It may be possible to Asciidoctor to output Docbook files, then use Pandoc to
convert those Docbook files into RST files which would finally be converted
into HTML files by Sphinx. Of course, such a chain would likely be complicated
and error prone.

If we ran Sphinx (sphinx-versioning) in a Docker container (see the Dockerfile
in this directory), we could use Gradle to launch the container (and capture
output, including stdout and exit code).
We could also keep our docs in the same place they currently reside, and could
even keep RST side-by-side with Asciidoctor files until we have fully migrated.
To publish, we would have the Docker container run `sphinx-versioning push`
to push generated html output to the gh-pages branch.
Alternatively, we could continue to use our publishing task, and even simplify
it a bit.
Taking that approach would keep the work done by Docker pretty simple, append
allow us to separate building and publishing (which would allow us to place
  each where it is most appropriate in our Gradle flow).
Note that SSH keys should be available to be able to push to origin.
These, too, can be mounted to Docker.

The Sphinx Gradle plugin does not appear to support sphinx-versioning, and thus,
is not suited for our use-case:
https://trustin.github.io/sphinx-gradle-plugin/basic-usage.html

There exists some diagram support in Sphinx via extensions.
Graphviz seems the most supported:
http://www.sphinx-doc.org/en/master/ext/graphviz.html
However, ditaa also seems to be supported through a third-party extension:
https://github.com/baloo/sphinx-ditaa

Sphinx supports "includes" for things like putting a header on each page:
http://docutils.sourceforge.net/docs/ref/rst/directives.html#include

Sphinx supports code formatting and highlighting using Pygments under the hood:
http://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#directive-highlight
http://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#directive-code-block
http://pygments.org/

Sphinx supports tables:
http://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html#tables
http://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#tables

Sphinx DOES NOT appear to support callouts at this time, but future support
may be added:
https://github.com/sphinx-doc/sphinx/issues/1098
It should be noted that something like callouts can be used in Sphinx:
https://stackoverflow.com/a/1055104

Sphinx supports the equivalent of Asciidoctor admonitions as paragraph level markup:
http://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#paragraph-level-markup

Sphinx provides functional support for page searching.

Sphinx will rebuild docs from all docs branches on each run.

If we tie the Docker management into Gradle, we can continue using our current
link checker.

Spell checking is handled by the `sphinxcontrib.spelling` Sphinx extension.
This is already configured in the Sphinx configuration provided by Rackspace.
