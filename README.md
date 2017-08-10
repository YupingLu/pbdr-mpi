# pbdr-mpi
Minimal docker configuration for the the pbdMPI package.

# Setting Up the Container

Run:

```bash
sudo docker pull yupinglu/pbdr-mpi
sudo docker run -i -t yupinglu/pbdr-mpi
```

Alternatively, if you prefer/need to to work with the docker file directly:

1. Copy `Dockerfile` to your machine.
2. cd to the dir containing `Dockerfile`
3. `sudo docker build -t pbdr-mpi .`
4. `sudo docker run -i -t pbdr-mpi`

# Acknowledge
This image is a copy from https://github.com/RBigData/docker/tree/master/pbdr-mpi with specific changes for CADES.
