# Overview

WIP

This browser application helps you to visualize pipelines.

It is single page application written in [Eml](http://elm-lang.org).


# Requirements

- nodejs 5.5+: `brew install node`


# Installation

    npm install -g elm@0.16.0 http-server
    npm install
    elm package install

# Build

    npm run build
    open index.html

# Livedemo

    elm reactor
    npm run watch
    open http://0.0.0.0:8000/Pipeliner.elm # for debug message

or

    http://ctrabold.github.io/pipeliner/

# Ideas

- Use arrow keys to build the pipeline.
- Use CMD + arrow keys to add steps inside existing steps.
- Steps are automatically appended if no step exists.
- Remove a step with the DELETE key.
