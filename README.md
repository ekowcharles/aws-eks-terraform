# aws-eks-terraform

The contents of this repo are based on the steps outlined in [Terraform's AWS EKS introduction](https://learn.hashicorp.com/terraform/aws/eks-intro#configuring-kubectl-for-eks).

## Up and running

Basic knowledge of AWS, Kubernetes and Terraform is required to use this script to create an Kubernetes cluster in AWS. To setup EKS with these scripts you need to have the following already setup:
- [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [terraform](https://www.terraform.io/downloads.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [aws-sudo](https://github.com/makethunder/awsudo)
- [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)

`aws-sudo` enables you to authenticate against AWS with a specific profile. This is particularly useful if you manage credentials for different AWS accounts on the same computer. Follow instructions on the [aws-sudo](https://github.com/makethunder/awsudo) page to setup a profile and call it the `eks-demo` profile.

There are [detailed steps](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) in AWS docs that walk you through how to properly setup credentials for `aws-cli`.

## Commands

| Command | Description |
| ------- | ----------- |
| `make init` | Initialize terraform. Must be run once. |
| `make plan` | Plan changes to AWS infrastructure. |
| `make apply` | Apply changes to AWS infrastructure. You will be prompted to proceed before actual changes are applied. This could take up to 10 minutes if you are doing this for the first time. |
| `make output` | Retrieve output of the most recently applied changes. |
| `make destroy` | Delete all infrastructure. |

*Note* Until you run `make destroy`, you may continue to attract charges on your AWS account. Be sure to destroy infrastructure while you have no need for it.

## Setting up the cluster

- Run `make init`.
- Run `make apply`.
- Run `make config`. This creates config_map_aws_auth.yml in this folder.
- Run `kubectl apply -f config_map_aws_auth.yml`.
- Verify the worker nodes are joining the cluster by running `kubectl get nodes --watch`.

# License

MIT License

Copyright (c) 2019 C A Boadu Jnr

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
