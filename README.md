# Scrollmapper - Scripture Analysis Tool

![Scrollmap](documentation/images/scrollmap.png)

A scripture analysis tool created with Godot 4.

*Presently in prototype phase. Major features are working.*

This should work "out of the box" as a Godot 4 project. It should export as a running app without any issues. We will provide the actual package as a download after we have completed and polished the tool as a whole and completed the documentation.

## Table of Contents

- [Documentation](documentation/user/README.md)
- [What is Scrollmapper?](#what-is-scrollmapper)
- [Features](#features)
- [Getting Started](#getting-started)
- [Advanced Use: Gephi Integration](#advanced-use-gephi-integration)
- [Why a Game Engine?](#why-a-game-engine)
- [Contributing](#contributing)
- [License](#license)

## What is Scrollmapper?

Scrollmapper is a powerful scripture analysis tool designed to create detailed cross-references between canonical and apocryphal scriptures. Built using the Godot game engine, Scrollmapper leverages advanced graphical capabilities to provide an intuitive and visually appealing interface for exploring and analyzing scripture relationships.

Scrollmapper is available on Steam (link yet to be provided).

## Features

### Scripture Mapping for Cross-Reference Generation

Scrollmapper helps create cross-references to lost books such as [Enoch](https://github.com/scrollmapper/bible_databases_deuterocanonical/blob/master/sources/en/1-enoch/1-enoch.md), [Gad](https://github.com/scrollmapper/bible_databases_deuterocanonical/blob/master/sources/en/gad-the-seer/gad-the-seer.md), and [2 Esdras](https://github.com/scrollmapper/bible_databases_deuterocanonical/blob/master/sources/en/2-esdras/2-esdras.md). Using a graphing method, Scrollmapper illustrates complex relationships between many books, whether canonical or extracanonical. These relationships can then be saved as basic cross-references to be shared among users, databases, or analyzed in [Gephi](https://gephi.org/).

### Book Importing, Reading, and Research

Scrollmapper imports books directly from the main Scrollmapper databases on GitHub:

- https://github.com/scrollmapper/bible_databases
- https://github.com/scrollmapper/bible_databases_deuterocanonical

Scrollmapper includes a basic reader so that you can read any of the biblical or lost books you wish. It also contains a well-established cross-referencing database from [openbible.info](https://www.openbible.info/labs/cross-references/), which allows for some fairly depthy connections research out of the box.

### Meta Editing

Metadata can be attached to individual verses. This can be applied on exports to [Gephi](https://gephi.org/) to later isolate unique data that you previously set for node/edge network analysis.

## Getting Started

![Introduction](documentation/images/intro.png)

On the main intro screen, hover your mouse over the various elements in the picture. The light will shine on whatever you focus on. A little scroll with a label will show what feature it is. Clicking on the item focused will bring up its work area.

> **Note** The main features are working, but a few items may seem incomplete -- this is because they are prepared for features being added later.

### VX Editor

"VX" is a cute way of saying Cross-verse. It is our cross-reference graphing and export system that we have created. Simply click on the main bulletin board to use the VX-System. The workflow is simple: Search verses, and add them to the graph. Move them around and connect them according to your wishes. Eventually, you will produce a graph of connected scriptures that should relate to each other.

### Book Downloader

![Book Library](documentation/images/book-library.png)

The Book Downloader allows you to download various books directly into the Scrollmapper system. Generally, Scrollmapper comes with all of the extra-biblical books installed. But who knows -- you might not want the Testament of Solomon! In that case, just uncheck it and press "Synchronize Library", and it will be removed from the database.

![Synchronize Library](documentation/images/syncronize.png)

Books can be installed and uninstalled one or many at a time. The **Update Book List** button will refresh the main book list from the Scrollmapper repository (https://github.com/scrollmapper/book_list). Occasionally, new books are added to the collection, and this will update your local book list. *(Note: Due to a small bug, you will need to exit this screen and return to see the update.)*

### Reader

![Reader](documentation/images/reader-1.png)

The reader allows you to read the books in-app. This is useful because there are quite a few extra-biblical books that you may wish to review. When reading the main canonical books, you will also be able to see cross-references to the scriptures by double-clicking verses in the reader. If you save cross-references to the database from the VX-Editor, they should show up here as well.

![Reader 2](documentation/images/reader-2.png)

## Advanced Use: Gephi Integration

Scrollmapper can export thousands of cross-references to [Gephi](https://gephi.org/) for deep analysis of scripture relationships. This feature helps visualize and explore connections between verses and books, providing valuable insights.

Scrollmapper comes pre-populated with 340,000 cross-references from [openbible.info](https://www.openbible.info/labs/cross-references/), allowing immediate exploration and analysis without additional data entry.

> **Note:** [Gephi](https://gephi.org/) is the leading visualization and exploration software for all kinds of graphs and networks. Gephi is open-source and free.

![Ezekiel Scrollmap](documentation/images/ezekiel.png)

## Why a Game Engine?

Scrollmapper is built using the game engine [Godot](https://godotengine.org/), which enables it to feature visually appealing graphical interactions. The graphical abilities of Godot allow us to implement features that are visual and graphical in nature, making it an ideal choice for this project.

## Contributing

Efforts have been made to document existing code, however, an overhaul is likely to be made when Scrollmapper has developed and discovered its purposes. We welcome contributions from the community. Please refer to our [contributing guidelines](CONTRIBUTING.md) for more information.

## License

Scrollmapper is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.