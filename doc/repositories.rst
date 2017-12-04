Repositories Guide
------------------

To activate **Travis CI** for a **GitHub** repository, refers to this `page <https://help.github.com/enterprise/2.11/admin/guides/developer-workflow/continuous-integration-using-travis-ci/>`_.

Within the **StatisKit** organization, there exits 2 types of deployment for repositories:

* Repositories for realease deployment (e.g., `StatisKit <http://github.com/StatisKit/StatisKit>`_).
  The goal of these repositories is to build all source code that is designed to be installed in the same **Conda** environment and to test them together.
  To do so,
  
  * all **Conda** packages are built and deployed to the :code:`release` label (given the environment variable :code:`ANACONDA_LABEL`) without considering the :code:`unstable` label.
  * Once all packages are deployed to the :code:`release` label and have been tested, in a last job, packages are moved from the :code:`release` channel to the :code:`main` channel (given by the environment variable :code:`ANACONDA_RELABEL`).
  
  .. warning:: 
  
     These type of repositories must contain :code:`fast_finish: true` in the :code:`matrix` field.
     Otherwise, the last job moving the packages on the :code:`release` channel to the :code:`main` would be executed even if one job failed.
     
* Repositories for continuous deployment (e.g., `ClangLite <http://github.com/StatisKit/ClangLite>`_).