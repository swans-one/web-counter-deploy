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

# Deploy strategies

Different deploy strategies are managed on different branches, which
should be kept up to the main branch by rebasing.

This is so that each deploy strategy can include files in the
repository without having conflicts / confusing duplication.
