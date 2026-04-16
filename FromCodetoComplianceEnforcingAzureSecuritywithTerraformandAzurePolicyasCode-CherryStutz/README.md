# From Code to Compliance: Enforcing Azure Security with Terraform and Azure Policy-as-Code #

# Abstract #
“Set it and forget it” doesn’t cut it for cloud security—you need proof that controls are consistently enforced. Azure Policy provides that enforcement layer, but managing definitions, initiatives, and assignments by hand quickly becomes a mess.

This session shows how to operationalize Azure Policy with Terraform, so your baselines are versioned, reviewable, and consistently applied across subscriptions and management groups. Beyond simply deploying policy, you’ll see how treating policies as code unlocks change control, peer review, and CI/CD approval workflows—making compliance part of your release process instead of an afterthought.

We’ll start with a quick primer on Azure Policy for anyone new to its concepts (definitions, initiatives, assignments, exemptions, and remediations), then move into practical patterns and live demos:
- Author and organize policy definitions and initiatives
- Parameterize assignments per scope, attach non-compliance messages, and configure deployIfNotExists remediations with the right role assignments
- Manage exemptions cleanly (temporary, scoped, time-boxed) while avoiding “exemption sprawl”
- Integrate policy into CI/CD: pull requests for changes, approval gates for rollout, and drift detection for audits
- End-to-end demo: define an initiative, assign it at a management group, exempt a subscription for a pilot, and kick off remediations — all in Terraform

By the end, you’ll know how to evolve your Azure Policy workflows to be repeatable, auditable, and code-driven that fit neatly into modern DevOps practices.

# Speakers #
- Blake Cherry
- Daniel Stutz

# GitHub Repository Link #
- [From Code to Compliance: Enforcing Azure Security with Terraform and Azure Policy-as-Code](https://github.com/Blakelishly/tf-azure-policy-accelerator-summit26)