# Consume NVIDIA GPU in scalable Kubernetes cluster

### Simple pod running `nvidia-smi` on some GPU-powered node in Kubernetes cluster

```
# run pod over gpu node
$ kubectl apply -f gpu-cuda-test.yaml

# check statis of pod is "Succeeded"
$ kubectl get po gpu-cuda-test -o template --template={{.status.phase}}

# inspect logs to see result of 'nvidia-smi' command
$ kubectl logs gpu-cuda-test

# remove pod from cluster
$ kubectl delete -f gpu-cuda-test.yaml
```

### GPU-rest-engine

**[NVIDIA GPU REST Engine (GRE)](https://developer.nvidia.com/gre)** in scalable Kubernetes environment

```
# run Nvidia GRE over Kubernetes cluster
$ kubectl apply -f gpu-rest-engine.yaml

# wait and check GRE started successful
$ kubectl get po -l app=gpu-rest-engine
NAME                               READY     STATUS    RESTARTS   AGE
gpu-rest-engine-3347887373-1chq4   1/1       Running   0          9m

# check GRE logs tu ensure REST started well
$ kubectl logs gpu-rest-engine-3347887373-1chq4
Update ld.so cache
/sbin/ldconfig.real: /usr/local/nvidia/lib/libEGL.so.1 is not a symbolic link

Starting caffe-server
2017/06/18 09:37:09 Initializing Caffe classifiers
2017/06/18 09:37:14 Adding REST endpoint /api/classify
2017/06/18 09:37:14 Adding Health-check endpoint /healthz
2017/06/18 09:37:14 Starting server listening on :8000

# run gpu-rest-tester pod to make 10000 request to infenece server
$ kubectl apply -f gpu-rest-tester.yaml

# wait while tester finished and inspect logs
$ kubectl get po gpu-rest-tester
NAME              READY     STATUS      RESTARTS   AGE
gpu-rest-tester   0/1       Completed   0          11m

$ kubectl logs gpu-rest-tester

Summary:
  Total:        116.2046 secs
  Slowest:      0.1683 secs
  Fastest:      0.0462 secs
  Average:      0.0929 secs
  Requests/sec: 86.0551
  Total data:   3440000 bytes
  Size/request: 344 bytes

Detailed Report:

        DNS+dialup:
                Average:        0.0000 secs
                Fastest:        0.0000 secs
                Slowest:        0.0029 secs

        DNS-lookup:
                Average:        0.0000 secs
                Fastest:        0.0000 secs
                Slowest:        0.0023 secs

        Request Write:
                Average:        0.0001 secs
                Fastest:        0.0001 secs
                Slowest:        0.0015 secs

        Response Wait:
                Average:        0.0927 secs
                Fastest:        0.0460 secs
                Slowest:        0.1662 secs

        Response Read:
                Average:        0.0001 secs
                Fastest:        0.0000 secs
                Slowest:        0.0007 secs

Status code distribution:
  [200] 10000 responses

Response time histogram:
  0.046 [1]     |
  0.058 [0]     |
  0.071 [0]     |
  0.083 [61]    |
  0.095 [9806]  |∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  0.107 [117]   |
  0.119 [9]     |
  0.132 [2]     |
  0.144 [1]     |
  0.156 [1]     |
  0.168 [2]     |

Latency distribution:
  10% in 0.0927 secs
  25% in 0.0927 secs
  50% in 0.0929 secs
  75% in 0.0930 secs
  90% in 0.0932 secs
  95% in 0.0933 secs
  99% in 0.1037 secs

# remove everything
$ kubectl delete -f gpu-rest-tester.yaml,gpu-rest-engine.yaml
pod "gpu-rest-tester" deleted
service "gpu-rest-engine" deleted
deployment "gpu-rest-engine" deleted
```

TODO: add examples how to scale out **gpu-rest-engine** over several GPU-powered nodes in cluster