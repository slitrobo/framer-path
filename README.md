![](http://vladimirshlygin.com/assorted/p/pmoduleheader.jpg)

Create custom svg shapes and animate each point individually in Framer JS.

Can be useful for:

- Creating arrays of points with quick math expressions
- Animated graphs & statistics
- Simple animated icons
- Fluid shapes

How to install:

1.  Download the 'Path.coffee' file to your project /modules/ folder
2.  Copy this line of code to the framer studio:

```
{Path} = require "Path"
```

## New layer

```

p = new Path

    strokeWidth: 1

    pointVisible: true
    handleVisible: true

    pointSize: 6
    handleSize: 2

    fill: "#e8e9ff"
    pointColor: "blue"
    handleColor: "blue"
    strokeColor: "blue"

```

*Path* class is an extended layer class, so you can use most of the layer properties, as well as events with it.

```

p = new Path

     width: 300
     height: 300

     backgroundColor: "red"

p.center()

```

## New points

Currently, this module supports only straight, quadratic and cubic bezier points.

```

p.path.point x: 30, y: 30
p.path.point x: 130, y: 30

```
Quadratic bezier is a curve with only one handle:

```

p.path.point x: 30, y: 30

p.path.quadratic
    x: 60, y: 60
    qx: 120, qy: 60

```

Cubic bezier has two handles:

```

p.path.point x: 30, y: 30

p.path.cubic
    x: 30, y: 60
    cx1: 120, cy1: 30
    cx2: 120, cy2: 60

```

If you want to use straight points after bezier, you need to use special closing point:

```

p.path.point x: 30, y: 30

p.path.quadratic
    x: 60, y: 60
    qx: 120, qy: 60

p.path.close x: 180, y: 60

```

## Animation

To animate a value, add states to the point you want to animate and then run the animation with *path.animate()* function.

```
p.path.point x: 30, y: 30
p.path.point
     x: 130, y: 30
     states:
          x: 160, y: 60

p.path.animate()

```

You can add unlimited amount of states by using array instead of integer. The array lengths of x and y should always be equal.

```

p.path.point x: 30, y: 30
p.path.point
     x: 130, y: 30
     states:
          x: [160, 180, 200]
          y: [60, 80, 100]

p.path.animate()

```

There are two different modes of animating the points, *’animation’* and *’states’*. The default value is set as *’states’*.
As position of the point is based on position of the point layer (even when it’s not visible), *’animation’* mode allows you to play different tricks such as updating the value of point on the go:

```

rdm = -> return Utils.randomNumber(30, 80)

p.path.point x: 30, y: 30
p.path.point
     x: 130, y: 30
     states:
          x: -> rdm()
          y: -> rdm()

Utils.interval 0.75, -> p.path.animate("animation")

```

Note that *’animation’* mode won’t work with states arrays.

You can add animation options in a traditional way:

```

p.path.animationOptions =
     time: 0.75
     curve: “spring"

```

## Be aware that
- Any kind of path should always start with simple point.
- *path.animationOptions* should be assigned before you create any points
- The path module alters uses the *layer.html* value, that’s how animation happens, so if you want to change *layer.html*, it’s better create new parent layer

## Examples

**Animated graph**

![](http://vladimirshlygin.com/assorted/p/pgraphsn.gif)

http://share.framerjs.com/w27sxwwsn1rw/

**Blend shapes**

![](http://vladimirshlygin.com/assorted/p/pblendshapesn.gif)

http://share.framerjs.com/j6977iinxa65/

**Drawing tool**

![](http://vladimirshlygin.com/assorted/p/pdrawingn.gif)

http://share.framerjs.com/2kfa8aoiw2jo/
