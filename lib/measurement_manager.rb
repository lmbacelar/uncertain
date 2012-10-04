class MeasurementManager
  def self.uy(data)
    Math.sqrt(data.map{ |d| (d.c*d.ux)**2 }.inject(:+))
  end

  def self.vef(data)
    (self.uy(data)**4/(data.map{ |d| (d.c*d.ux)**4/d.v }.inject(:+)))
  end

  def self.k(data)
    self.inverse_t_95(self.vef(data))
  end

  def self.uexp(data)
    self.k(data) * self.uy(data)
  end

private
  def self.inverse_t_95(v)
    # Determines k factor for an inverse Student's t distribution, with 95.45% coverage factor
    #
    # TODO: Link this to statistics package (CRAN-R + RSERVE ?) to generalize this

    return 2 if v == Float::INFINITY

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
