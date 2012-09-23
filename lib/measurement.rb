class Measurement
  
  attr_accessor :uy, :vef, :k, :uexp, :components

  def initialize args = nil
    if args
      args.each { |k,v| instance_variable_set("@#{k}", v) unless v.nil? }
    end
  end

  def compute
    Marshal.load(Marshal.dump(self)).compute!
  end

  def compute!
    self.uy = Math.sqrt(components.map{ |c| (c.c*c.ux)**2 }.inject(:+))
    self.vef = (self.uy**4/(components.map{ |c| c.ux**4/c.v }.inject(:+))).to_i
    self.k = Measurement.k_factor(self.vef)
    self.uexp = self.k * self.uy
    self
  end

private
  def self.k_factor(v)
    # Determines k factor for an inverse Student's t distribution, with 95.45% coverage factor
    #
    # TODO: Link this to statistics package (CRAN-R + RSERVE ?) to generalize this
    case v.to_i
    when 1 then 13.97
    when 2 then 4.53
    when 3 then 3.31
    when 4 then 2.87
    when 5 then 2.65
    when 6 then 2.52
    when 7 then 2.43
    when 8 then 2.37
    when 9 then 2.32
    when 10 then 2.28
    when 11 then 2.25
    when 12 then 2.23
    when 13 then 2.21
    when 14 then 2.20
    when 15 then 2.18
    when 16 then 2.17
    when 17 then 2.16
    when 18 then 2.15
    when 19 then 2.14
    when 20..21 then 2.13
    when 22 then 2.12
    when 23..25 then 2.11
    when 26..27 then 2.10
    when 28..30 then 2.09
    when 31..34 then 2.08
    when 35..39 then 2.07
    when 40..46 then 2.06
    when 47..56 then 2.05
    when 57..72 then 2.04
    when 73..101 then 2.03
    when 102..167 then 2.02
    when 168..501 then 2.01
    when 501..Float::INFINITY then 2.00
    else
      # TODO: raise exception
      nil
    end
  end
end
