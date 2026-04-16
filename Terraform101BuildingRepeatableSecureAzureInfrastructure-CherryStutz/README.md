# Terraform 101: Building Repeatable, Secure Azure Infrastructure #

# Abstract #
Infrastructure as Code isn’t optional anymore—it’s the modern foundation for delivering consistent, secure, and repeatable Azure environments. However, many teams struggle to get past the basics, defining brittle templates or using unsafe state management practices.

This session is a practical introduction to Terraform on Azure, built for engineers who want to move from ClickOps and basic deployment scripts to a maintainable setup that can work in production. We’ll cover:

- Authoring core HCL: providers, resources, variables, and tfvars
- Structuring reusable modules with naming, tagging, and inputs/outputs that scale
- Managing state the safe way with Azure Storage, locks, and environment isolation (dev/test/prod)
- Automating deployments in a simple CI pipeline with OIDC authentication—no secrets in your YAML

Through live demos, you’ll see a small Azure footprint (resource group, VNet, subnets, Key Vault) provisioned and promoted through a pipeline with approvals.

By the end, you’ll understand the “why” behind Infrastructure as Code and leave with patterns you can copy, adapt, and operationalize in your own Azure environment.

# Speakers #
- Blake Cherry
- Daniel Stutz

# GitHub Repository Link #
- [Terraform 101: Building Repeatable, Secure Azure Infrastructure](https://github.com/Blakelishly/tf-azure-demos-summit26)