# pure-ftpd-docker

- <https://github.com/jedisct1/pure-ftpd>

## Usage

Copy these files to a new directory.

- `docker-compose.yml`
- `pure-ftpd.conf.template` -> `pure-ftpd.conf`
- `template.env` -> `.env`

After the configuration, start a docker compose service.

```shell
docker compose up -d
```

### Configuration: puredb (Virtual user)

- Reference: <https://github.com/jedisct1/pure-ftpd/blob/201bf0c31c33c0f1750642ba725e404f707ae41a/README.Virtual-Users>

Create `pureftpd.passwd` like below.

```passwd
hoge:<hashed_password>:1000:1000::/ftphome/hoge:::::::::::::
```

To hash a password,

```shell
sudo apt install openssl

# SHA-512
openssl passwd -6
```

Open `pure-ftpd.conf` and configure like below.

```conf
Daemonize                    false
NoAnonymous                  yes
PureDB                       /etc/pureftpd.pdb
AltLog                       clf:/pureftpd-logs/pureftpd-clf.log
CreateHomeDir                yes
PassivePortRange             30000 30009
ForcePassiveIP               127.0.0.1
```
