# Cognitive Distance

## Use Case

  module MyThought
    def ready?
      configured? && connected?
    end
  end

  class MyThing
    include MyThought

    def initialize config=true, connect=false
      @configured = config
      @connected = connect
    end

    def connected?; @configured; end
    def configured?; @connected; end
  end

  class MyThang
    def initialize
      @thing = MyThing.new
    end

    def ready?; thing.ready?; end

    def thing; @thing; end
  end

  CognitiveDistance.start(MyThang.new) do
    measure :ready?    # => 2 line hops, 1 object hop, 6 line hops, 7 line hops
  end

## License

Let's go with Apache 2.0, I've been using it pretty frequently.

