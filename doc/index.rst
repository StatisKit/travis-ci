.. include:: ../README.rst

User guide
----------

At the organization level
+++++++++++++++++++++++++

For organizations, it is recommanded to fork this repository and to adapt the :code:`config.sh:` file in which you should give:

* **Conda** channels used for builds and installs,
* **Anaconda** label used for uploads.

For example, let us consider the :code:`config.sh` written for the **StatisKit** organization:

1. The :code:`TEST_LEVEL` environment variables is used in **Conda** recipes to control the test launched (e.g., code:`1` is for unit tests).

   .. literalinclude:: ../config.sh
      :lines: 23

2. The :code:`r` **Conda** channels is added for all repositories.

   .. literalinclude:: ../config.sh
      :lines: 24

3. Uploads made on the :code:`release` label of the **Anaconda** :code:`statiskit` channel are only allowed for :code:`master` branches.
   Otherwise, the label is changed to :code:`unstable`. 

   .. literalinclude:: ../config.sh
      :lines: 25-27

4. :code:`unstable` and :code:`release` are the only accepted labels for uploads made on the **Anaconda** :code:`statiskit` channel. 

   .. literalinclude:: ../config.sh
      :lines: 28-30

5. For uploads on:

   *  Another **Anaconda** channel than :code:`statiskit`, the channels used by **Conda** are :code:`statiskit` (with the :code:`main` label and :code:`unstable` labels) and the one given by the code:`ANACONDA_UPLOAD` environment variable (with the :code:`main` and the label given by the :code:`ANACONDA_LABEL` environment variable if given).

      .. literalinclude:: ../config.sh
         :lines: 33-40,47

   *  The :code:`statiskit` **Anaconda** channel, the channel used by **Conda** is :code:`statiskit` (with the :code:`main` label and the label given by the :code:`ANACONDA_LABEL` environment variable if given).

      .. literalinclude:: ../config.sh
         :lines: 33,40-47

      .. note::

         In order to prevent **Anaconda** channel collision for the :code:`release` label on the :code:`statiskit` channel (e.g. with **AppVeyor CI**), the :code:`release` label is changed to :code:`travis-release`. 

At the repository level
+++++++++++++++++++++++

To activate **Travis CI** for a **GitHub** repository, refers to this `page <https://help.github.com/enterprise/2.11/admin/guides/developer-workflow/continuous-integration-using-travis-ci/>`_

Within the **StatisKit** organization, there exits 2 types of **Conda** deployment behavior for repositories:

* A repository for realease deployment (i.e., `StatisKit <http://github.com/StatisKit/StatisKit>`_).
  The goal of this repository is to build all source code that is designed to be installed in the same **Conda** environment and to test them together.
  To do so,
  
  * all **Conda** packages are build and deployed to the :code:`release` label (given the environment variable :code:`ANACONDA_LABEL`) without considering the :code:`unstable` label.
  * Once all packages are deployed to the :code:`release` label and have been tested, in a last job, packages are moved from the :code:`release` channel to the :code:`main` channel (given by the environment variable :code:`ANACONDA_RELABEL`).
  
  .. warning:: 
  
     These type of repositories must contain :code:`fast_finish: true` in the :code:`matrix` field.
     Otherwise, the last job moving the packages on the :code:`release` channel to the :code:`main` would be executed even if one job failed.
     
* Repositories for continuous deployment (e.g., `ClangLite <http://github.com/StatisKit/ClangLite>`_).