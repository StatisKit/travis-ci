Organization Guide
------------------

For organizations, it is recommanded to fork this repository and to adapt the :code:`config.sh` file in which you should give:

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
   Otherwise, the label is changed to :code:`develop`. 

   .. literalinclude:: ../config.sh
      :lines: 25-27

4. :code:`develop` and :code:`release` are the only accepted labels for uploads made on the **Anaconda** :code:`statiskit` channel. 

   .. literalinclude:: ../config.sh
      :lines: 28-30

5. For uploads on:

   *  Another **Anaconda** channel than :code:`statiskit`, the channels used by **Conda** are :code:`statiskit` (with the :code:`main` label and :code:`develop` labels) and the one given by the code:`ANACONDA_OWNER` environment variable (with the :code:`main` and the label given by the :code:`ANACONDA_LABEL` environment variable if given).

      .. literalinclude:: ../config.sh
         :lines: 33-40,47

   *  The :code:`statiskit` **Anaconda** channel, the channel used by **Conda** is :code:`statiskit` (with the :code:`main` label and the label given by the :code:`ANACONDA_LABEL` environment variable if given).

      .. literalinclude:: ../config.sh
         :lines: 33,40-47

      .. note::

         In order to prevent **Anaconda** channel collision for the :code:`release` label on the :code:`statiskit` channel (e.g. with **AppVeyor CI**), the :code:`release` label is changed to :code:`travis-release`. 