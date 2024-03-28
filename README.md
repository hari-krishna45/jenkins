# Jenkins Infrastructure Setup Documentation

## Overview

This document provides a detailed guide for setting up and configuring a Jenkins infrastructure in AWS ECS, meeting specific requirements such as data persistence, debugging capabilities, automated configuration using JCASC, installing requried plugins like ec2, cloud AWS EC2 agent setup, monitoring setup and automated sample job which utilizes ec2 as agent.

## Table of Contents

- [Introduction](#introduction)
- [Setup and Configuration](#setup-and-configuration)
  - Docker
  - Plugins
  - JcasC
- [Infrastrcture](#infrastrcture)
  - Terraform resorces
  - Instructions
## Introduction

Jenkins is a widely used open-source automation server that enables teams to automate various stages of the software development lifecycle, including building, testing, and deploying applications. This document serves as a comprehensive guide for setting up and configuring a Jenkins infrastructure in AWS ECS utiling  terraform, docker and Jcasc. 

## Setup and Configuration
**Docker**

Docker simplified software development by offering a standardized method to package, share, and execute applications using containers. In this project, Docker played a pivotal role in streamlining the Jenkins infrastructure. Leveraging Docker, we constructed a tailored Jenkins image by extending the latest Jenkins base image available on Docker Hub ([jenkins/jenkins](https://hub.docker.com/r/jenkins/jenkins)). We customized the image by including essential plugins, a JCasC configuration file, a PEM key, and some environment variables. Notably, to circumvent permission constraints during the mounting of EFS, we transitioned to the root user, ensuring seamless integration with the Elastic File System. 

**Plugins**

We've integrated the following plugins into the Jenkins image:

- **configuration-as-code**: This plugin automates Jenkins configurations using code, ensuring consistency and reproducibility.

- **workflow-cps**: This plugin enables the use of Groovy scripts in Jenkins pipelines, facilitating advanced workflow automation.

- **job-dsl**: With this plugin, automated job creation and management become possible, allowing for the definition of jobs as code.

- **ssh-credentials**: This plugin facilitates the management of SSH credentials, enabling secure external SSH connections within Jenkins.

- **ec2**: Utilizing this plugin, we can seamlessly set up cloud EC2 agents, enhancing Jenkins scalability and resource utilization.

**Jenkins Configuration as Code (JCasC)**:

Jenkins Configuration as Code (JCasC) is an effective method for automating the setup of Jenkins instances using YAML or Groovy syntax. This empowers administrators to specify Jenkins configuration settings as code, facilitating version control, review, and consistent application across various Jenkins environments. In our project, we harnessed JCasC to incorporate the following elements:

1. **Credentials**: Utilizing JCasC, we defined credentials for authentication within Jenkins, ensuring secure access to external systems or resources.

2. **Authorization Strategy**: JCasC enabled us to configure the authorization strategy for Jenkins, specifying who has access to perform specific actions within the Jenkins environment.

3. **Security Realm**: We employed JCasC to define the security realm for Jenkins, determining how user authentication and authorization are handled, enhancing overall security.

4. **Cloud EC2 Template**: Leveraging JCasC, we set up a cloud EC2 template, specifying the configuration for dynamically provisioning EC2 instances as Jenkins agents.

5. **Sample Job with EC2 Agent**: We utilized JCasC to define a sample Jenkins job that utilizes an EC2 agent, demonstrating how Jenkins can dynamically scale by provisioning agents on-demand in the cloud.

6. **Environment Variables**: Certain configuration values were parameterized using environment variables, providing flexibility and allowing for customization based on deployment environments.

## Infrastrcture

