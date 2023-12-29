# python-infra
Local python infrastructure

```shell
docker-compose -f docker-compose.yml up -d
cd ./python_base_image
# docker login localhost:5001 
docker build -t localhost:5001/docker-python:3.12 . 
docker push localhost:5001/docker-python:3.12 
cd ..
```
