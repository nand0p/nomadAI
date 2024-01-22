# Set TF_CONFIG
os.environ['TF_CONFIG'] = json.dumps({
    'cluster': {
        'worker': ["localhost:12345", "localhost:23456"]
    },
    'task': {'type': 'worker', 'index': 0}
})


# Open a strategy scope and create/restore the model.
strategy = tf.distribute.experimental.MultiWorkerMirroredStrategy()
with strategy.scope():
  model = make_or_restore_model()

callbacks = [
    # This callback saves a SavedModel every 100 batches
    keras.callbacks.ModelCheckpoint(filepath='path/to/cloud/location/ckpt',
                                    save_freq=100),
    keras.callbacks.TensorBoard('path/to/cloud/location/tb/')
]
model.fit(train_dataset,
          callbacks=callbacks,
          ...)

