.. include:: ../README.rst

**Travis CI** builds are decomposed into jobs.
These scripts allow to run different kind of jobs:

.. toctree::
    :maxdepth: 1

    conda_recipe.rst
    jupyter_notebook.rst
    docker_context.rst
    anaconda_release.rst

The jobs defined in your :code:`.travis.yml` and the order in which there are runned depend on your repository objective.
For example, in the **StatisKit** software suite :math:`3` kins of **GitHub** repositories are considered:

.. toctree::
    :maxdepth: 1

    github_release.rst
    github_source.rst
    github_tutorial.rst

.. warning::

   If a job failed on a given OS, all flowwing jobs on the same OS will fail.