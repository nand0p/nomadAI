job "worker" {
  datacenters = ["dc-aws-001"]
  type = "batch"

  constraint {
    operator  = "distinct_hosts"
    value     = "true"
  }

  group "nomadAI" {
    count = 1

    task "worker" {
      driver = "raw_exec"
      config { 
        command = "python3 /home/ec2-user/nomadai/train/exec/worker.py"
      }
    }
  }
}
