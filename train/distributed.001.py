from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.layers import *
from tensorflow.keras.models import *
import tensorflow_datasets as tfds
import matplotlib.pyplot as plt
import tensorflow as tf
import time

print('terraform version:', tf.__version__)

strategy = tf.distribute.MirroredStrategy()
print('Number of devices: {}'.format(strategy.num_replicas_in_sync))
#tfds.disable_progress_bar()
tfds.list_builders()

(raw_train, raw_validation), metadata = tfds.load(
    'cats_vs_dogs',
    split=['train[:80%]', 'train[80%:]'],
    with_info=True,
    as_supervised=True
)

get_label_name = metadata.features['label'].int2str
for image, label in raw_train.take(2):
    plt.figure()
    plt.imshow(image)
    plt.title(get_label_name(label))

IMG_SIZE = 224 # All images will be resized to 224x224

def format_example(image, label):
    image = tf.cast(image, tf.float32)
    image = (image/127.5) - 1
    image = tf.image.resize(image, (IMG_SIZE, IMG_SIZE))
    return image, label

# Preprocess the images
train = raw_train.map(format_example)
valid = raw_validation.map(format_example)

# Calculate batch size
batch_size_per_replica = 32
batch_size = batch_size_per_replica * strategy.num_replicas_in_sync

# Prepare batches and randomly shuffle the training images
AUTO = tf.data.experimental.AUTOTUNE
train_batches = train.shuffle(1024).repeat().batch(batch_size).prefetch(AUTO)
valid_batches = valid.repeat().batch(batch_size).prefetch(AUTO)

# Inspect the shapes
for (images, labels) in train_batches.take(1):
    pass
print(images.shape, labels.shape)

d = train.batch(batch_size)
x = valid.batch(batch_size)

def calculate_steps(dataset):
    steps = 0
    for _ in dataset:
        steps += 1
    return steps
print(calculate_steps(d))
print(calculate_steps(x))

start_lr = 0.00001
min_lr = 0.00001
max_lr = 0.00005 * strategy.num_replicas_in_sync
rampup_epochs = 5
sustain_epochs = 0
exp_decay = .8

def lrfn(epoch):
    def lr(epoch, start_lr, min_lr, max_lr, rampup_epochs, sustain_epochs, exp_decay):
        if epoch < rampup_epochs:
            lr = (max_lr - start_lr)/rampup_epochs * epoch + start_lr
        elif epoch < rampup_epochs + sustain_epochs:
            lr = max_lr
        else:
            lr = (max_lr - min_lr) * exp_decay**(epoch-rampup_epochs-sustain_epochs) + min_lr
        return lr
    return lr(epoch, start_lr, min_lr, max_lr, rampup_epochs, sustain_epochs, exp_decay)
    
lr_callback = tf.keras.callbacks.LearningRateScheduler(lambda epoch: lrfn(epoch), verbose=True)

rng = [i for i in range(10)]
y = [lrfn(x) for x in rng]
plt.plot(rng, [lrfn(x) for x in rng])
print(y[0], y[-1])

def get_training_model():
    # Load the MobileNetV2 model but exclude the classification layers
    EXTRACTOR = MobileNetV2(weights='imagenet',
                            include_top=False,
                            input_shape=(IMG_SIZE, IMG_SIZE, 3))
    # We are fine-tuning
    EXTRACTOR.trainable = True
    # Construct the head of the model that will be placed on top of the
    # the base model
    class_head = EXTRACTOR.output
    class_head = GlobalAveragePooling2D()(class_head)
    class_head = Dense(512, activation="relu")(class_head)
    class_head = Dropout(0.5)(class_head)
    class_head = Dense(1)(class_head)

    # Create the new model
    pet_classifier = Model(inputs=EXTRACTOR.input, outputs=class_head)

    # Compile and return the model
    pet_classifier.compile(loss=tf.keras.losses.BinaryCrossentropy(from_logits=True), 
                          optimizer="adam",
                          metrics=["accuracy"])

    return pet_classifier


LABELS = ["cat", "dog"]

# Train the model
with strategy.scope():
    model = get_training_model()

start = time.time()

model.fit(train_batches,
    steps_per_epoch=146,
    validation_data=valid_batches,
    validation_steps=37,
    epochs=10,
    callbacks=[WandbCallback(data_type="image", labels=LABELS)])

end = time.time()-start

print("model training time", end)
