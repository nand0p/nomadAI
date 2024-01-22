# Nomad Cluster for Tensorflow Distributed Model Training IN-A-BOX.

## A simple framework to deploy clusters for training of TensorFlow deep learning AI models.


- Terraform for deployment of cluster nodes on AWS (GCP, Azure, and On-Site pending)

- HashiCorp Nomad scheduler ensures fast and secure execution of TensorFlow code.

- HashiCorp Consul maintains cluster state and key/value store for cluster.

- Nomad is lighter, faster, and easier than Kubernetes for distributed model training.


## Architecture

- TensorFlow Chief Node ("Worker 0") 
- Workers Nodes 
- Parameter Server Node
- Evaluator Node
- Consul as KV store


## How to Use

- Set your cloud provider authentication environment variables

- Set variables in `variables.tf`, and execute `terraform init` & `terraform apply`

- Cluster will immediately start training model, as per Git-commited Tensorflow code.

- Trained model is saved upon completion to parameterized location (default is S3).

- Nomad cluster node instance type is set in `variables.tf`, and determines hardware available for training.

- `train` directory contains the Python code each cluster node type will execute.

## Tensorflow Cluster Nodes / Docker Containers

- Tensorflow cluster nodes (Docker Containers) run 1:1 on Nomad cluster nodes (Cloud VM Instances)

- This ensures each Tensorflow cluster node has full unobstructed connection to Nomad cluster node hardware.

### References

- https://www.tensorflow.org/guide/keras/distributed_training

- https://colab.research.google.com/github/keras-team/keras-io/blob/master/guides/ipynb/distributed_training.ipynb

- https://www.tensorflow.org/guide/distributed_training

- https://www.tensorflow.org/api_docs/python/tf/distribute/Strategy

- https://www.tensorflow.org/tutorials/distribute/multi_worker_with_keras

- https://www.tensorflow.org/api_docs/python/tf/distribute/MirroredStrategy

- https://www.tensorflow.org/api_docs/python/tf/distribute/experimental/MultiWorkerMirroredStrategy

- https://towardsdatascience.com/distributed-training-in-tf-keras-with-w-b-ccf021f9322e

- https://theaisummer.com/distributed-training/


### TODO

- GitAction pipelines to initiate model training upon tensorflow code commits
