import tensorflow as tf
import numpy as np


strategy = tf.distribute.MirroredStrategy()

with strategy.scope():
  model = tf.keras.Sequential([tf.keras.layers.Dense(1, input_shape=(1,),
                               kernel_regularizer=tf.keras.regularizers.L2(1e-4))])
  model.compile(loss='mse', optimizer='sgd')



#inputs, targets = np.ones((100, 1)), np.ones((100, 1))
#model.fit(inputs, targets, epochs=2, batch_size=10)



#results = model.evaluate(val_dataset)
# Then, log the results on a shared location, write TensorBoard logs, etc

