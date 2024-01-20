iimport os
import json

import tensorflow as tf
import mnist_setup


# Set TF_CONFIG
os.environ['TF_CONFIG'] = json.dumps({
    'cluster': {
        'worker': ["localhost:12345", "localhost:23456"]
    },
    'task': {'type': 'worker', 'index': worker_index}
})

worker_index = 1  # For instance
tf_config = json.loads(os.environ['TF_CONFIG'])
per_worker_batch_size = 64
num_workers = len(tf_config['cluster']['worker'])
global_batch_size = per_worker_batch_size * num_workers
multi_worker_dataset = mnist_setup.mnist_dataset(global_batch_size)

strategy = tf.distribute.MultiWorkerMirroredStrategy()

callbacks = [
    keras.callbacks.ModelCheckpoint(filepath='local/path/ckpt', save_freq=100),
    keras.callbacks.TensorBoard('local/path/tb/')
]

with strategy.scope():
  # Model building/compiling need to be within `strategy.scope()`.
  #multi_worker_model = mnist_setup.build_and_compile_cnn_model()
  multi_worker_model.fit(multi_worker_dataset,
                         epochs=3,
                         steps_per_epoch=70,
                         callbacks=callbacks)
