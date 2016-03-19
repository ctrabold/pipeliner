# Overview

WIP

This browser application helps you to visualize pipelines.

It is single page application written in [Eml](http://elm-lang.org).


# Requirements

- elm 0.16+: `brew install elm`


# Installation

    elm package install
    npm installl

# Build

    webpack
    open index.html

# Livedemo

    elm reactor
    webpack --progress --colors --watch
    open http://0.0.0.0:8000/Pipeliner.elm # for debug message

or

    http://ctrabold.github.io/pipeliner/

# Ideas

- Use arrow keys to build the pipeline.
- Use CMD + arrow keys to add steps inside existing steps.
- Steps are automatically appended if no step exists.
- Remove a step with the DELETE key.
