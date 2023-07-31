---
title: "The automated workflow I use to manage this website"
date: 2023-07-24T13:20:26+02:00
draft: false
---

## The website

This website is built with the [HUGO](https://gohugo.io/) static website generator using the [anatole](https://anatole-demo.netlify.app/) theme.  
It's source code is hosted in [this GitHub repository](https://github.com/Antiz96/antiz.fr/).

## Automated workflow

To manage this website, I use an automated workflow based upon CI/CD (Continuous Integration/Continuous Delivery).

### CI

I make my changes *(creating an article, update the theme, add new parameters to the website, etc...)* locally on my computer inside the git repository in the `dev` branch.  
Once the changes are done, I push them to the GitHub repo and I create a `merge request` from the `dev` branch to the `main` one, which will trigger a `CI` job.

This `CI` job is divided into two tasks: The [test](https://github.com/Antiz96/antiz.fr/blob/main/.github/workflows/test.yml) one and the [build](https://github.com/Antiz96/antiz.fr/blob/main/.github/workflows/build.yml) one.

- The test task:

The test task spawns an [Alpine Linux](https://www.alpinelinux.org/) container which automatically runs a bunch of tests/linters against the relevant files of the repository, to make sure the changes I made are correctly written/syntaxed.

- The build task:

The build task spawns an [Alpine Linux](https://www.alpinelinux.org/) container which automatically builds the website against the new changes I made via the `hugo` command and, if the build succeeded, it automatically pushes the built website to the `dev` branch (and thus, to the current `merge request`).

### CD

Once both of the above `CI` tasks succeeded (meaning the tests went through without any errors and the website has successfully been built and pushed to the `dev` branch of the repository), I launch a job on my [Jenkins](https://www.jenkins.io/) server targeting the `dev` branch: 

[Jenkins_Update_Website_Job_Dev](../images/Jenkins_Update_Website_Job_Dev.png)

This Jenkins job runs a simple [Ansible](https://www.ansible.com/) playbook hunder the hood (see that playbook [here](https://github.com/Antiz96/Linux-Server/blob/main/Ansible-Playbooks/roles/update_antiz.fr/tasks/main.yml) that aims to update the website's sources on my development server against the current state of the GitHub repository's `dev` branch:

[Jenkins_Update_Website_Job_Paramn](../images/Jenkins_Update_Website_Job_Param.png)

I can then review myself what my changes look like on my development environment, which is identical to my production environment so I'm guaranteed that what I'm seeing when reviewing changes on my development environment is exactly what it will look like once pushed to my production environment.

Once the changes have been reviewed and declared "ready" to go to production, the only thing I need to do is to merge the changes to the `main` branch on the GitHub repository (by "accepting" the pending merge request) and relaunch my Jenkins job, targeting the "prod" environment this time, so the changes are pushed to the `VPS` which hosts this website:

[Jenkins_Update_Website_Job_Prd](../images/Jenkins_Update_Website_Job_Prd.png)

This workflow aims to evolve and be improved over time but it's a good example of a simple; yet effective, flexible and reliable; automated workflow with CI/CD you can use to manage your projects! :beaming_face_with_smiling_eyes:
