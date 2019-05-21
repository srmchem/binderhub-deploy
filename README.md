# binderhub-deploy

A set of scripts to automatically deploy a [BinderHub](https://binderhub.readthedocs.io/en/latest/index.html) onto [Microsoft Azure](https://azure.microsoft.com/en-gb/) and connect a [DockerHub](https://hub.docker.com/) container registry.

**List of scripts:**
* [**setup.sh**](#setupsh)
* [**logs.sh**](#logssh)
* [**info.sh**](#infosh)
* [**teardown.sh**](#teardownsh)

## Usage

Create a file called `config.json` which has the following format.
Fill the quotation marks with your desired namespaces, etc.
(Note that `#` tokens won't be permitted in the actual JSON file.)

* For a list of available locations, [see here](https://azure.microsoft.com/en-us/global-infrastructure/locations/).
* For a list of available Linux Virtual Machines, [see here](https://azure.microsoft.com/en-gb/pricing/details/virtual-machines/linux/).
* The `cluster_name` must be 63 characters or less and only contain lower case alphanumeric characters or a hyphen (-).

```
{
  "azure": {
    "subscription": "",  # Azure subscription name
    "res_grp_name": "",  # Azure Resource Group name
    "location": "",      # Azure Data Centre location
    "cluster_name": "",  # Kubernetes cluster name
    "node_count": "",    # Number of nodes to deploy
    "vm_size": ""        # Azure virtual machine type to deploy
  },
  "binderhub": {
    "name": "",          # Name of you BinderHub
    "version": ""        # Helm chart version to deploy
  },
  "docker": {
    "org": null,         # The DockerHub organisation id belongs to (if necessary)
    "image_prefix": ""   # The prefix to preprend to Binder images (e.g. "binder-dev")
  }
}
```

Make the shell scripts executable with the following command.
```
chmod 700 <script-name>.sh
```

---

### setup.sh

This script checks whether the required command line programs are already installed, and if any are missing uses the system package manager or [`curl`](https://curl.haxx.se/docs/) to install command line interfaces (CLIs) for Microsoft Azure (`azure-cli`), Kubernetes (`kubectl`), Helm (`helm`), and the ssh key generator (ssh-keygen), along with dependencies that are not automatically installed by those packages.

The script will ask you to enter a passphrase when the SSH keys are being generated - this can be left blank.

Command line install scripts were found in the following documentation:
* [Azure-CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?view=azure-cli-latest#install-or-update)
* [Kubernetes-CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-using-curl) (macOS version)
* [Helm-CLI](https://helm.sh/docs/using_helm/#from-script)

### logs.sh

This script will print the JupyterHub logs to the terminal for debugging.
It reads `config.json` via `read_config.py` in order to get the BinderHub name.
It then finds the pod the JupyterHub is deployed on and calls the logs.

### info.sh

The script will print the IP addresses of both the JupyterHub and the BinderHub to the terminal.
It reads the BinderHub name from `config.json` using `read_config.py`.

### teardown.sh

This script will purge the Helm release, delete the Kubernetes namespace and then delete the Azure Resource Group containing the computational resources.
The user should check the [Azure Portal](https://portal.azure.com/#home) to verify the resources have been deleted.