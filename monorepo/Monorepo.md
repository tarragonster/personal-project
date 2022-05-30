# Monorepo

### Why do I need Monorepo

- Visibility: see company entire codebase in one place.
- Consistency: can share thing like eslint config, UI component, documents.
- Dependency management: see entire dependency graph.
- share module: dedupe packages that used multiple app.

### Problem with Monorepo

- Problems: monorepo get larger -> more thing to build/test, more artifacts to store (make your starting slow).
- Can use yarn as monorepo tooling -> configure app with root level package json 
  -> nested workspaces linked back to root level project (not solving the problem)

- Solutions:
    + lerna optimize workflow of multiple package repo
    + Nx vs turborepo operate as smart build system
    + Mentioned tool will create dependency tree among all of your apps and packages to understand
      what needs to be tested and what needs to be rebuilt whenever a change 
      to codebase.
    + cache file or artifact already been built and can run job in parallel
      to make thing faster
      
### Reference

[Vid] Alex Ziskind - [Fastest way to build a monorepo | Turborepo vs Nx](https://www.youtube.com/watch?v=NM-aab5GpKo&ab_channel=AlexZiskind) \
[Code] vsavkin - [large-monorepo benchmark Nx, Turbo, and Lerna](https://github.com/vsavkin/large-monorepo) \

[Code] Elvincth - [turbo-strapi-nextjs](https://github.com/Elvincth/turbo-strapi-nextjs) \
