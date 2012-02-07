module CognitiveDistance
  # Stupid simple class to ensure that when we use object identity
  # comparisons, we always get false with this.
  class MissingCallContext
    def equal? anything
      false
    end
  end
end

