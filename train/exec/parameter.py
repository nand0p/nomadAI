ps_strategy = tf.distribute.experimental.ParameterServerStrategy()
parameter_server_strategy = tf.distribute.experimental.ParameterServerStrategy()

os.environ["TF_CONFIG"] = json.dumps(
    {
        "cluster": {
            "worker": ["host1:port", "host2:port", "host3:port"],
            "ps":  ["host4:port", "host5:port"]
        },
        "task": {
            "type": "worker",
            "index": 1
        }
    }
)
