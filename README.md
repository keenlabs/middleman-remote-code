# A Middleman Plugin

## First, what's middleman?

[Middleman](http://middlemanapp.com) is a static site generator/toolkit. It's
pretty awesome, and is the underpinnings for
[Slate](http://github.com/tripit/slate).

Middleman has a composable plugin system that we've used to solve a particular
problem.

## Ok, what's the problem?

It gets difficult to manage code examples in multiple locations and there
should always be a source of truth. To keep things simple, this should be
sitting right alongside the actual work. Most of the work we do is in GitHub
repositories.

Thus, the problem is:

> How do we include canonical examples in comprehensive guides when the code is stored elsewhere?

## How does this (attempt to) solve it?

This introduces a specific code block called `remote`.

You use it like this:

    See this example usage:

    ```remote
    Fetch from http://some.github.io/url/markdown.md#0
    ```

And then this plugin discovers the URL, fetches it and parses it with the
original Markdown configuration for middlemannd parses it with the original
Markdown configuration for Middleman.

Except it intercepts all code blocks. The `#0` says, "Use the _first_ code
block" (because we're programmers and we start counting from zero)

This will then inject the remote code block, along with the original language.
It then passes it on to the next renderer in the pipeline. I recommend you use
the `middleman-syntax` renderer, because you like your things to look nice,
don't you?

## Limitations & TODO

I want to have named code blocks work, so in the source document we can have:

    ```python#create_client
    from keen.client import KeenClient

    client = KeenClient(
        project_id="xxxx",
        write_key="yyyy",
        read_key="zzzz"
    )
    ```

And then fetch them with `http://somepath.com/file.md#create_client` rather than easy-to-break numerical offsets.

# Should I use this in my project?

No.

Or go ahead, I'm a README not a cop.
