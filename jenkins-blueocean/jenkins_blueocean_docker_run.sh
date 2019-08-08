sudo docker run -it --name con_bl_jenkins --rm -v /home/suker/nexell_CI/jenkins-blueocean/jenkins_home:/var/jenkinss_home -p 8080:8080 -p 50000:50000 \
	 nexelldocker/jenkins-blueocean
