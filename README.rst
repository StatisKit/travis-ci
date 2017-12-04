.. Copyright [2017-2018] UMR MISTEA INRA, UMR LEPSE INRA,                ..
..                       UMR AGAP CIRAD, EPI Virtual Plants Inria        ..
..                                                                       ..
.. This file is part of the StatisKit project. More information can be   ..
.. found at                                                              ..
..                                                                       ..
..     http://autowig.rtfd.io                                            ..
..                                                                       ..
.. The Apache Software Foundation (ASF) licenses this file to you under  ..
.. the Apache License, Version 2.0 (the "License"); you may not use this ..
.. file except in compliance with the License. You should have received  ..
.. a copy of the Apache License, Version 2.0 along with this file; see   ..
.. the file LICENSE. If not, you may obtain a copy of the License at     ..
..                                                                       ..
..     http://www.apache.org/licenses/LICENSE-2.0                        ..
..                                                                       ..
.. Unless required by applicable law or agreed to in writing, software   ..
.. distributed under the License is distributed on an "AS IS" BASIS,     ..
.. WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or       ..
.. mplied. See the License for the specific language governing           ..
.. permissions and limitations under the License.                        ..

travis-ci: Tools for Using **Conda** in **Travis CI**
=====================================================

First, to use these tools, you need to create a **Travis CI** account.
For more information considering **Travis CI** refers to its `documentation <https://docs.travis-ci.com/>`_.

.. note::

    It can be convenient to work in a :code:`travis.yml` file instead of :code:`.travis.yml` file.
    To do so, create the symoblic link :code:`.travis.yml` to the :code:`travis.yml` file.

    .. code-block::

       ln -s travis.yml .travis.yml
    

Documentation
-------------

This collection of scripts for **Travis CI** can be used with the following :code:`.travis.yml` file:

.. code-block:: yaml

    os:
      - linux
      - osx

    sudo: required

    services:
      - docker

    env:
      # Add here environement variables to control the Travis CI build

    install:
      - git clone https://github.com/StatisKit/travis-ci.git travis-ci
      - cd travis-ci
      - source install.sh

    before_script:
      - source before_script.sh

    script:
      - source script.sh

    after_success:
      - source after_success.sh

    after_failure:
      - source after_failure.sh

    before_deploy:
      - source before_deploy.sh

    deploy:
      skip_cleanup: true
      provider: script
      on:
          all_branches: true
      script: bash deploy_script.sh

    after_deploy:
      - source after_deploy.sh

    after_script:
      - source after_script.sh

.. note::

   The :code:`config.sh` script is executed from within the :code:`install.sh` script.

In the :code:`env` section, you can use the following environement variables to control the **Travis CI** build:
  
* :code:`CONDA_VERSION` equal to :code:`2` (default) or :code:`3`.
  Control the **Conda** version used for the build.
* :code:`TRAVIS_WAIT` (optional).
  See this `page <https://docs.travis-ci.com/user/common-build-problems/#Build-times-out-because-no-output-was-received>`_ for more information.
  
  .. note::
  
    The :code:`TRAVIS_WAIT` environment must be setted to the time to wait (in minutes).
    
* :code:`ANACONDA_CHANNELS` (optional).
  Additional **Conda** channels to consider.

And, if you want to:

* Build a **Conda** recipe, you should define these environment variables:

  * :code:`CONDA_RECIPE`.
    The path to the **Conda** recipe to build.
    This path must be relative to the repository root.
  * :code:`ANACONDA_USERNAME` (optional).
    The usename used to connect to the **Anaconda Cloud** in order to upload the **Conda** recipe built.
  * :code:`ANACONDA_PASSWORD` (optional).
    The usename's password used to connect to the **Anaconda Cloud** in order to upload the **Conda** recipe built.
  * :code:`ANACONDA_UPLOAD` (optional).
    The channel used to upload the **Conda** recipe built.
    If not given, it is set to the :code:`ANACONDA_USERNAME` value.
  * :code:`ANACONDA_DEPLOY` (optional).
    Deployment into the **Anaconda Cloud**.
    If set to :code:`true` (default if :code:`ANACONDA_USERNAME` is provided), the **Conda** recipe built will be deployed in the **Anaconda Cloud**.
    If set to :code:`false` (default if :code:`ANACONDA_USERNAME` is not provided), the **Conda** recipe built will not be deployed in the **Anaconda Cloud**.
  * :code:`ANACONDA_LABEL` equal to :code:`main` by default.
    Label to associate to the **Conda** recipe deployed in the **Anaconda Cloud**.

  .. note::

     It is recommanded to define the environment variables :code:`ANACONDA_USERNAME`, :code:`ANACONDA_PASSWORD` and :code:`ANACONDA_UPLOAD` in the :code:`Settings` pannel of **Travis CI** instead of in the :code:`.travis.yml`.

* Build a **Docker** image, you should define these environment  variables:

  * :code:`DOCKER_CONTEXT`.
    The path to the directory containing the :code:`Dockerfile` file containing the **Docker** instructions to execute.
    This path must be relative to the repository root.
  * :code:`DOCKER_USERNAME` (optional).
    The usename used to connect to the **Docker Hub** in order to upload the **Docker** image built.
  * :code:`DOCKER_PASSWORD` (optional).
    The usename's password used to connect to the **Docker Hub** in order to upload the **Docker** image built.
  * :code:`DOCKER_UPLOAD` (optional).
    The channel used to upload the **Docker** image built.
    If not given, it is set to the :code:`DOCKER_USERNAME` value.
  * :code:`DOCKER_DEPLOY` (optional).
    Deployment into the **Docker Hub**.
    If set to :code:`true` (default if :code:`DOCKER_USERNAME` is provided), the **Docker** image built will be deployed in the **Docker Hub**.
    If set to :code:`false` (default if :code:`DOCKER_USERNAME` is not provided), the **Docker** image built will not be deployed in the **Docker Hub**.
    
  .. warning::

     A **Docker** image can only be built on the Linux OS of **Travis CI**.

  .. note::

     It is recommanded to define the environment variables :code:`DOCKER_USERNAME`), :code:`DOCKER_PASSWORD` and :code:`DOCKER_UPLOAD` in the :code:`Settings` pannel of **Travis CI** instead of in the :code:`.travis.yml`.

* Run a **Jupyter** notebook, you should define these environment  variables:

  * :code:`JUPYTER_NOTEBOOK`.
    The path to the **Jupyter** notbook to run.
    This path must be relative to the repository root.
  * :code:`CONDA_ENVIRONMENT`.
    The path to the **Conda** environment to use when runnning the **Jupyter** notebook.
    

    .. warning::

        Channels given in the :code:`CONDA_ENVIRONMENT` will be overriden by channels added to the **Conda** configuration by the script :code:`config.sh`.

Usage
-----

At the organization level
+++++++++++++++++++++++++

For organizations it is recommanded to fork this repository and to adapte the :code:`config.sh:` file in which you should give:

* **Conda** channels used for builds and installs,
* **Anaconda** label used for uploads.

For example, let us consider the :code:`config.sh` written for the **StatisKit** organization:

1. The :code:`TEST_LEVEL` environment variables is used in **Conda** recipes to control the test launched (e.g., code:`1` is for unit tests).

   .. literalinclude:: config.sh
      :lines: 23

2. The :code:`r` **Conda** channels is added for all repositories.

   .. literalinclude:: config.sh
      :lines: 24

3. Uploads made on the :code:`release` label of the **Anaconda** :code:`statiskit` channel are only allowed for :code:`master` branches.
   Otherwise, the label is changed to :code:`unstable`. 

   .. literalinclude:: config.sh
      :lines: 25-27

4. :code:`unstable` and :code:`release` are the only accepted labels for uploads made on the **Anaconda** :code:`statiskit` channel. 

   .. literalinclude:: config.sh
      :lines: 28-30

5. For uploads on:

   *  another **Anaconda** channel than :code:`statiskit`, the channels used by **Conda** are :code:`statiskit` (with the :code:`main` label and :code:`unstable` labels) and the one given by the code:`ANACONDA_UPLOAD` environment variable (with the :code:`main` and the label given by the :code:`ANACONDA_LABEL` environment variable if given).

      .. literalinclude:: config.sh
         :lines: 33-40,47

   *  The :code:`statiskit` **Anaconda** channel, the channel used by **Conda** is :code:`statiskit` (with the :code:`main` label and the label given by the :code:`ANACONDA_LABEL` environment variable if given).

      .. literalinclude:: config.sh
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
  
  * all **Conda** packages are build and deployed to the :code:`release` label (given the environment variable :code:`ANACONDA_LABEL`) without considering the :code:`main` and :code:`unstable` labels.
  * Once all packages are deployed to the :code:`release` label and have been tested, in a last job, packages are moved from the :code:`release` channel to the :code:`main` channel (given by the environment variable :code:`ANACONDA_RELABEL`).
  
  .. warning:: 
  
     These type of repositories must contain :code:`fast_finish: true` in the :code:`matrix` field.
     Otherwise, the last job moving the packages on the :code:`release` channel to the :code:`main` would be executed even if one job failed.
     
* Repositories for continuous deployment (e.g., `ClangLite <http://github.com/StatisKit/ClangLite>`_).