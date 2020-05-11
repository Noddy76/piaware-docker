# Piaware-Docker

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: piaware
  labels:
    app: piaware
spec:
  selector:
    matchLabels:
      app: piaware
  replicas: 1
  strategy: 
    type: Recreate
  template:
    metadata:
      labels:
        app: piaware
    spec:
      containers:
      - name: piaware
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
          - name: http
            containerPort: 8080
            protocol: TCP
        volumeMounts:
        - name: config
          mountPath: /etc/piaware
      volumes:
      - name: config
        configMap:
          name: piaware
```
