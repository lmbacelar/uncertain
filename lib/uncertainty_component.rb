class UncertaintyComponent
  
  attr_accessor :desc, :qty, :x, :ux, :dist, :typ, :c, :v

  def initialize(args = nil)
    if args
      args.each { |k,v| instance_variable_set("@#{k}", v) unless v.nil? }
    end
  end
end
