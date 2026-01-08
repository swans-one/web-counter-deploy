# A Website with a Counter

This project is a website, that has a visitor counter. Very simple!

It's made as a basic site to test different deployment
configurations. As such it attempts to include a few layers:

- Frontend + Backend framework -- using svelte + sveltekit
- Database -- uses sqlite with migrations managed with dbmate
- API layer -- a secondary backend layer using python with FastAPI

Obviously you could build this functionality from simpler pieces, but
the goal of the project is to simultaneously be:

- Complicated enough to flex different deployment strategies
- Simple enough such that this project is easy to understand / small

# Local Development

Run frontend dev server:

```
cd frontend && npm run dev
```

Run the api dev server:

```
cd api && uv run -- fastapi dev main.py
```

Run any pending migrations:

```
cd database && dbmate up
```

# Deploy strategies

Different deploy strategies are managed in different directories. A
core tenant of the deploy strategy is that it should be able to be
managed basically independently of the underlying codebase.

## Podman (and Quadlet)

### Manual Podman usage:

Under the `podman` directory are the following artifacts.

- Three `Containerfile`s, one for each section of the project:
  - `Containerfile-database`
  - `Containerfile-api`
  - `Containerfile-frontend`

These three `Containerfile`s can each correspond to an image to be
built. They can all be built using the `build-all.sh` script.

- Scripts for managing the app lifecycle
  - `build-all.sh` :: Build all the images for the app
  - `pod-create.sh` :: Create a `pod` and populate it with containers
  - `pod-start.sh` :: start the pod created from `pod-create.sh`

With these scripts you could start the webserver from scratch with:
`build-all.sh && pod-create.sh && pod-start.sh`

There are also a couple scripts for managing quadlet which will be
covered in the next section.

### Podman + Quadlet usage

The quadlet usage assumes you have a host / server set up with the
project `cp`'d / git pulled into a directory named:
`/home/deployed/repos/web-counter-deploy` and that you can log into
the `deployed` user using ~machinectl shell deployed@ /bin/bash~ (from
the package `systemd-container`).

The quadlet files are contained in the directory `podman/quadlet`. It
includes the following unit files. They're described below with their
main purpose and any distinguishing features.

- `web-counter.pod` :: A pod holds all the other running containers.
  - A single volume is mounted, which will automatically be mounted to
    all interior containers
  - Internally all containers can communicate over localhost
  - A single port is exposed from the pod externally
  - The pod has a "pause container" which should come up before any of
    the internal containers
- `web-counter-database.volume` :: The volume mounted by the pod for the db
- `web-counter-database-init.container` :: A container to initialize the db
  - This container runs once and exits each time
    - This behavior is similar to a "pod init container" specified the
      `podman create` flag `--init-ctr=always`. But this flag isn't
      exposed by quadlet.
    - Instead, we use a combination of `Type=oneshot` with
      `RemainAfterExit=yes` to mark this service as being successfull
      when it exits successfully, alongside marking it as
      `PartOf=web-counter.pod` which causes it to be restarted when
      the pod is restarted.
- `web-counter-database-init.build` :: Builds the image locally for
  the database init container.
- `web-counter-api.container` :: Container for the python fastapi api
  - We specify the location of database (mounted through the volume)
    via an environment variable
- `web-coutner-api.build` :: Builds the image locally for the api
  container
- `web-counter-frontend.container` :: Container for the svelte+kit
  application
- `web-counter-frontend.build` :: Builds the image locally for the
  svelte+kit container.

Also inside the `podmand` directory are a couple scripts to help
manage these unit files.

- `quadlet-setup.sh` :: Copies all the unit files into the correct
  place for the `podman-systemd-generator` to find them. Namely
  `$HOME/.config/containers/systemd`. Then runs `daemon-reload`.
- `quadlet-dryrun.sh` Runs the `podman-systemd-generator` in dry-run
  mode to detect any errors with the syntax/configuraiton of the unit
  files.

To actually start the webapp, use `systemctl` to bring up the
`web-counter-pod` service:

```
systemctl --user start web-counter-pod.service
```

Because our naming convention prefixes all services with "web-counter"
you can monitor the whole set of services with glob patterns. Here are
a couple useful commands:

```
journalctl --user -f -u web-counter*
systemctl --user list-units web-counter*
systemctl --user list-dependencies web-counter*
```

### Podman + Quadlet Reference

For more info on the details of these unit files, the [Quadlet Man
Pages](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html)
are an excellent resource.

Also see:

- [systemd.unit — Unit configuration](https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html)
- [systemd.service — Service unit configuration](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html)
