class MeasurementManager
  def self.uy(data)
    Math.sqrt(data.map{ |d| (d.c*d.ux)**2 }.inject(:+))
  end

  def self.vef(data)
    (uy(data)**4/(data.map{ |d| (d.c*d.ux)**4/d.v }.inject(:+)))
  end

  def self.k(data)
    if (u = dominant(data))
      divisor_for(u.dist) * 0.95
    elsif (a = two_rect_dominants(data))
      beta = ((a[0].c * a[0].ux)-(a[1].c * a[1].ux)).abs/((a[0].c * a[0].ux) + (a[1].c * a[1].ux))
      (1-Math.sqrt((1-0.95)*(1-beta**2)))/Math.sqrt((1+beta**2)/6)
    else
      inverse_t_95(vef(data))
    end
  end

  def self.uexp(data)
    k(data) * uy(data)
  end

private
  def self.dominant(data)
    # Sums squares of all cx.ux but ci.ui, then computes sqrt.
    # Checks if ratio of this to sqrt(ci.ui)² is smaller than 0.35.
    # Return u if this holds, nil otherwise.
    # NOTE: EA-4/02 defines this condition do be less than or equal to 0.3
    #       This number is defined with one significant figure.
    #       This makes the condition equal to less than 0.35, which will be
    #       rounded down to 0.3.
    #       This is according results of example S11, which would not hold
    #       otherwise.
    #
    # TODO: Change return value from nil to something else
    data.each do |u|
      u1 = (u.c*u.ux)**2
      ur = data.map{ |ui| (ui.c*ui.ux)**2 }.inject(:+) - u1
      return u if Math.sqrt(ur)/Math.sqrt(u1) < 0.35
    end
    nil
  end

  def self.two_rect_dominants(data)
    # If the two largest are rectangular and combination is dominant
    # return them. Nil otherwise.
    #
    # TODO: Change return value from nil to something else
    # TODO: Appears to run twice on each iteration. Find out why.
    #
    # Get the index of the two largest c*ux. a[0] and a[1]
    a = data.each_with_index.map{ |d, i| [d.c * d.ux, i] }.sort[-2,2].map{ |i| i[1] }
    if data[a[0]].dist == 'R' && data[a[1]].dist == 'R'
      u0 = a.map{ |i| (data[i].c*data[i].ux)**2 }.inject(:+)
      ur = data.map{ |ui| (ui.c*ui.ux)**2 }.inject(:+) - u0
      if Math.sqrt(ur)/Math.sqrt(u0) < 0.35
        [data[a[0]], data[a[1]]]
      end
    end 
  end

  def self.divisor_for(distribution)
    case distribution
    when 'R' then Math.sqrt(3)
    when 'T' then Math.sqrt(6)
    when 'U' then Math.sqrt(2)
    when 'N' then 2
    when 'S' then 'XPTO'
      # TODO: Return k (provided as parameter) or compute it from v, when dominant is 'S' type (student's-T distribution)
    end
  end

  def self.inverse_t_95(v)
    # Determines k factor for an inverse Student's t distribution, with 95.45% coverage factor
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
