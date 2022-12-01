# thesis-playground

Playground for master thesis containing code, documentation and examples to
explore policy as code.


## Terraform

In `terraform` directory there are several
[Terraform](https://www.terraform.io/) live modules with several
[AWS](https://aws.amazon.com/) infrastructure scenarios. All the code
is intended to be run by using [Moto](https://github.com/spulec/moto)
that mocks AWS services and should be enough to create Terraform plans,
applying them and destroying them.

Moto can be started in server-mode using
[Docker](https://www.docker.com/), e.g.:

```
$ docker run --detach --publish 4566:5000 --rm motoserver/moto:4.0.11
c48475b85c7708f218486e25bc8658281ec1ff2e0a01c0729764d71f3fdb2463
```

This starts the container and print the container ID
(`c48475b85c7708f218486e25bc8658281ec1ff2e0a01c0729764d71f3fdb2463`) to
the standard output.

Once Moto is running `terraform plan`, `terraform apply` and `terraform
destroy` can be performed on the various Terraform live modules.

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
