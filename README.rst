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

travis-ci: Tools for Using Conda in Travis CI
=============================================

.. note::

    It can be conveniant to work in a :code:`travis.yml` file instead of :code:`.travis.yml` file.
    To do so, create the symoblic link :code:`.travis.yml` to the :code:`travis.yml` file.
    
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
          branch: master
      script: bash deploy_script.sh

    after_deploy:
      - source after_deploy.sh

    after_script:
      - source after_script.sh

In the :code:`env` section, you can use the following environement variables to control the **Travis CI** build:
  
* :code:`CONDA_VERSION` equal to :code:`2` (default) or :code:`3`.
  Control the **Conda** version used for the build.
* :code:`TRAVIS_WAIT` (optional). See this `page <https://docs.travis-ci.com/user/common-build-problems/#Build-times-out-because-no-output-was-received>`_ for more information.
  
  .. note::
  
    The :code:`TRAVIS_WAIT` environment must be setted to the time to wait (in minutes).
    
If you want to:

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

* Build a **Docker** image, you should define these environment  variables:

  * :code:`DOCKERFILE`.
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

* Run a **Jupyter** notebook, you should define these environment  variables:

  * :code:`JUPYTER_NOTEBOOK`.
    The path to the **Jupyter** notbook to run.
    This path must be relative to the repository root.
  * :code:`CONDA_ENVIRONMENT`.
    The path to the **Conda** environment to use when runnning the **Jupyter** notebook.
    
.. note::

   It is recommanded to define the environment variables :code:`ANACONDA_USERNAME` (resp. :code:`DOCKER_USERNAME`), :code:`ANACONDA_PASSWORD` (resp. :code:`DOCKER_PASSWORD`) and :code:`ANACONDA_UPLOAD` (resp. :code:`DOCKER_UPLOAD`) in the :code:`Settings` pannel of **Travis CI** instead of in the :code:`.travis.yml`.
 
Usage
-----

Within the **StatisKit** organization, there exits 2 types of **Conda** deployment behavior for repositories:

* A repository for realeases (i.e. `StatisKit <http://github.com/StatisKit/StatisKit>`_).
  The goal of this repository is to build all source code that is designed to be installed in the same **Conda** environment and to test them together.
  To do so,
  
  * all **Conda** packages are build and deployed to the :code:`release` label (given the environment variable :code:`ANACONDA_LABEL`) without considering the :code:`main` and :code:`unstable` labels.
  * Once all packages are deployed to the :code:`release` label and have been tested, in a last job, packages are moved from the :code:`release` channel to the :code:`main` channel (given by the environment variable :code:`ANACONDA_RELABEL`).
  
  .. warning:: 
  
     These type of repositories must contain :code:`fast_finish: true` in the :code:`matrix` field.
     Otherwise, the last job moving the packages on the :code:`release` channel to the :code:`main` would be executed even if one job failed.
     
* Repositories for continuous deployment (e.g., `ClangLite <http://github.com/StatisKit/ClangLite`_).
