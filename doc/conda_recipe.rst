Build a **Conda** recipe
========================

To build a **Conda** recipe, you need to use the following environment variables:

* :code:`CONDA_VERSION` equal to :code:`2` (default) or :code:`3`.
  Control the **Conda** version used for the build.
* :code:`CONDA_RECIPE`.
  The path to the **Conda** recipe to build.
  This path must be relative to the repository's root.
* :code:`ANACONDA_LOGIN` (optional).
  The usename used to connect to the **Anaconda Cloud** in order to upload the **Conda** recipe built.
* :code:`ANACONDA_PASSWORD` (optional).
  The usename's password used to connect to the **Anaconda Cloud** in order to upload the **Conda** recipe built.
* :code:`ANACONDA_OWNER` (optional).
  The channel used to upload the **Conda** recipe built.
  If not given, it is set to the :code:`ANACONDA_LOGIN` value.
* :code:`ANACONDA_DEPLOY` (optional).
  Deployment into the **Anaconda Cloud**.
  If set to :code:`true` (default if :code:`ANACONDA_LOGIN` is provided), the **Conda** recipe built will be deployed in the **Anaconda Cloud**.
  If set to :code:`false` (default if :code:`ANACONDA_LOGIN` is not provided), the **Conda** recipe built will not be deployed in the **Anaconda Cloud**.
* :code:`ANACONDA_LABEL` equal to :code:`main` by default.
  Label to associate to the **Conda** recipe deployed in the **Anaconda Cloud**. 
* :code:`ANACONDA_CHANNELS` (optional).
  Additional **Conda** channels to consider.
* :code:`TRAVIS_WAIT` (optional).
  See this `page <https://docs.travis-ci.com/user/common-build-problems/#Build-times-out-because-no-output-was-received>`_ for more information.

.. note::

   It is recommanded to define the environment variables :code:`ANACONDA_LOGIN`, :code:`ANACONDA_PASSWORD` and :code:`ANACONDA_OWNER` in the :code:`Settings` pannel of **Travis CI** instead of in the :code:`.travis.yml` (see this `page <https://docs.travis-ci.com/user/environment-variables#Defining-Variables-in-Repository-Settings>`_).
   This is due to :math:`2` major reasons:

   * These variables tends to be shared between various jobs (e.g., all jobs with a :code:`CONDA_RECIPE` environment variable).
   * These variables tends to be overriden in forks and **GitHub** pull requests should not modify these values. 