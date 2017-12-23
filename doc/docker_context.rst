Build a **Docker** context
==========================

To build a **Docker** context, you need to use the following environment variables:

* :code:`DOCKER_CONTEXT`.
  The path to the **Docker** context to build.
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
* :code:`TRAVIS_WAIT` (optional).
  See this `page <https://docs.travis-ci.com/user/common-build-problems/#Build-times-out-because-no-output-was-received>`_ for more information.
    
.. warning::

   A **Docker** context can only be built on the Linux OS of **Travis CI**.

.. note::

   It is recommanded to define the environment variables :code:`DOCKER_USERNAME`), :code:`DOCKER_PASSWORD` and :code:`DOCKER_UPLOAD` in the :code:`Settings` pannel of **Travis CI** instead of in the :code:`.travis.yml` (see this `page <https://docs.travis-ci.com/user/environment-variables#Defining-Variables-in-Repository-Settings>`_).
   This is due to :math:`2` major reasons:

   * These variables tends to be shared between various jobs (e.g., all jobs with a :code:`DOCKER_CONTEXT` environment variable).
   * These variables tends to be overriden in forks and **GitHub** pull requests should not modify these values. 