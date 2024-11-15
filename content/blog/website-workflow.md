---
title: "The automated workflow I use to manage this website"
date: 2023-07-24T13:20:26+02:00
draft: false
---

EDIT: This article is slitghly outdated as the workflow I use to maintain this website has evolved and improved over time (but it still gives a fairly good idea of a simple but effective CI / CD workflow one could apply to their projects). I'll eventually write a V2 of that article at some point.

## The website

This website is built with the [HUGO](https://gohugo.io/) static website generator using the [anatole](https://github.com/lxndrblz/anatole) theme.  
The website's source code is hosted in [this GitHub repository](https://github.com/Antiz96/antiz.fr/).

## Automated workflow

To manage this website, I use an automated CI / CD workflow:

### CI

I make my changes *(creating an new article, update the theme, add new parameters to the website, etc...)* locally on my computer inside the git repository in the dev branch.  
Once the changes are done, I push them to the GitHub repository and I create a pull request from the dev branch to the main one, which triggers a CI pipeline:

![alt_text](../../images/Website_GitHub_MR_CI.png "Website - Merge Request CI Pipeline")

This CI pipeline is divided into two jobs:

![alt_text](../../images/Website_GitHub_CI_Jobs.png "Website - Merge Request CI Jobs")

- The build job:

The [build job](https://github.com/Antiz96/antiz.fr/blob/main/.github/workflows/CD.yml) automatically builds the website against the new changes I made and, if the build succeeds, it automatically pushes the built website to the dev branch (and thus, add it to the current merge request).

- The test job:

The [test job](https://github.com/Antiz96/antiz.fr/blob/main/.github/workflows/CI.yml) automatically runs a bunch of tests / linters against the website's files in the repository, to make sure the changes I made are correctly written / syntaxed.

### CD

Once both of the above CI jobs succeeded (meaning the website has been successfully built, pushed to the dev branch of the repository, and the tests went through without any error), I launch a job on my [Jenkins](https://www.jenkins.io/) server targeting the dev environment *(edit: the trigger of that job is now automated via GitHub actions as well):

![alt_text](../../images/Jenkins_Update_Website_Job_Dev.png "Jenkins - Update Website Job Dev")

This Jenkins job runs a simple [Ansible](https://www.ansible.com/) playbook (see that playbook [here](https://github.com/Antiz96/Linux-Server/blob/main/Ansible-Playbooks/roles/update_antiz.fr/tasks/main.yml)) that aims to update the website's sources on the targeted environment against the related GitHub branch (dev branch --> development environment, main branch --> production environment):

![alt_text](../../images/Jenkins_Update_Website_Job_Param.png "Jenkins - Update Website Job Parameters")

I can then review what my changes on my development environment.

Once the changes have been reviewed and declared "ready" to go to production, the only thing I need to do is to merge the changes to the main branch on the GitHub repository and relaunch my Jenkins job, targeting the "prod" environment this time, so the changes are pushed against the main branch to the VPS which hosts this website:

![alt_text](../../images/Jenkins_Update_Website_Job_Prd.png "Jenkins - Update Website Job Prod")

This workflow aims to evolve and be improved over time but it's a good example of a simple; yet effective, flexible and reliable automated CI / CD workflow you can use to manage your projects! :smile:
