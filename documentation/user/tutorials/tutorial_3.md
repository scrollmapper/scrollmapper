# Scrollmapper - Tutorial 3: Using Scrollmapper's Meta with Gephi's Attributes

## Scrollmapper Verse Meta - Basics 

In [Tutorial 1](tutorial_1.md), we discussed the basics of Scrollmapper. In [Tutorial 2](tutorial_2.md), we learned about Scrollmapper's integration with Gephi and some basics of using Gephi.

Here, we will discuss how to create verse meta in Scrollmapper, which can be exported and recognized as attributes in Gephi. Additionally, we will learn how to create these attributes directly in Gephi.

> **NOTE** Scrollmapper's meta feature works with Gephi but is also intended for future developments, such as user notes, highlighting, other software exports, etc.

## Creating Verse Meta in Scrollmapper

Verse meta in Scrollmapper allows you to add custom attributes to verses, which can be very useful for filtering and analyzing data in Gephi.

There are **3** methods to edit **Verse Meta** in Scrollmapper:

- **Main Meta Editor**: This is for mass-editing verse, book, and translation meta. *Only verse meta works at this time*. Book and translation meta are for future development.
- **VX Editor - Node Info View**: When you double-click a node, a node info window will appear. You can edit its meta here directly.
- **VX Editor - Meta Screen**: For editing verse meta on the active graph itself.

In short:

- Use the **Main Meta Editor** for mass-edits of verse meta outside of the VX Editor.
- Use the **VX Editor - Node Info View** for single-verse edits relevant to the node layout, and **VX Editor - Meta Screen** for multiple-verse edits relevant to the node layout.

### **Main Meta Editor**

![Meta Editor Entry Point](../../images/t3-meta-edit-1-a.png)

![Meta Editor](../../images/t3-meta-edit-1-b.png)

### **VX Editor - Node Info View**

![Meta Editing, Node Double-Click](../../images/t3-meta-edit-2-a.png)

![Meta Editing, Node Info](../../images/t3-meta-edit-2-b.png)

### **VX Editor - Meta Screen** 

![VX Editor, Meta Edit Button](../../images/t3-meta-edit-3-a.png)

![VX Editor, Meta Editor Button](../../images/t3-meta-edit-3-b.png)

## Why Use Verse Meta?

Primarily, **verse meta** was implemented for creating Gephi Attributes ahead of time. This is its main use now. An example would be isolating a theme in a certain scripture thread you are researching, and then tagging that theme with relevant meta. 

Upon exporting to Gephi, you are given the option to include this meta. 

Secondarily, it was added as an anticipatory measure for the future of Scrollmapper.

### Use Cases for Verse Meta 

Examples: 
- In researching the [Great Harlot](https://en.wikipedia.org/wiki/Whore_of_Babylon), you may wish to tag all relevant verses with the `Meta Key` **great-whore** and the `Meta Value` **<Specific Nuance>**.
- In researching roles and occurances of bible characters, you may create `Meta Key` **character** with `Meta Value` **<Character Name>**.
- And with increased experience/knowledge in Gephi, you will likely find even more ways to use Verse Meta as you design networks ahead of time in Scrollmapper. 


 