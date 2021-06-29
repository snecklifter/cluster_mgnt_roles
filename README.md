# OpenShift 4 Management Cluster Seed Playbook

> :heavy_exclamation_mark: *Red Hat does not provide commercial support for the content of this repo*
---
```bash
##############################################################################
THIS REPO IS MODIFIED FROM THE REDHATPARTNERSOLUTIONS/cluster_mgnt_roles repo. THIS IS 
OPTIMIZED FOR A SINGLE NODE INSTALLATION.
DISCLAIMER: THE CONTENT OF THIS REPO IS EXPERIMENTAL AND PROVIDED "AS-IS"

THE CONTENT IS PROVIDED AS REFERENCE WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
##############################################################################
```
---

This playbook is responsible for automating the creation of an OpenShift Container Platform cluster on premise using the Developer Preview version of the OpenShift Assisted Installer. Virtual and Bare Metal deployments have been tested in restricted network environments.


The prefered utilization of this playbook:
  - Playbook is launched from a bastion host inside the target environment.
  - Pre-requisite services can be pre-exisitng or installed by the playbook.


## OpenShift Versions Tested
---
  - 4.6


## Before Running The Playbook
---
You can check the file prerequisites have been fulfilled by running `ansible-playbook -i localhost, prereq_facts_check.yml`.
- Modify the provided inventory file `inventory.sample`. Fill in the appropriate values that suit your environment and deployment requirements.
- Place these files in the playbook base directory:
  - OpenShift pull secret stored as `pull_secret.txt`
  - SSH Public Key stored as `ssh_public_key.txt`
  - SSL self-signed certificate stored as `mirror_certificate.txt`


## Running The Playbook
---
The following command launches the playbook:

```bash
ansible-playbook -i inventory deploy_cluster.yml
```

### References
---
This software was adapted from [sonofspike/cluster_mgnt_roles](https://github.com/sonofspike/cluster_mgnt_roles)
