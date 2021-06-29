# Get image hash role

Uses `skopeo` to produce a dictionary of image digests for images defined in `images_to_get_hash_for`.

## Requirements

- skopeo
- jq

## Role Variables

- `images_to_get_hash_for` is required and should be structured as follows:

  ```yaml
  images_to_get_hash_for:
    release:
      image: quay.io/openshift-release-dev/ocp-release
      tag: "{{ release_tag | default('4.6.13-x86_64') }}"
  ```

  this will populate the `image_hashes` fact as follows:

  ```json
  { "release": "<image digest>" }
  ```

## Example Playbook

```yaml
- name: Play to populate image_hashes for relevant images
  hosts: localhost
  vars:
    images_to_get_hash_for:
      release:
        image: quay.io/openshift-release-dev/ocp-release
        tag: "{{ release_tag | default(openshift_full_version + '-x86_64') }}"
      controller:
        image: quay.io/ocpmetal/assisted-installer-controller
        tag: "{{ controller_tag | default('latest') }}"
      installer_agent:
        image: quay.io/ocpmetal/assisted-installer-agent
        tag: "{{ installer_agent_tag | default('latest') }}"
      installer:
        image: quay.io/ocpmetal/assisted-installer
        tag: "{{ installer_tag | default('latest') }}"
  roles:
    - get_image_hash
  post_tasks:
    - name: Set image hashes in registry_host
      set_fact:
        image_hashes: "{{ image_hashes }}"
      delegate_to: registry_host
      delegate_facts: true
```
