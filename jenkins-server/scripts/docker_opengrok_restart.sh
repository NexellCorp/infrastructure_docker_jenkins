docker stop con_opengrok
docker rm con_opengrok
docker run --name con_opengrok --rm -v /home/Opengrok_Storage/src:/src -v /home/Opengrok_Storage/data:/data -p 9000:9000 nexelldocker/opengrok

