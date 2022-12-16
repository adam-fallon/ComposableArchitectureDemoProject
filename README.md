# ComposableArchitectureDemoProject

This is a demo project showcasing what a real app using [TCA](https://github.com/pointfreeco/swift-composable-architecture) from PointFree could look like;

![TCA](https://github.com/pitt500/OnlineStoreTCA/blob/main/Images/TCA_Architecture.png)

I'd say start at `RootView` and dig around from there is probably the best way to read the code.

## Features

- User can log in.

  <img src="https://github.com/adam-fallon/ComposableArchitectureDemoProject/blob/main/img/login.png" width="200" height="400">

- User can look at a list of their files and folders.

  <img src="https://github.com/adam-fallon/ComposableArchitectureDemoProject/blob/main/img/files.png" width="200" height="400">

    <img src="https://github.com/adam-fallon/ComposableArchitectureDemoProject/blob/main/img/no_files.png" width="200" height="400">

- User can open Photos.

    <img src="https://github.com/adam-fallon/ComposableArchitectureDemoProject/blob/main/img/photo.png" width="200" height="400">

## Running

You need to change the `baseURL` in `APIConfiguration` to point to a server that returns data that is defined in `JSON Schemas` in the root folder.

The folder is laid out the same way the endpoint should respond, but for clarity you need endpoints;

- `/me`
- `/items/{id}`
- `/items/{id}/data`

## Code layout

### Constants

- Just contains an enum of filetypes expected from the API

### Services

Anything that handles interaction with an external dependency, be that from a third party API or some system on the Operating System, services are a layer over the messy details that give us data we care about.

Services are registered as dependencies in the same file they are defined.

This practically just means the following small conformances are made in the file;

A `Service` will be;
_ A Struct defining it's dependencies, all functions are implemented as closures.
_ Have a conformance to `DependencyKey` which requires a `liveValue` implementation. \* An extension on `DependencyValues` which adds the type to the dependency resolution runtime container.

Then in a seperate file (Typically under `Contexts/Tests/`) there will be an extension on `Service` implementing the `testValue`, which is automatically swapped out in the test (handled by the ComposableArchitecture framework.)

### Domains

This is where features are defined. For any given feature there is; \* Models (Folder)
POSO's (Mostly generated from QuickType to save time)

    * Store
    Stores are made up of State, Action, Reducer.

### Contexts

A context is a definition conforming to `AppContext`, which in itself is a definition of everything required to make the app run.

There is a `AppContext` configured which is used in the Production app.

### Views

SwiftUI Views. Views will have a Store, and then the ViewBuilder `WithViewStore` which is used to transform a Store -> ViewStore which means state changes in a store can then be observed by a view. Magic!

Worth noting is how small the views are given how much logic is going on here, I think the Stores encapsulate away anything that isn't presentation nicely!

### UI Tests

UI tests.

### Unit Tests

Unit tests.
