# Scrollmapper - Tutorial 2: Using Scrollmapper with Gephi

Integrating Scrollmapper with [Gephi](https://gephi.org/) opens up powerful possibilities for analyzing biblical texts. Scrollmapper includes 340,000 cross-references from [openbible.info](https://www.openbible.info/labs/cross-references/), providing a rich dataset for big-data analysis.

## Gephi Integration

With Scrollmapper's extensive dataset, you can leverage Gephi's advanced graph analysis tools to uncover intricate relationships within the scriptures.

![Gephi Graph 1](../../images/gephi-graph-1.png)

![Gephi Graph 2](../../images/gephi-graph-2.png)

For those familiar with Gephi, the potential is vast. You can visualize and analyze the connections between different parts of the Bible, identify central themes, and explore the structure of biblical narratives. Gephi's capabilities allow for in-depth exploration of canonical scriptures, revealing patterns and insights that might not be immediately apparent through traditional study methods.

## Scrollmapper -> Gephi Basics

Scrollmapper exports to Gephi using the **[.gexf](https://gexf.net/)** format. Opening the .gexf file will reveal an entire network of connected verses ready for Gephi editing and analysis.

Using the simple example from [Tutorial 1](tutorial_1.md), let us export a basic graph to Gephi.

Here it is in Scrollmapper:

![From Scrollmapper, Prepared for Gephi:](../../images/enoch-job-wisdom-connection.png)

By choosing `Export -> Export Graph to Gephi`, and importing it into Gephi, you get this:

![Exported Scrollmapper Graph in Gephi](../../images/job-enoch-gephi.png)

This small graph provides you with quite a bit of information:

![Gephi Data Laboratory](../../images/gephi-scrollmapper-data-laboratory.png)

Here are the default attributes that are available for every node in Gephi:

- Id
- Label
- scripture_text
- scripture_location
- translation
- book
- chapter
- verse

If you export from Scrollmapper with custom attributes (using Scrollmapper's verse meta feature), you can have even more attributes to filter/work with in Gephi.

For example, by having the verse text available, you can search all nodes according to the text the scriptures contain:

![Verse Search](../../images/verse-search-gephi.png)

This might not seem like much, but with a dataset of thousands of connected verses, Gephi becomes very useful for analyzing data.

Here is a quick-generated graph of the *minor prophets* and their relationships to each other:

![Minor prophets, Gephi Graph](../../images/gephi-render-2.png)

> **NOTE** Organizing and isolating node groups is a huge focus in Gephi. However, in this case, we've run some auto-layouts for a quick result.

And the corresponding data laboratory:

![Minor Prophets, Gephi Data Lab](../../images/gephi-data-lab-minor-prophets.png)

You can see that Gephi editing and analysis adds many new metrics to study the data on. This is a specialized subject that can go as deep as you want it to.

So let's give a small tutorial on how to productively analyze scripture data exported from Scrollmapper.

## A Basic Scrollmapper to Gephi Project

Let's not start small. To quote Tony Stark from Iron Man:

![Sometimes you gotta run before you can walk](../../images/start-big.jpg)

> "Sometimes you gotta run before you can walk."

To get a sense of working with data in Gephi, let us first export ALL of the default cross-references logged in Scrollmapper.

We will be performing these steps:

- Export cross-references as a graph/network from Scrollmapper.
- Import the cross-references graph into Gephi.
- Clean up the graph for easy viewing and analysis.

### Export Cross References from Scrollmapper

![Export Cross References from Gephi](../../images/t2-export.png)

To export the cross-references, simply choose the `Export Cross References Database to Gephi` option under `Export`.

Save it to your desktop, or wherever you wish. You will notice some options for Meta items to attach. Ignore this for now.

The default filename will be `cross-references-graph.gexf`. You may change it if you wish.

Depending on your computer, this could take a few minutes. It is taking 340,000 cross-references and building a `.gexf` `xml` document from them.

### Import Cross References to Gephi

If you have already [installed Gephi](https://gephi.org/), simply double-clicking the exported file should open it in Gephi. If not, then open Gephi and **Open** the `.gexf` file you created.

> **NOTE** Importing it is not the method here. **Open** is the valid workflow here.

![Open .gexf, not Import](../../images/t2-open-gexf.png)

Now you should see something like this:

![Importing Scrollmapper nodes/edges to Gephi.](../../images/t2-import-gephi.png)

The numbers may be different if you've already saved some of your own Scrollmapper node networks to the cross-reference database.

Push **Ok** and the graph should populate.

![Newly imported nodes/edges from Scrollmapper.](../../images/t2-newly-imported.png)

What you are now seeing is a square of densely packed nodes and connections, or as they are called in Gephi, **nodes** and **edges**.

Let's take a moment to see the data laboratory -- the table of nodes and connections...

Push the **"Data Laboratory"** button, which is beside the **"Overview"** button. It is under **File**, **Workspace**, etc...

![Gephi Data Laboratory from Scrollmapper](../../images/t2-data-laboratory.png)

This is the starting tables that were imported from the `.gexf` file Scrollmapper generated.

Notice there is a **Nodes** and **Edges** table. As you work with the data, you will be using these tables a lot.

Now go back to the **Overview** tab so we can make the graph more visually sensible and easy to work with.

![Layout options, Gephi](../../images/t2-layout-options.png)

#### Node Coloring and Distribution...

Because of the huge amount of data, we need to distribute the nodes in a way that is efficient.

We can use the `ForceAtlas 2` layout algorithm to achieve this.

The end result will look something like this:

![Force Atlas 2](../../images/t2-force-atlas-2.png)

Notice larger nodes are clustered together, and the colors are somewhat separated.

**Remember:**

- Books are assigned unique colors.
- Node sizes are based on the number of connections to other verses.

So in this layout, we have visual cues on how various scriptures relate to each other between books. While there are *many* ways to explore and visualize graphs, we are using this as an introduction because it is simple and fast.

Here is a zoomed-in preview of what we are about to do:

![Force Atlas 2 Preview](../../images/t2-force-atlas-2-preview.png)

First, let us color-coordinate the nodes according to which bible book they are in.

In the upper right panel, **Appearance**, choose `Nodes`, `partition`, and select `Book` from the dropdown.

![Nodes - Partition - by Book](../../images/t2-nodes-partition-book.png)

The default option will color a lot of the books gray. We have to create a palette. Click the `Palette..` option.

![Choose Palette](../../images/t2-choose-pallete.png)

When the menu comes up:

- Uncheck `Limit number of colors`
- `Presets` dropdown should remain default. (Or choose a palette you like)
- Press `Generate`
- Verify the colors. Check that they do not desaturate to gray.
- Press `Ok`

The window closes. Back on the **Appearance** panel press `Apply`

The node cluster should now look like this:

![Colored book nodes.](../../images/t2-colored-books.png)

Now we will resize the nodes according to how many verses they connect to in cross-referencing.

![Node size by Degree](../../images/t2-node-size-by-degree.png)

Study the above picture. Choose: `Nodes -> Size -> Ranking` panel.

- Choose `Degree` as the *attribute*. (This is the number of connections a node has)
- For `Min Size` and `Max Size` enter the values **5** (min) and **50** (max).
- Press `Apply`

Now the size of the nodes represents their importance in terms of cross-references.

You should now be seeing something like this:

![Nodes resized.](../../images/t2-resized-nodes.png)

Now we will apply the `ForceAtlas 2` algorithm...

![Force Atlas 2 Values](../../images/t2-force-atlas-values.png)

We will be working in two steps:

1. Spatialize the graph.
2. Prevent node overlaps.

So for **step 1** change the following values:

- Ensure `Approximate Repulsion` is **checked**.
- Scaling: 100
- Gravity: 7

Press `Run` (It is just above the values you just set)

The graph will widen out very quickly. Use the mouse wheel to zoom out. Let it continue running until it seems nicely distributed. Then press `Stop`.

It should now look something like this:

![Force Atlas 2 Distributed](../../images/t2-force-atlas-2-distributed.png)

Yours will be a bit different, but should still have a similar general appearance.

If you zoom in, you can see that the nodes overlap and are a bit jumbled:

![Jumbled Nodes](../../images/t2-jumbled-nodes.png)

We will fix this by running this same algorithm again, but with a few settings changed:

- Uncheck `Approximate Repulsion` (Important)
- Scroll down to `Behavior Alternatives` and check `Prevent Overlap`
- Press `Run` again...

And wait a while for the adjustments to occur. I find that zooming out runs the algorithm faster.

See the difference:

![No overlap](../../images/t2-nodes-no-overlap.png)

Zooming out, we see the entire graph is much clearer and organized.

![Nodes Comparison](../../images/t2-node-comparison.png)

In the above left-right comparison, the nodes on the left are dimmed (white) and the nodes on the right are colored (normal). When you hover over a given node, all other nodes **except** the **one you are hovering, and its connected neighbors**, will dim. This allows you to focus over and see connection relationships with your mouse.

In the left image, you can see that one small node with some dark lines radiating from it to other nodes. That is the one I hovered before the screenshot.

**Next** we will show the **Labels** over the nodes (This setting can be toggled **off** and **on**).

![Text Values](../../images/t2-text-values.png)

See the screenshot above. Note the changes made in the red boxes.

Select the `Nodes -> Label Size -> Ranking` panel as shown by the red boxes in the screenshot.

- In the **dropdown** choose `Degree`.
- **Min** and **Max** values should be **.1** and **1.2** for this graph.

> **NOTE** See the **T** icon below the graph. Labels can be easily toggled Off and On.

Now if you zoom in and hover over nodes, you can isolate them and their connections for easy studying...

![Focusing labels and connections](../../images/t2-focused-labels.png)

This was a simple tutorial on your first large graph.

This only scratches the surface of how Gephi is used. There are lots of methods for isolating data and patterns using Gephi -- this tutorial was enough to show you the most basic features.

Here are some more beginner tutorials on Gephi networks: https://www.youtube.com/playlist?list=PLk_jmmkw5S2


### An Alternative Method

The `Yifan Hu` layout is a force-directed layout algorithm designed to visualize large-scale graphs efficiently. It works by simulating physical forces between nodes, where Nodes repel each other while Edges act as springs pulling connected nodes together. This will ultimately give us a visually appealing, easy-to-understand graph layout.

![Yifan Hu Layout Option](https://github.com/user-attachments/assets/e0681fd4-a3a4-47f6-9d8c-1043aabbeeb4)

> **NOTE** There is also another type of `Yifan Hu` layout called `Proportional Yifan Hu` (pictured in the image above). This one adjusts the repulsion force based on the `degree` of the nodes.

Select the `Yifan Hu` option in the Layout panel, but don't run it just yet. First, we need to adjust a few of the properties, namely the `Optimal Distance` and `Relative Strength` parameters.

The `Optimal Distance` property dictates the preferred distance between nodes in your graph. Adjusting this property can help in creating a more readable and well-distributed layout for this graph with less overlapping nodes. Something between 300 and 500 is good for this case.

> **NOTE:** Higher values place nodes further apart, while lower values bring them closer together. The latter is good for small, sparse graphs, or when trying to highlight relationships. However, in our case, the graph is very large and will look messy with so many nodes bunched together.

Next is `Relative Strength`. This adjusts the strength of the attractive (Edges) and repulsive forces between nodes. Higher values increase the influence of *attractive forces* (Edges), pulling connected nodes together. Lower values increase the influence of *repulsive forces*, pushing nodes away from one another.

In this case, we have found that a value between 4.0 and 7.0 for this parameter works well, though the latter is likely to push nodes to the borders. This is not exactly bad, as those nodes will most likely be the nodes with the least connections.

When you finish running the layout, you should end up with something like this:

![Yifan Hu Result](https://github.com/user-attachments/assets/9634ec72-a551-45fe-bea0-9e827783b1a8)

The layout has pushed nodes away from each other while simultaneously keeping related nodes close to each other. This ensures that nodes with the least amount of connections have been placed on the outer part of the graph, with the others closer to the middle. (You can tell because the nodes with a greater number of connections are larger than the rest and are concentrated *mostly* in the middle.)

### Wrapping It Up

If you got this far, congratulations! You took a giant black box of messy nodes just a few steps short of resembling abstract artist Jackson Pollock's "Autumn Rhythm #30" and weaved it into an easier-to-read, colorful graph more suitable for displaying relationships in God's words. If you're happy with your graph, navigate over to the `Preview` tab so we can prepare the graph for Export.

![Preview Tab](https://github.com/user-attachments/assets/ab733ebd-b3b1-49bd-ac9b-94356286b5b9)

#### Rescale Weight

> **NOTE:** Have you saved your graph? Press Ctrl + S to save. If you have not saved it previously, you will need to select a location to save it to on your computer.

You will be greeted by a bit of information on the left under `Preview Settings`, and a large `Preview Panel` on the right, which is currently empty. At the bottom right of the `Preview Settings` panel, click the `Refresh` button and wait for the graph to load into the `Preview` panel.

![Refresh Preview Button](https://github.com/user-attachments/assets/c286b52a-90af-4951-a8f7-3feeca80a18c)

You should now be able to see a *preview* of your graph, which will look something like this:

![Graph Preview](https://github.com/user-attachments/assets/92843019-69ce-4b7a-bcbb-3bef3e31ede6)

As you can see, it's not very appealing to look at for a few different reasons. Let's fix that. First, we'll resize the edges (the lines connecting the nodes). In the `Preview Settings` tab, scroll down to the Edges dropdown and turn `Rescale Weight` on by clicking the box.

![Rescale Weight](https://github.com/user-attachments/assets/8900e494-266d-4398-91a6-fcd29c6fe71e)

Now click the Refresh button at the bottom of the `Preview Panel` again.

![Graph Preview Rescale Weight](https://github.com/user-attachments/assets/c958123d-b097-481f-a1fe-c5d0bf5b7276)

##### Bonus

What did checking that box do?

Checking this box has rescaled the edges according to their 'Weight'. Remember the Data Laboratory?

![Data Laboratory](https://github.com/user-attachments/assets/cb7c9390-a2ab-491d-8188-f9dd052b94a2)

In the `Data Table` panel, click the Edges tab to swap from the Node list to the Edges list.

![Edges Table](https://github.com/user-attachments/assets/13d2c4e1-b73e-47fd-931b-8098822f8f41)

Now there's a lot of numbers here, but right now the only ones you need to focus on are at the far right under the `Weight` column. If you click on 'Weight', it will toggle between sorting the edges from those with the highest weight to the lowest, and vice versa. Here, the highest weight is 1268.0.

![Weight Column](https://github.com/user-attachments/assets/7f1285d7-7fe0-4123-9881-d7e26ec37342)

When we ticked the 'Rescale Weights' box, we visually rescaled all of the edges according to their weight. The higher the weight, the thicker the line. This makes it easier to identify stronger and/or more significant connections in our graph. Had we kept this box unchecked, all of the edges would have been one size. Now let's go back to the `Preview` tab so we can continue.

#### Rescaling Edges

Our graph looks a bit better now, but let's make the edges a bit more noticeable.

As you can see, the edges are a bit dim at the moment, which is better than how it was before, but not quite what we want. We can change this a few different ways. You can either tweak the overall `Thickness`, which will scale the edges relative to their weights, or you can change the `Min/Max Rescaled Weight` parameters. Let's do the former.

Leave the `Min Rescaled Weight` parameter as is, but set the `Max Rescaled Weight` parameter to 3.0. Set the `Thickness` value to 100 and click `Refresh`.

![Thickness Value/Graph Preview](https://github.com/user-attachments/assets/90d48426-20ea-4061-ba9e-d6da56004a86)

### Bonus

This essentially means that edges will vary in thickness between the `Min Rescaled Weight` and `Max Rescaled Weight` based on the `Thickness` value. Let me explain:

For this situation, we have the `Min/Max Rescaled Weight` values set to 0.1 and 3.0 respectively. This means edge thickness will vary between 10 and 300. If the `Max Rescaled Weight` was set to 2.5, thicknesses would now vary between 10 and 250. If our thickness was 200, edge thicknesses would now vary between 20 and 500 - twice that of before.

Here is the basic formula:

*M = Min. Scaled Value*

*W = Max. Scaled Value*

*T = Thickness*

*mV = Minimum Value*

*wV = Maximum Value*


*M x T = mV*                                    *0.1 x 200 = 20*
                  Or, in the previous case:
*W x T = wV*                                    *2.5 x 200 = 500*


Thus, edge thicknesses - if we follow this formula - will vary between 20 and 500 based on the edge weights. But in this case, our thickness will vary between 10 and 300, as our `Min/Max Rescaled Weight` values are set to 0.1 and 3.0.

#### Edge Arrows: Optional

This will only be visible if you zoom in on the graph, but to keep it uncluttered, move one tab down and look at `Edge Arrows`. Set this value to 0.5.

![Edge Arrows](https://github.com/user-attachments/assets/f64b3ae7-02f2-4c32-be04-577135bb16a4)

#### Node Labels

Finally, let's add some labels onto our nodes. We briefly covered them earlier within the Overview tab, but they work a bit differently here. Scroll up to the `Node Labels` tab and click the 'Show Labels' checkbox to turn them on, then click "Refresh" again.

![Show Labels](https://github.com/user-attachments/assets/df54b0c2-86de-474f-8c1b-61601f286518)

Your graph should be populated with labels now. By default, the labels will show the book and verse a node refers to. For example, Romans 8:31. You won't be able to rescale the nodes from the Preview tab. This is done within the Overview, so let's swap back there and rescale these labels. Make sure to turn them on using the bottom toolbar once you get to the Overview tab.

Navigate to the `Appearance` panel and select `Label Size` as the desired tab. It's the button with the two T's at the far right. Then switch from the tab labeled `Unique` to the one labeled `Ranking`. Set the `Attribute` to Degree, and tweak the values as you wish. Here I chose a Min/Max of 0.5 and 1.2 respectively.

![Label Size](https://github.com/user-attachments/assets/0715d8aa-7775-4d3d-9504-0ccbba9e6b32)

Once you have done this, hit apply, head back to the `Preview` tab and click "Refresh" once more.

![Labels Preview](https://github.com/user-attachments/assets/96cc2ee0-8658-450c-8c78-2c9f17bb3095)

You should see that your labels have rescaled. They look small from far away, so zoom in to get a better look. You can see that the biggest labels belong to the biggest nodes. Or, more specifically, the nodes with the highest degree. Or, even more specifically, the nodes with the most in/out connections.

#### Exporting Your Graph

Congratulations! You've made your first cross-reference database in Gephi. In the bottom left corner of the Preview Settings panel, you'll see a `Preview Ratio` slider and an `Export` button.

![Export and Preview Ratio](https://github.com/user-attachments/assets/8eaa2ffb-28cb-4c04-b50f-d28809bc73fe)

The `Preview Ratio` slider will decrease the number of nodes shown in the preview graph the lower you go. We don't really want that, so leave it as is and click `Export: SVG/PDF/PNG`. From there, all you need to do is select the file location you want to export it to, the file extension (SVG/PDF/PNG), and export it.

