# Jenkins Infrastructure Setup Documentation

## Overview

This document provides a detailed guide for setting up and configuring a Jenkins infrastructure in AWS ECS, meeting specific requirements such as data persistence, debugging capabilities, automated configuration using JCASC, installing requried plugins like ec2, cloud AWS EC2 agent setup, monitoring setup and automated sample job which utilizes ec2 as agent.

## Table of Contents

- [Introduction](#introduction)
- [Setup and Configuration](#setup-and-configuration)
  - Docker
  - plugins
  - JcasC
- [Infrastrcture](#infrastrcture)
  - Terraform resorces
    - IAM Role
    - ECR
    - Local provisioner
    - ECS Cluster and Service
    - Cloudwatch
    - Alarms
    - Security groups
    - Loadbalancer (optional)
## Introduction

Jenkins is a widely used open-source automation server that enables teams to automate various stages of the software development lifecycle, including building, testing, and deploying applications. This document serves as a comprehensive guide for setting up and configuring a Jenkins infrastructure in AWS ECS utiling  terraform, docker and Jcasc. 

## Setup and Configuration
