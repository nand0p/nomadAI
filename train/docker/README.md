# Dockerized Tensorflow

- Python code execs in container, on the nomad cluster.

- Nomad job definitions (HCL code) execute on the cluster.


## Docker Build Pipeline

- tensorflow docker images are created and tested 

- nomad job HCL is executed, and container runs on the cluster


## Single vs Multi Worker Training

- Existing tensorflow code works as-is on a single hardware node

- Multi-worker enhancements happen iteratively

- Nomad scheduler allows for flexibility of configurations.


## Worker Types

- Worker 0 (Chief Node)

- Workers (run Nomad HCL job definitions)

- Evaluator (needs to run on hardware accelerated node - test if training is correct)

- Parameter Server (this may not be needed, as job definitions can inject parameters)

