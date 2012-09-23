module EaUncertaintyExamples
  module ClassMethods
    def load_examples
      # S2 CALBRATION OF A WEIGHT OF NOMINAL VALUE 10 KG
      # Simple example
      # NOTE: k, uexp of this example have been corrected, as EA/4-02 assumes k=2, which does not hold when checking
      #       using Welsh-Satterthwaite
      let(:s2) do
        Measurement.new(uy: 2.93e-2, k: 2.08, uexp: 6.1e-2, components: [
          stub(ux: 2.25e-2, c: 1, v: Float::INFINITY), 
          stub(ux: 8.95e-3, c: 1, v: Float::INFINITY), 
          stub(ux: 1.44e-2, c: 1, v: 2), 
          stub(ux: 5.77e-3, c: 1, v: Float::INFINITY), 
          stub(ux: 5.77e-3, c: 1, v: Float::INFINITY) 
        ])
      end

      # S3 CALIBRATION OF NOMINAL 10 kOHM STANDARD RESISTOR
      # Some sensitivity Coefficients differ from 1
      let(:s3) do
        Measurement.new(uy: 8.33e-3, k: 2.00, uexp: 1.7e-2, components: [
          stub(ux: 2.50e-3, c: 1,   v: Float::INFINITY), 
          stub(ux: 5.80e-3, c: 1,   v: Float::INFINITY), 
          stub(ux: 1.60e-3, c: 1,   v: Float::INFINITY), 
          stub(ux: 3.20e-3, c: 1,   v: Float::INFINITY), 
          stub(ux: 4.10e-7, c: 1e4, v: Float::INFINITY), 
          stub(ux: 7.00e-8, c: 1e4, v: 4) 
        ])
      end

      # S4 CALIBRATION OF A GAUGE BLOCK OF NOMINAL LENGTH 50 MM
      # Special type distribution
      let(:s4) do
        Measurement.new(uy: 3.64e-8, k: 2.00, uexp: 7.3e-8, components: [
          stub(ux: 1.50e-8, c: 1,        v: Float::INFINITY), 
          stub(ux: 1.73e-8, c: 1,        v: Float::INFINITY), 
          stub(ux: 5.37e-9, c: 1,        v: 4), 
          stub(ux: 1.85e-8, c: 1,        v: Float::INFINITY), 
          stub(ux: 2.89e-2, c: -5.75e-7, v: Float::INFINITY), 
          stub(ux: 2.36e-7, c: 5.00e-2,  v: Float::INFINITY), 
          stub(ux: 3.87e-9, c: -1,       v: Float::INFINITY) 
        ])
      end

      # S12.14 CALIBRATION OF A HOUSEHOLD WATER METER
      # Normality of uy not verified. k calculated through Welch-Satterthwaite and Inverse t-student distribution
      let(:s12_14) do
        Measurement.new(uy: 9.10e-4, k:2.28, uexp: 2.0e-3, components: [
          stub(ux: 6.00e-4, c: 1, v: 2), 
          stub(ux: 6.80e-4, c: 1, v: Float::INFINITY) 
        ])
      end
    end 
  end

  module InstanceMethods
    RSpec::Matchers.define :comply_with_example do |ex_num|
      match do |actual|
        data = eval(ex_num.to_s)
        uy, k, uexp = data.uy, data.k, data.uexp
        data.compute!
        ((uy - data.uy).abs <= 0.01*uy) &&
        ((k - data.k).abs <= 0.01*k) &&
        ((uexp - data.uexp).abs <= 0.05*uexp)
      end
      failure_message_for_should do |actual|
        data = eval(ex_num.to_s)
        actual = data.compute
        "expected uy=#{data.uy}, got uy=#{actual.uy}." +
        "expected k=#{data.k}, got k=#{actual.k}." +
        "expected uexp=#{data.uexp}, got uexp=#{actual.uexp}."
      end
    end
  end
end






###          UncertaintyComponent.new(description: 'Reference Standard',
###                             qty: 'mS',       x: 10000.005, ux: 2.25e-2, dist: 'N', type: 'B', c: 1, v: Float::INFINITY), 
###          UncertaintyComponent.new(description: 'Drift of the value of the standard',
###                             qty: 'delta_mD', x: 0,         ux: 8.95e-3, dist: 'R', type: 'B', c: 1, v: Float::INFINITY), 
###          UncertaintyComponent.new(description: 'Comparator repeatability',
###                             qty: 'delta_m',  x: 2.00e-2  , ux: 1.44e-2, dist: 'N', type: 'A', c: 1, v: 2), 
###          UncertaintyComponent.new(description: 'Comparator eccentric loading',
###                             qty: 'delta_mC', x: 0,         ux: 5.77e-3, dist: 'R', type: 'B', c: 1, v: Float::INFINITY), 
###          UncertaintyComponent.new(description: 'Air bouyancy',
###                             qty: 'delta_B',  x: 0,         ux: 5.77e-3, dist: 'R', type: 'B', c: 1, v: Float::INFINITY) 
#
#
#
###          UncertaintyComponent.new(description: 'Reference Standard',
###                             qty: 'RS',        x: 10000.053, ux: 2.50e-3, dist: 'N', type: 'B', c: 1, v: Float::INFINITY), 
###          UncertaintyComponent.new(description: 'Drift of the value of the standard',
###                             qty: 'delta_RD',  x: 0,         ux: 5.80e-3, dist: 'R', type: 'B', c: 1, v: Float::INFINITY), 
###          UncertaintyComponent.new(description: 'Temperature corrections',
###                             qty: 'delta_RTS', x: 0,         ux: 1.60e-3, dist: 'R', type: 'B', c: 1, v: Float::INFINITY), 
###          UncertaintyComponent.new(description: 'Temperature corrections',
###                             qty: 'delta_RTX', x: 0,         ux: 3.20e-3, dist: 'R', type: 'B', c: 1, v: Float::INFINITY), 
###          UncertaintyComponent.new( description: 'DMM ratio specification',
###                             qty: 'rC',        x: 1,         ux: 4.10e-7, dist: 'T', type: 'B', c: 1e4, v: Float::INFINITY), 
###          UncertaintyComponent.new(description: 'Ratio measurements repeatability',
###                             qty: 'r',         x: 1.0000105, ux: 7.00e-8, dist: 'N', type: 'A', c: 1e4, v: 4) 
#
#
#
###          UncertaintyComponent.new(description: 'Reference Standard',
###                             qty: 'lS',       x: 50.000020, ux: 1.50e-8, dist: 'N', type: 'B', c: 1, v: Float::INFINITY), 
###          UncertaintyComponent.new(description: 'Drift of the value of the standard',
###                             qty: 'delta_lD', x: -9.40e-5,  ux: 1.73e-8, dist: 'T', type: 'B', c: 1, v: Float::INFINITY), 
###          UncertaintyComponent.new(description: 'Length difference measurements',
###                             qty: 'delta_l',  x: 0, ux: 5.37e-9, dist: 'A', type: 'B', c: 1, v: 4), 
###          UncertaintyComponent.new(description: 'Comparator non linearity / offset ',
###                             qty: 'delta_lC', x: 0, ux: 1.85e-8, dist: 'R', type: 'B', c: 1, v: Float::INFINITY), 
###          UncertaintyComponent.new(description: 'Temperature difference of blocks', 
###                             qty: 'delta_t',  x: 0, ux: 2.89e-2, dist: 'R', type: 'B', c: -5.75e-7, v: Float::INFINITY), 
###          UncertaintyComponent.new(description: 'Temperature and thermal expansion differences of blocks',
###                             qty: 'delta_a',  x: 0, ux: 2.36e-7, dist: 'S', type: 'B', c: 5.00e-2, v: Float::INFINITY), 
###          UncertaintyComponent.new(description: 'Non-central contact on blocks',
###                             qty: 'delta_lV', x: 0, ux: 3.87e-9, dist: 'R', type: 'B', c: -1, v: Float::INFINITY) 
#
#
#
###          UncertaintyComponent.new(description: 'Relative error of indication',
###                             qty: 'eX',       x: 1.00e-3, ux: 6.00e-4, dist: 'N', type: 'B', c: 1, v: 2), 
###          UncertaintyComponent.new(description: 'Repeatability of equipment',
###                            qty: 'delta_eX', x: 0,       ux: 6.80e-4, dist: 'N', type: 'A', c: 1, v: Float::INFINITY) 
