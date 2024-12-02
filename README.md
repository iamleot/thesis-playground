# thesis-playground

Playground for master thesis containing code, documentation and examples to
explore policy as code.

## Rego

In `rego` directory there are OPA policies for Terraform state.

A `Makefile` is provided to ease CI (continuous integration) checking,
linting and testing Rego code. It also ensures code coverage of 80%.

Rego code is continously tested via
`.github/workflows/rego.yaml` GitHub Actions workflow.

To use the OPA CLI interactively against a Terraform state
`<tfstate.json>` the following can be handy:

```
$ opa run . repl.input:<tfstate.json> 
OPA 0.70.0 (commit , built at )

Run 'help' to see a list of commands and check for updates.

> import data.lib.tfstate
> tfstate.resources 
[...]
```

## Terraform

In `terraform` directory there are several
[Terraform](https://www.terraform.io/) live modules with several
[AWS](https://aws.amazon.com/) infrastructure scenarios. All the code
is intended to be run by using [Moto](https://github.com/getmoto/moto)
that mocks AWS services and should be enough to create Terraform plans,
applying them and destroying them.

Moto can be started in server-mode using
[Docker](https://www.docker.com/), e.g.:

```
$ docker run --detach --publish 4566:5000 --volume "${PWD}/config/amis.json:/amis.json" --env MOTO_AMIS_PATH=/amis.json --env MOTO_IAM_LOAD_MANAGED_POLICIES=true --rm motoserver/moto:5.0.21
c48475b85c7708f218486e25bc8658281ec1ff2e0a01c0729764d71f3fdb2463
```

This starts the container and print the container ID
(`c48475b85c7708f218486e25bc8658281ec1ff2e0a01c0729764d71f3fdb2463`) to
the standard output.

Once Moto is running `terraform plan`, `terraform apply` and
`terraform destroy` can be performed on the various Terraform live
modules.

A `Makefile` is provided to ease CI (continuous integration) checking
and linting Terraform code and recursively create and destroy
infrastructure of each Terraform live module.

Terraform code is continously tested via
`.github/workflows/terraform.yaml` GitHub Actions workflow.

Moto container can be stopped via `docker stop`, e.g. (assuming the
container ID is
`c48475b85c7708f218486e25bc8658281ec1ff2e0a01c0729764d71f3fdb2463`):

```
$ docker stop c48475b85c7708f218486e25bc8658281ec1ff2e0a01c0729764d71f3fdb2463
```

**WARNING**: all code/documentation/examples/etc. here will be probably
in an eternal POC/WIP state. Reader beware!
