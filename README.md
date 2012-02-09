# Cognitive Distance

[![Build Status](https://secure.travis-ci.org/iande/cognitive_distance.png)](http://travis-ci.org/iande/cognitive_distance)

## Installing

The way you install every other gem,

    gem install cognitive_distance

but we're at a pre-alpha stage here, so you'd have to specify `--pre`, and
you really shouldn't bother.

## Usage

### Measure the number of modules "hopped" by a method call

    class Mine
      def my_method
        Yours.new.your_method
      end
    end

    class Yours
      def initialize
      end

      def your_method
      end
    end

    CognitiveDistance.measure_module_hops Mine.new, :my_method
    # => 2
    CognitiveDistance.measure_distinct_module_hopes Mine.new, :my_method
    # => 1

The module hops are:

1. Initializing the newly instantiated `Yours` object (`Yours#initialize`)
2. Calling `your_method` on the new instance

There is only 1 distinct module hop because `my_method => Yours#initialize`
and `my_method => Yours#your_method` cross the same boundary.

At this time, only Ruby code is traced, so if `Yours` did not define an
`initialize` method, both hop counts would be 1.

*Brief Aside*: tracing `c-call` events changes nothing in this case, as no
instance methods of the `Yours` instance are invoked until `#your_method` is
called.

## License

Let's go with Apache 2.0, I've been using it pretty frequently.

