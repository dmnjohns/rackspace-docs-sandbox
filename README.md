# Instructions

The tools in this directory use Python 3 and the `pipenv` dependency
manager. For more information, see
[packaging.python.org/tutorials/managing-dependencies](https://packaging.python.org/tutorials/managing-dependencies/
"https://packaging.python.org/tutorials/managing-dependencies/").

To install `pipenv`, run `pip install --user pipenv`.
To add `pipenv` to your `PATH`, run `export PATH="$(echo $(python -m site --user-base)/bin):$PATH"`.

To install the dependencies, type `pipenv sync`. Then, enter the
virtual environment by typing `pipenv shell`.

To customize the starter kit for your project, follow these steps:

1. Replace all instances of `<officialProjectName>` with your
   project's official name (for example, `Rackspace Cloud
   Networks`).
1. Replace `<year>` with the current year.
1. Replace `<release>` with the current version number.
1. Replace `<product-name>` with the product name in lower case (for
   example `cloud-networks`).
1. Replace all instances of `<repoName>` to match the name of the
   repository where you are working (for example,
   `docs-cloud-networks`).
1. Replace all instances of `<base-url>` with the URL for your site
   (for example `how-to`).
1. Replace all instances of `<category,basename,title>` with the
   categories, base names, and titles for your content. These
   categories should reflect the directory structure of your content.
   For an example, see the
   [products.csv](https://github.com/rackerlabs/rackspace-how-to/blob/master/products.csv)
   file in the Rackspace How To repository.
