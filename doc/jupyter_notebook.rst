* Run a **Jupyter** notebook, you should define these environment  variables:

  * :code:`JUPYTER_NOTEBOOK`.
    The path to the **Jupyter** notbook to run.
    This path must be relative to the repository root.
  * :code:`CONDA_ENVIRONMENT`.
    The path to the **Conda** environment to use when runnning the **Jupyter** notebook.
    

    .. warning::

        Channels given in the :code:`CONDA_ENVIRONMENT` will be overriden by channels added to the **Conda** configuration by the script :code:`config.sh`.