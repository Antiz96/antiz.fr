---
title: "The automated workflow I use to manage this website"
date: 2023-07-24T13:20:26+02:00
draft: false
---

## The website

This website is built with the [HUGO](https://gohugo.io/) static website generator using the [anatole](https://github.com/lxndrblz/anatole) theme.  
The website's source code is hosted in [this GitHub repository](https://github.com/Antiz96/antiz.fr/).

## Automated CI / CD workflow

Every changes I made (e.g. creating a new article, update the theme, add new parameters to the website, ...) are done in my local git repository on the [`dev` branch](https://github.com/Antiz96/antiz.fr/tree/dev).  
Once the changes are pushed to GitHub, I create a pull request from the `dev` branch to the main branch, which triggers CI / CD pipelines (running on my own self-hosted runners):

![alt_text](../../images/website-workflow/CI_CD_Jobs.png "Website Workflow - CI_CD Jobs")

### CI

The [CI pipeline](https://github.com/Antiz96/antiz.fr/blob/main/.github/workflows/CI.yml) has one "Test" stage which, as the name implies, runs a bunch of tests (e.g. spellcheckers & linters):

![alt_text](../../images/website-workflow/CI_Job.png "Website Workflow - CI Job")

![alt_text](../../images/website-workflow/CI_Job_Test_Stage_Steps.png "Website Workflow - CI Job Test Stage Steps")

### CD

The [CD pipeline](https://github.com/Antiz96/antiz.fr/blob/main/.github/workflows/CD.yml) has two stages:

![alt_text](../../images/website-workflow/CD_Job.png "Website Workflow - CD Job")

- The "Build" stage:

The "Build" stage builds the website via `hugo` and then commits the built changes to my repository (still on the `dev` branch).

![alt_text](../../images/website-workflow/CD_Job_Build_Stage_Steps.png "Website Workflow - CD Job Build Stage Steps")

- The "Deploy" stage:

Once the "Build" stage has finished successfully, the "Deploy" stage is triggered.

![alt_text](../../images/website-workflow/CD_Job_Deploy_Stage_Steps.png "Website Workflow - CD Job Deploy Stage Steps")

It allows to automatically deploy the website by remotely triggering the related job on my [Jenkins](https://www.jenkins.io/) server for my website deployment. This Jenkins job can either target my `dev` or `prod` environment (the former being hosted on a virtual server in my homelab, the latter being hosted on a VPS), thanks to a dedicated parameter.

![alt_text](../../images/website-workflow/Jenkins_Job_Parameters.png "Website Workflow - Jenkins Job Parameters")

Under the hood, this Jenkins job runs a simple [Ansible](https://www.ansible.com/) playbook (see that playbook [here](https://github.com/Antiz96/Linux-Server/blob/main/Ansible-Playbooks/roles/update_antiz.fr/tasks/main.yml)) that aims to update the website's sources on the targeted environment against the related GitHub branch (`dev` branch --> development environment, `main` branch --> production environment).

When opening a pull request from the `dev` branch to the `main` branch, the "Deploy" stage of my GitHub CD pipeline automatically triggers the related Jenkins job (which itself triggers the related Ansible playbook) targeting my `dev` environment, so my changes gets automatically deployed and I can review them on my development environment.

Once I reviewed the changes on my development environment and they are ready to go to production, I can just merge the pull request to the `main` branch which will [trigger a new run of the CD pipeline](https://github.com/Antiz96/antiz.fr/blob/main/.github/workflows/CD.yml#L4-L6) with the "Deploy" stage targeting the `prod` environment this time!

This workflow may evolve and be improved over time but it's a good example of a simple; yet effective, flexible and reliable automated CI / CD workflow you can use to manage your projects! :smile:
