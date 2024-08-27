---
slug: /dev
sidebar_position: 0
---

# Installation

:::danger

Although some new features are only supported in the development version, it is not recommended to use if you don't know what you're doing.

:::

## Prerequisites

### Certificate

Generate a certificate by performing one of the following:

1. If you have a UniFi camera:

    ```sh
    scp ubnt@<your-unifi-cam>:/var/etc/persistent/server.pem client.pem
    ```

2. Create your own client certificate via:

    ```sh
    openssl ecparam -out /tmp/private.key -name prime256v1 -genkey -noout
    openssl req -new -sha256 -key /tmp/private.key -out /tmp/server.csr -subj "/C=TW/L=Taipei/O=Ubiquiti Networks Inc./OU=devint/CN=camera.ubnt.dev/emailAddress=support@ubnt.com"
    openssl x509 -req -sha256 -days 36500 -in /tmp/server.csr -signkey /tmp/private.key -out /tmp/public.key
    cat /tmp/private.key /tmp/public.key > client.pem
    rm -f /tmp/private.key /tmp/public.key /tmp/server.csr
    ```

### Adoption Token

In order to add a camera to Protect, you must first generate an adoption token.
The token is only valid for 60 minutes.
You will need to re-generate a new one if it expires during your initial setup.

Open https://{NVR IP}/proxy/protect/api/cameras/manage-payload and copy the token field.

## Docker

Using Docker is the recommended installation method.
The sample docker-compose file below is the recommended deployment for most users.
Note, the generated certificate must be in the same directory as the `docker-compose.yaml` file.

```yaml
version: "3.9"
services:
  unifi-cam-proxy:
    restart: unless-stopped
    build: https://github.com/zacharee/unifi-cam-proxy.git
    volumes:
      - "./client.pem:/client.pem"
    command: unifi-cam-proxy --host {NVR IP} --cert /client.pem --token {Adoption token} rtsp -s rtsp://192.168.201.15:8554/cam'
```

### Multiple cameras

To use multiple cameras, start an instance of the proxy for each, with a unique MAC address argument.
Using docker-compose, your setup might look like the following:

***Note: This conforms to MAC randomization rules, so should not cause issues with real devices.***
***See here for more details: <https://www.mist.com/get-to-know-mac-address-randomization-in-2020/>***

```yaml
version: "3.5"
services:
  proxy-1:
    restart: unless-stopped
    build: https://github.com/zacharee/unifi-cam-proxy.git
    volumes:
      - "./client.pem:/client.pem"
    command: >-
        unifi-cam-proxy
        --host {NVR IP}
        --mac 'AA:BB:CC:00:11:22'
        --cert /client.pem
        --token {Adoption token}
        rtsp -s rtsp://192.168.201.15:8554/cam
  proxy-2:
    restart: unless-stopped
    build: https://github.com/zacharee/unifi-cam-proxy.git
    volumes:
      - "./client.pem:/client.pem"
    command: >-
        unifi-cam-proxy
        --host {NVR IP}
        --mac 'AA:BB:CC:33:44:55'
        --cert /client.pem
        --token {Adoption token}
        rtsp -s rtsp://192.168.201.15:8554/cam
```

## Bare Metal

Development version is currently only available in docker.
