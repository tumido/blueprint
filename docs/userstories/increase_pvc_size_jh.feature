Feature: As a data scientist I want more space in JupyterHub storage

    Background:
        Given I am a user of MOC-CNV
        * I have access to JupyteHub on MOC-CNV

    Scenario: I know about Ops
        Given I know how to create PRs
        * I know what PVC means

        When Increase PVC size in JupyteHub

        Then My JupyterHub storage is increased

    Scenario: I don't know about Ops stuff
        Given I don't know how to create PRs
        * I don't know what PVC means

        When I open an Issue

        Then My JupyterHub storage is increased

Feature: As a ops person I want to increase Jupyterhub storage for somebody

    Scenario: Increase the PVC for the user
        Given User requested a size increase
        * User is a user of MOC-CNV
        * User has access to JupyteHub on MOC-CNV

        When I increase PVC size in JupyterHub

        Then User is happy

Feature: Increase PVC size in JupyterHub

    Scenario: I use the default PVC

        This scenario is based on [PR243](https://github.com/operate-first/apps/pull/243) pull request.

        Given I have no custom PVC resource for JupyteHub

        When I update the templates/pvc-template.yaml with .metadata.annotations.hub\.jupyter\.org/username = USERNAME
        * I update the templates/pvc-template.yaml with .metadata.name = jupyterhub-nb-URLENCODED_USERNAME-pvc
        * I update the templates/pvc-template.yaml with .spec.resources.requests.storage = DESIRED_SIZE
        * I encrypt the resource with SOPS
        * I add the PVC resource to https://github.com/operate-first/apps/tree/master/odh/overlays/moc/jupyterhub/pvcs/user-USERNAME-pvc.enc.yaml
        * I list the resource at https://github.com/operate-first/apps/tree/master/odh/overlays/moc/jupyterhub/pvcs/secret-generator.yaml
        * I commit the updated file
        * I restart my JupyterHub server

        Then My PVC resource for JupyterHub is updated to DESIRED_SIZE

    Scenario: I already had a custom PVC defined
        Given I have custom PVC resource for JupyteHub

        When I fetch my PVC resource from https://github.com/operate-first/apps/tree/master/odh/overlays/moc/jupyterhub/pvcs/user-USERNAME-pvc.enc.yaml
        * I update the resource via SOPS with .spec.resources.requests.storage = DESIRED_SIZE
        * I commit the updated file
        * I restart my JupyterHub server

        Then My PVC resource for JupyterHub is updated to DESIRED_SIZE
