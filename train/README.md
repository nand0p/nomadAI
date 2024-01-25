# Train Models

- Nomad HCL job definitions are used to schedule the Python code or Docker Container on cluster

  - Ad-Hoc Jobs
    * These jobs can be schedules by issuing `nomad run` command on cli
    * This is for iteratively working the code/model

  - Final Model (Jobs execute upon Cluster convergance)
    * Nomad Jobs can trigger immediately upon cluster formation.
    * If the HCL job definitions exist in this directoy, they will execute on workers 1:1
      - HCL jobs must execute on a single Nomad worker, to avoid hardware compete
      - The following Job Names can be commited:
        * `chief.hcl`
        * `worker.hcl`
        * `parameter.hcl`
        * `evaluator.hcl`
