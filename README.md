# Overview

WIP

This browser application helps you to visualize pipelines.

It is single page application written in [Eml](http://elm-lang.org).

[![Build Status](https://travis-ci.org/ctrabold/pipeliner.svg?branch=master)](https://travis-ci.org/ctrabold/pipeliner)

# Requirements

- homebrew 0.9+: [install](http://brew.sh/)
- nodejs 5.5+: `brew install node`


# Installation

    git clone https://github.com/ctrabold/pipeliner.git
    npm run setup

# Build

    npm run build
    open index.html

# Livedemo

    elm reactor
    npm run watch
    open http://0.0.0.0:8000/Pipeliner.elm # for debug message

or

    http://ctrabold.github.io/pipeliner/

# Development

    # Install `elm-format`
    brew tap homebrew/devel-only; brew install --devel elm-format
    elm reactor
    npm run build
    # check code formating
    elm-format --yes Pipeliner.elm
    npm run test
    git commit
    git push

# Ideas

- Use arrow keys to build the pipeline.
- Use CMD + arrow keys to add steps inside existing steps.
- Steps are automatically appended if no step exists.
- Remove a step with the DELETE key.
