# Oracle Cloud Infrastructure Monitoring Examples 
## Case01: Auto Scale with Monitoring Alarm + Notifications
Example of setting the CPU threshold and executing Auto Scaling when the threshold is exceeded, and at the same time firing an Alarm trigger and sending an email notification

![](../autoscaling_with_alarm_notifications.png)

## How to run

1. Set env-vars
In this file, you should write necessary information (like below) in order to build cloud environments by terraform.

- User Credentials (user_ocid, fingerprint ..etc)
- Region
- ssh_key files
- and so on...

[env-vars-sample](./env-vars-sample) is a good exaple.

2. Load env-vars

```
$ source env-vars
```

3. Run Terraform

```
# Init
$ terrafrom init

# Plan
$ terraform plan

# Apply
$ terraform apply
```

4. Run CPU Load test

```
$ terraform apply -var 'exec_cpu_load=true'
```

5. Check Monitoring, Alarm Status and Auto Scaling history

6. Clean environments

```
$ terraform destroy
```

