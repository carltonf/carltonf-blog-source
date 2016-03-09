---
layout: post
title: "Flux (web): notes"
tags:
- flux
- reactive
- web
---

Some notes on `Flux`, a web framework *mindset* popularized by `ReactiveJS`. I'm not personally using it for now, but the ideas behind `Flux` has seen wide adoptions. I feel this *wide adoption* mostly through my learning `Angular 2`.

Flux | Application Architecture for Building User Interfaces
============================================================
(facebook.github.io)

> Flux applications have three major parts: the dispatcher, the stores, and the views (React components)


> This structure allows us to reason easily about our application in a way that is reminiscent of **functional reactive programming**, or more specifically **data-flow programming** or **flow-based programming**, where data flows through the application in a single direction ... When updates can only change data within a single round, the system as a whole becomes more predictable.

I think here lies the cornerstone of the whole structure: single data flow direction. I know too little to argue about the efficiency but in theory it does greatly simplify the reasoning and management overhead.

> The dispatcher is the central hub that manages all data flow in a Flux application. It is essentially a registry of callbacks into the stores and has **no real intelligence of its own**...


> Stores contain the application state and logic ..., stores manage **the application state for a particular domain** within the application. ... of both a collection of models and a singleton model of a logical domain.

Q: What is this *particular domain*?


> We often pass the entire state of the store down the chain of views in a single object ...

They can do this because the single data flow direction has made sure that no descendants can alter the state even given the access to the whole state.
