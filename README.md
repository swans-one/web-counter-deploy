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


### Podman + Quadlet usage

The quadlet usage assumes you have a host / server set up with the
project `cp`'d / git pulled into a directory named:
`/home/deployed/repos/web-counter-deploy` and that you can log into
the user using ~machinectl~.
