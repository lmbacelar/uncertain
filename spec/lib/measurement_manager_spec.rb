require_relative '../../lib/measurement_manager'

describe MeasurementManager do
  context 'Uncertainty calculations as per EA-4/02' do
    # EXAMPLES FROM EA-4/02
    #
    # S2 CALIBRATION OF A WEIGHT OF NOMINAL VALUE 10 KG
    # Simple example
    # NOTE: k, uexp of this example have been corrected, as EA/4-02 assumes k=2, which does not hold when checking
    #       using Welsh-Satterthwaite
    let(:s2_data) { [ stub(ux: 2.25e-2, c: 1, v: Float::INFINITY), 
                      stub(ux: 8.95e-3, c: 1, v: Float::INFINITY), 
                      stub(ux: 1.44e-2, c: 1, v: 2), 
                      stub(ux: 5.77e-3, c: 1, v: Float::INFINITY), 
                      stub(ux: 5.77e-3, c: 1, v: Float::INFINITY) ] }

    let(:s2_uy) { 2.93e-2 }; let(:s2_k) { 2.08 }; let(:s2_uexp) { 6.1e-2 }

    # S3 CALIBRATION OF NOMINAL 10 kOHM STANDARD RESISTOR
    # Some sensitivity Coefficients differ from 1
    let(:s3_data) { [stub(ux: 2.50e-3, c: 1,   v: Float::INFINITY), 
                     stub(ux: 5.80e-3, c: 1,   v: Float::INFINITY), 
                     stub(ux: 1.60e-3, c: 1,   v: Float::INFINITY), 
                     stub(ux: 3.20e-3, c: 1,   v: Float::INFINITY), 
                     stub(ux: 4.10e-7, c: 1e4, v: Float::INFINITY), 
                     stub(ux: 7.00e-8, c: 1e4, v: 4) ] } 
    let(:s3_uy) { 8.33e-3 }; let(:s3_k) { 2.00 }; let(:s3_uexp) { 1.7e-2 }

    # S4 CALIBRATION OF A GAUGE BLOCK OF NOMINAL LENGTH 50 MM
    # Special type distribution
    let(:s4_data) { [stub(ux: 1.50e-8, c: 1,        v: Float::INFINITY), 
                     stub(ux: 1.73e-8, c: 1,        v: Float::INFINITY), 
                     stub(ux: 5.37e-9, c: 1,        v: 4), 
                     stub(ux: 1.85e-8, c: 1,        v: Float::INFINITY), 
                     stub(ux: 2.89e-2, c: -5.75e-7, v: Float::INFINITY), 
                     stub(ux: 2.36e-7, c: 5.00e-2,  v: Float::INFINITY), 
                     stub(ux: 3.87e-9, c: -1,       v: Float::INFINITY) ] }
    let(:s4_uy) { 3.64e-8 }; let(:s4_k) { 2.00 }; let(:s4_uexp) { 7.3e-8 }

    # S5-17 CALIBRATION OF A TYPE N THERMOCOUPLE AT 1000°C 
    # All components with infinite degrees of freedom
    let(:s5_17_data) { [stub(ux: 1.00e-1, c: 1.00e+0,  v: Float::INFINITY), 
                        stub(ux: 1.00e+0, c: 7.70e-2,  v: Float::INFINITY), 
                        stub(ux: 2.90e-1, c: 7.70e-2,  v: Float::INFINITY), 
                        stub(ux: 1.15e+0, c: 7.70e-2,  v: Float::INFINITY), 
                        stub(ux: 5.80e-2, c: -4.07e-1, v: Float::INFINITY), 
                        stub(ux: 1.50e-1, c: 1.00e+0,  v: Float::INFINITY), 
                        stub(ux: 1.73e-1, c: 1.00e+0,  v: Float::INFINITY),
                        stub(ux: 5.77e-1, c: 1.00e+0,  v: Float::INFINITY) ] }
    let(:s5_17_uy) { 6.41e-1 }; let(:s5_17_k) { 2.00 }; let(:s5_17_uexp) { 1.3 }

    # S12.14 CALIBRATION OF A HOUSEHOLD WATER METER
    # Normality of uy not verified. k calculated through Welch-Satterthwaite and Inverse t-student distribution
    let(:s12_14_data) { [stub(ux: 6.00e-4, c: 1, v: 2), 
                         stub(ux: 6.80e-4, c: 1, v: Float::INFINITY) ] }
    let(:s12_14_uy) { 9.10e-4 }; let(:s12_14_k) { 2.28 }; let(:s12_14_uexp) { 2.0e-3 }


    # TEST EXAMPLE RESULTS
    [:s2, :s3, :s4, :s5_17, :s12_14].each do |e|
      it "should comply with example #{e.to_s}" do
        data = eval("#{e}_data")
        uy, k, uexp = eval("#{e}_uy"), eval("#{e}_k"), eval("#{e}_uexp")
        MeasurementManager.uy(data).should   be_within(0.01*uy).of(uy)
        MeasurementManager.k(data).should    be_within(0.01*k).of(k)
        MeasurementManager.uexp(data).should be_within(0.05*uexp).of(uexp)
      end
    end
  end
end
