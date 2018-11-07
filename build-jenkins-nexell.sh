#!/bin/sh

sudo docker build -t ubuntu/openjdk-8 ./jenkins-ubuntu
sudo docker build -t jenkins/base-ubuntu ./jenkins-latest
sudo docker build -t nexelldocker/jenkins ./jenkins-nexell
