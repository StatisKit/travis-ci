.. Copyright [2017-2018] UMR MISTEA INRA, UMR LEPSE INRA,                ..
..                       UMR AGAP CIRAD, EPI Virtual Plants Inria        ..
..                                                                       ..
.. This file is part of the StatisKit project. More information can be   ..
.. found at                                                              ..
..                                                                       ..
..     http://StatisKit.rtfd.io                                            ..
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

This repository contains scripts designed to be used in :code:`.travis.yml` files of GitHub repositories.
For more information considering **Travis CI** refers to its `documentation <https://docs.travis-ci.com/>`_.

.. First, to use these tools, you need to create a **Travis CI** account.

.. note::

    It can be convenient to work in a :code:`travis.yml` file instead of :code:`.travis.yml` file.
    To do so, create the symoblic link :code:`.travis.yml` to the :code:`travis.yml` file.

    .. code-block::

       ln -s travis.yml .travis.yml


These scripts are designed to be used with the following :code:`.travis.yml` file:

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
      - git clone https://github.com/StatisKit/travis-ci.git travis-ci --depth=1
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