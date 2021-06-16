# automation

## NFS

### Commands

Replace the directory and for the admin account and run the below:

```bash
docker run --cap-add SYS_ADMIN --detach \
  --name nfs \
  --publish 2049:2049 \
  --restart always \
  --volume /host/path/to/shared/files:/some/container/path \
  --volume $PWD/exports.txt:/etc/exports:ro \
  erichough/nfs-server
```

For multiple shares:

```bash
docker run --cap-add SYS_ADMIN --detach \
  --env NFS_EXPORT_0='/some/container/path *(ro,no_subtree_check)' \
  --env NFS_EXPORT_1='/some/container/otherpath 123.123.123.123/32(rw,no_subtree_check)' \
  --name nfs \
  --publish 2049:2049 \
  --restart always \
  --volume /host/path/to/shared/files:/some/container/path \
  --volume /host/otherpath/to/shared/files:/some/container/otherpath \
  erichough/nfs-server
```

In case of ERROR: nfs module is not loaded in the Docker host's kernel (try: modprobe nfs), try the below commands and run again the container command.

```bash
sudo ros service enable kernel-extras
sudo ros service up kernel-extras
sudo modprobe nfs
sudo modprobe nfsd
```